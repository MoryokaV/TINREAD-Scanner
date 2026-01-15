package com.imeromania.tinread_rfid_scanner;

import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import com.uhf.api.cls.Reader;

public class MainActivity extends FlutterActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Option A: Standard Java Print (Harder to find in logs)
        System.out.println("TINREAD_LOG: Native Java Startup Successful!");

        // Option B: Android Log (Recommended - Easier to find)
        // You can filter Logcat by searching for "TINREAD_TAG"
        android.util.Log.d("TINREAD_TAG", "Native Java Startup Successful!");
    }

}
