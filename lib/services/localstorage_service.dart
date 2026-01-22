import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinread_rfid_scanner/models/appsettings_model.dart';
import 'package:tinread_rfid_scanner/models/user_model.dart' show User;

class _Keys {
  _Keys._();

  static const settings = 'app_settings';
  static const login = 'user';
  static const inventory = "current_inventory";
}

class LocalStorage {
  LocalStorage._();

  static late SharedPreferences sharedPrefs;
  static late FlutterSecureStorage secureStorage;

  static Future<void> init() async {
    secureStorage = FlutterSecureStorage();
    sharedPrefs = await SharedPreferences.getInstance();
  }

  static AppSettings loadSettings() {
    String? settingsJSON = sharedPrefs.getString(_Keys.settings);

    if (settingsJSON != null) {
      return AppSettings.fromJson(jsonDecode(settingsJSON));
    }

    return const AppSettings();
  }

  static Future<void> saveSettings(AppSettings settings) async {
    String settingsJSON = jsonEncode(settings.toJson());

    await sharedPrefs.setString(_Keys.settings, settingsJSON);
  }

  static Future<void> saveCurrentInventory(List<String> items) async {
    await sharedPrefs.setStringList(_Keys.inventory, items);
  }

  static List<String>? getCurrentInventory() {
    List<String>? scannedItems = sharedPrefs.getStringList(_Keys.inventory);

    return scannedItems;
  }

  // -- SECURE STORAGE

  static Future<User?> getUserDetails() async {
    String? userDetails = await secureStorage.read(key: _Keys.login);

    if (userDetails == null) {
      return null;
    }

    return User.fromJson(jsonDecode(userDetails));
  }

  static Future<void> saveUserDetails(User user) async {
    await secureStorage.write(key: _Keys.login, value: jsonEncode(user));
  }

  static Future<void> deleteUserDetails() async {
    await secureStorage.delete(key: _Keys.login);
  }
}
