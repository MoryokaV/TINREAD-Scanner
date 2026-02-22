import 'package:flutter/material.dart';
import 'package:tinread_scanner/models/tag_model.dart';
import 'package:tinread_scanner/services/localstorage_service.dart';
import 'package:tinread_scanner/services/rfid_service.dart';

class TagsProvider extends ChangeNotifier {
  late ScanType? activeScanType;
  late List<Tag> scannedTags;
  late final RfidService _rfidService;

  TagsProvider() {
    scannedTags = LocalStorage.loadSavedTags();
    activeScanType = LocalStorage.getScanType();

    _sync();
  }

  Future<void> _sync() async {
    List<String> tids = scannedTags.map((tag) => tag.tid).toList();

    _rfidService = RfidService();
    await _rfidService.syncSavedTids(tids);
  }

  Future<void> save(List<Tag> newTags) async {
    scannedTags = newTags;

    await LocalStorage.saveScannedTags(scannedTags);

    notifyListeners();
  }

  void removeElementByTid(String tid) {
    scannedTags.removeWhere((tag) => tag.tid == tid);

    notifyListeners();
  }

  Future<void> clear() async {
    scannedTags = [];

    await _rfidService.clearScan();
    await LocalStorage.saveScannedTags(scannedTags);

    notifyListeners();
  }

  Future<void> setActiveScanType(ScanType newType) async {
    activeScanType = newType;
    await LocalStorage.saveScanType(activeScanType.toString());

    notifyListeners();
  }
}
