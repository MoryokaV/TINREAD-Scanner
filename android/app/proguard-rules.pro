# C++ classes (JNI)
-keepclasseswithmembernames class * {
    native <methods>;
}

# SDK RFID & Serial Port
-keep class cn.pda.serialport.** { *; }
-keep class com.handheld.uhfr.** { *; }
-keep class cn.com.example.rfid.** { *; }
-keep class com.gg.reader.** { *; }
-keep class com.rfid.trans.** { *; }
-keep class com.uhf.api.** { *; }

# no warnings
-dontwarn cn.pda.serialport.**
-dontwarn com.handheld.uhfr.**
-dontwarn cn.com.example.rfid.**
-dontwarn com.gg.reader.**
-dontwarn com.rfid.trans.**
-dontwarn com.uhf.api.**