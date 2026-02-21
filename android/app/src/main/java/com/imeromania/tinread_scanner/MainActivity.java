package com.imeromania.tinread_scanner;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import cn.pda.serialport.Tools;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import com.handheld.uhfr.UHFRManager;
import com.uhf.api.cls.Reader;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


public class MainActivity extends FlutterActivity {
    private static final String RFID_CHANNEL = "com.imeromania.tinread_scanner/rfid";
    private final short RFID_TIMEOUT_MS = 100;
    public UHFRManager mUhfrManager;
    private final Set<String> uniqueEpcSet = Collections.synchronizedSet(new HashSet<>());
    private boolean isScanning = false;
    private final ExecutorService scanExecutor = Executors.newSingleThreadExecutor();
    private final Handler uiHandler = new Handler(Looper.getMainLooper());
    private MethodChannel rfidMethodChannel;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        rfidMethodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), RFID_CHANNEL);

        rfidMethodChannel.setMethodCallHandler(
            (call, result) -> {
                switch (call.method) {
                    case "syncSavedTags" -> syncSavedTags(call.arguments());
                    case "startScan" -> startRFIDScan();
                    case "stopScan" -> stopRFIDScan();
                    case "clearScan" -> clearRFIDScanData();
                    default -> result.notImplemented();
                }

                result.success(true);
            }
        );
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        debugLog("Native Java Startup Successful!");
        initRFIDModule();
    }

    private void initRFIDModule() {
        mUhfrManager = UHFRManager.getInstance();

        mUhfrManager.setRegion(Reader.Region_Conf.valueOf(1));
        mUhfrManager.setPower(30, 30);
        mUhfrManager.setGen2session(true);

        debugLog("RFID Module initialized");
    }

    private void syncSavedTags(List<String> savedTags) {
        if (savedTags != null) {
            uniqueEpcSet.addAll(savedTags);
        }
    }

    private void startRFIDScan() {
        if(isScanning) return;
        isScanning = true;

        debugLog("RFID start scan");

        mUhfrManager.asyncStartReading();

        scanExecutor.execute(() -> {
            while (isScanning) {
                try {
                    // TODO: check distance on read
                    List<Reader.TAGINFO> rawTags = mUhfrManager.tagInventoryRealTime();

                    if (rawTags != null && !rawTags.isEmpty()) {
                        List<String> newUniqueTagsToSend = new ArrayList<>();

                        for (Reader.TAGINFO taginfo : rawTags) {
                            String epc = Tools.Bytes2HexString(taginfo.EpcId, taginfo.EpcId.length);

                            if (uniqueEpcSet.add(epc)) {
                                newUniqueTagsToSend.add(epc);

                                debugLog("Tag nou: " + epc);
                            }
                        }

                        if (!newUniqueTagsToSend.isEmpty()) {
                            final List<String> flutterTags = new ArrayList<>(newUniqueTagsToSend);

                            uiHandler.post(() -> {
                                rfidMethodChannel.invokeMethod("onTagsRead", flutterTags);
                            });
                        }
                    }

                    Thread.sleep(RFID_TIMEOUT_MS);

                } catch (Exception e) {
                    debugLog("Scan Error: " + e.getMessage());
                }
            }
        });
    }

    private void stopRFIDScan() {
        debugLog("RFID stop scan");

        isScanning = false;
        UHFRManager.getInstance().asyncStopReading();
    }

    public void clearRFIDScanData() {
        uniqueEpcSet.clear();
    }

    private void debugLog(String text) { Log.d("TINREAD_LOG", text); }
}