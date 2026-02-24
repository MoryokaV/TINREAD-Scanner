import 'package:flutter/services.dart';

class BarcodeService {
  static const _platform = MethodChannel("com.imeromania.tinread_scanner/barcode");

  static final BarcodeService _instance = BarcodeService._internal();
  factory BarcodeService() => _instance;

  Function(String)? onTagReceived;

  BarcodeService._internal() {
    _platform.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onTagRead":
        String tid = call.arguments;

        if (onTagReceived != null) {
          onTagReceived!(tid);
        }
      default:
        print("Unimplemented method: ${call.method}");
    }
  }
}
