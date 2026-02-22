package com.imeromania.tinread_scanner;

import android.os.Bundle;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity {
    private static final String RFID_CHANNEL = "com.imeromania.tinread_scanner/rfid";
    private static final String BARCODE_CHANNEL = "com.imeromania.tinread_scanner/barcode";

    private RfidHandler rfidHandler;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        MethodChannel rfidMethodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), RFID_CHANNEL);
        rfidHandler = new RfidHandler(rfidMethodChannel);

        rfidMethodChannel.setMethodCallHandler(
            (call, result) -> {
                switch (call.method) {
                    case "syncSavedTags" -> rfidHandler.syncSavedTags(call.arguments());
                    case "startScan" -> rfidHandler.startRFIDScan();
                    case "stopScan" -> rfidHandler.stopRFIDScan();
                    case "clearScan" -> rfidHandler.clearRFIDScanData();
                    default -> result.notImplemented();
                }

                result.success(true);
            }
        );
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        rfidHandler.initRFIDModule();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();

        rfidHandler.shutdown();
    }
}