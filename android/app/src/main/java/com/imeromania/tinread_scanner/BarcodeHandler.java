package com.imeromania.tinread_scanner;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import io.flutter.plugin.common.MethodChannel;

public class BarcodeHandler {
    private Context context;
    private final MethodChannel methodChannel;
    private static final String SCAN_ACTION = "android.rfid.INPUT";
    private final Handler uiHandler = new Handler(Looper.getMainLooper());

    public BarcodeHandler(Context context, MethodChannel methodChannel) {
        this.methodChannel = methodChannel;
        this.context = context;
    }

    private final BroadcastReceiver barcodeReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();

            if (SCAN_ACTION.equals(action)) {
                Bundle extras = intent.getExtras();

                if (extras != null) {
                    for (String key : extras.keySet()) {
                        String value = extras.get(key).toString();

                        uiHandler.post(() -> {
                            methodChannel.invokeMethod("onTagRead", value);
                        });

                        debugLog("FOUND KEY: " + key + " ===> VALUE: " + value);
                    }
                }
            }
        }
    };

    @SuppressLint("UnspecifiedRegisterReceiverFlag")
    public void registerReceiver() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(SCAN_ACTION);

        context.registerReceiver(barcodeReceiver, filter);
    }

    public void unregisterReceiver() {
        context.unregisterReceiver(barcodeReceiver);
    }

    public void debugLog(String text) { Log.d("TINREAD_LOG", text); }
}