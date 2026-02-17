import 'package:flutter/services.dart';

class RfidService {
  static const platform = MethodChannel("com.imeromania.tinread_scanner/rfid");

  static final RfidService _instance = RfidService._internal();
  factory RfidService() => _instance;

  Function(List<String>)? onTagsReceived;

  RfidService._internal() {
    platform.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onTagsRead":
        List<dynamic> rawTags = call.arguments;
        List<String> tags = rawTags.cast<String>();

        if (onTagsReceived != null) {
          onTagsReceived!(tags);
        }
      default: 
        print("Unimplemented method: ${call.method}");
    }
  }

  Future<void> startScan() async {
    try {
      await platform.invokeMethod("startScan");
    } on PlatformException catch (e) {
      print("PlatformError: ${e.message}");
    }
  }

  Future<void> stopScan() async {
    try {
      await platform.invokeMethod("stopScan");
    } on PlatformException catch (e) {
      print("PlatformError: ${e.message}");
    }
  }

  Future<void> clearScan() async {
    try {
      await platform.invokeMethod("clearScan");
    } on PlatformException catch (e) {
      print("PlatformError: ${e.message}");
    }
  }
}
