import 'package:flutter/material.dart';
import 'package:tinread_scanner/models/appsettings_model.dart';
import 'package:tinread_scanner/services/localstorage_service.dart';

class SettingsProvider extends ChangeNotifier {
  late AppSettings settings;

  SettingsProvider() {
    settings = LocalStorage.loadSettings();

    notifyListeners();
  }

  Future<void> _save() async {
    notifyListeners();

    await LocalStorage.saveSettings(settings);
  }

  void setSound(bool value) {
    settings = settings.copyWith(soundEnabled: value);

    _save();
  }

  void setVibration(bool value) {
    settings = settings.copyWith(vibrationEnabled: value);

    _save();
  }

  void setScanPower(int value) {
    settings = settings.copyWith(scanPower: value);

    _save();
  }
}
