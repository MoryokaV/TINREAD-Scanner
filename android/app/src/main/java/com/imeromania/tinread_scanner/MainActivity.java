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
    private BarcodeHandler barcodeHandler;
    private boolean barcodeReceiverRegistered;


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // shutdown rfid hardware on crash (not tested)
        Thread.UncaughtExceptionHandler defaultHandler = Thread.getDefaultUncaughtExceptionHandler();
        Thread.setDefaultUncaughtExceptionHandler((thread, throwable) -> {
            if (rfidHandler != null) {
                rfidHandler.shutdown();
            }

            if (defaultHandler != null) {
                defaultHandler.uncaughtException(thread, throwable);
            }
        });


        MethodChannel rfidMethodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), RFID_CHANNEL);
        rfidHandler = new RfidHandler(rfidMethodChannel);

        MethodChannel barcodeMethodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), BARCODE_CHANNEL);
        barcodeHandler = new BarcodeHandler(this, barcodeMethodChannel);

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

        barcodeMethodChannel.setMethodCallHandler(
            (call, result) -> {
                switch(call.method){
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

        barcodeReceiverRegistered = true;
        barcodeHandler.registerReceiver();
    }

    @Override
    protected void onResume() {
        super.onResume();

        barcodeReceiverRegistered = true;
        barcodeHandler.registerReceiver();
    }

    @Override
    protected void onPause() {
        super.onPause();

        barcodeReceiverRegistered = false;
        barcodeHandler.unregisterReceiver();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();

        rfidHandler.shutdown();
        if(barcodeReceiverRegistered){
            barcodeHandler.unregisterReceiver();
        }
    }
}