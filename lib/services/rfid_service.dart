import 'package:flutter/services.dart';

class RfidService {
  static const _platform = MethodChannel("com.imeromania.tinread_scanner/rfid");

  static final RfidService _instance = RfidService._internal();
  factory RfidService() => _instance;

  Function(List<String>)? onTagsReceived;

  RfidService._internal() {
    _platform.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onTagsRead":
        List<dynamic> rawTids = call.arguments;
        List<String> tids = rawTids.cast<String>();

        if (onTagsReceived != null) {
          onTagsReceived!(tids);
        }
      default:
        print("Unimplemented method: ${call.method}");
    }
  }

  Future<void> startScan() async {
    try {
      await _platform.invokeMethod("startScan");
    } on PlatformException catch (e) {
      print("PlatformError: ${e.message}");
    }
  }

  Future<void> stopScan() async {
    try {
      await _platform.invokeMethod("stopScan");
    } on PlatformException catch (e) {
      print("PlatformError: ${e.message}");
    }
  }

  Future<void> clearScan() async {
    try {
      await _platform.invokeMethod("clearScan");
    } on PlatformException catch (e) {
      print("PlatformError: ${e.message}");
    }
  }

  Future<void> syncSavedTids(List<String> tids) async {
    try {
      await _platform.invokeMethod("syncSavedTags", tids);
    } on PlatformException catch (e) {
      print("PlatformError: ${e.message}");
    }
  }
}
