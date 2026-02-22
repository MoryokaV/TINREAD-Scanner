package com.imeromania.tinread_scanner;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.handheld.uhfr.UHFRManager;
import com.uhf.api.cls.Reader;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import cn.pda.serialport.Tools;
import io.flutter.plugin.common.MethodChannel;

public class RfidHandler {
    private final MethodChannel methodChannel;

    private final ExecutorService scanExecutor = Executors.newSingleThreadExecutor();
    private final Handler uiHandler = new Handler(Looper.getMainLooper());

    private final Set<String> uniqueEpcSet = Collections.synchronizedSet(new HashSet<>());
    private boolean isScanning = false;
    private final short RFID_TIMEOUT_MS = 100;

    public UHFRManager mUhfrManager;


    public RfidHandler(MethodChannel methodChannel) {
        this.methodChannel = methodChannel;
    }


    public void initRFIDModule() {
        mUhfrManager = UHFRManager.getInstance();

        mUhfrManager.setRegion(Reader.Region_Conf.valueOf(1));
        mUhfrManager.setPower(30, 30);
        mUhfrManager.setGen2session(true);

        // debugLog("RFID Module initialized");
    }

    public void syncSavedTags(List<String> savedTags) {
        if (savedTags != null) {
            uniqueEpcSet.addAll(savedTags);
        }
    }

    public void startRFIDScan() {
        if(isScanning) return;
        isScanning = true;

        // debugLog("RFID start scan");

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
                                methodChannel.invokeMethod("onTagsRead", flutterTags);
                            });
                        }
                    }

                    Thread.sleep(RFID_TIMEOUT_MS);

                } catch (Exception e) {
                    // debugLog("Scan Error: " + e.getMessage());
                }
            }
        });
    }

    public void stopRFIDScan() {
        // debugLog("RFID stop scan");

        isScanning = false;
        mUhfrManager.asyncStopReading();
    }

    public void shutdown() {
        stopRFIDScan();
        mUhfrManager.close();
    }

    public void clearRFIDScanData() {
        uniqueEpcSet.clear();
    }

    public void debugLog(String text) { Log.d("TINREAD_LOG", text); }
}