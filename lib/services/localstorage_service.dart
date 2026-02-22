import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinread_scanner/models/appsettings_model.dart';
import 'package:tinread_scanner/models/tag_model.dart';
import 'package:tinread_scanner/models/user_model.dart' show User;

class _Keys {
  _Keys._();

  static const settings = 'app_settings';
  static const login = 'user';
  static const inventory = "current_inventory";
  static const tags = "saved_tags";
  static const scanType = "scan_type";
}

class LocalStorage {
  LocalStorage._();

  static late SharedPreferences _sharedPrefs;
  static late FlutterSecureStorage _secureStorage;

  static Future<void> init() async {
    _secureStorage = FlutterSecureStorage();
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  static AppSettings loadSettings() {
    String? settingsJSON = _sharedPrefs.getString(_Keys.settings);

    if (settingsJSON != null) {
      return AppSettings.fromJson(jsonDecode(settingsJSON));
    }

    return const AppSettings();
  }

  static Future<void> saveSettings(AppSettings settings) async {
    String settingsJSON = jsonEncode(settings.toJson());

    await _sharedPrefs.setString(_Keys.settings, settingsJSON);
  }

  static Future<void> saveCurrentInventory(List<String> items) async {
    await _sharedPrefs.setStringList(_Keys.inventory, items);
  }

  static List<String>? getCurrentInventory() {
    List<String>? scannedItems = _sharedPrefs.getStringList(_Keys.inventory);

    return scannedItems;
  }

  static Future<void> saveScannedTags(List<Tag> newTags) async {
    String tagsJSON = jsonEncode(newTags);

    await _sharedPrefs.setString(_Keys.tags, tagsJSON);
  }

  static List<Tag> loadSavedTags() {
    String? savedTagsJSON = _sharedPrefs.getString(_Keys.tags);

    if (savedTagsJSON != null) {
      return List<Tag>.from(
        jsonDecode(savedTagsJSON).map(
          (savedTagJSON) => Tag.fromJson(savedTagJSON),
        ),
      );
    }

    return [];
  }

  static Future<void> saveScanType(String type) async {
    await _sharedPrefs.setString(_Keys.scanType, type);
  }

  static ScanType? getScanType() {
    String? typeStr = _sharedPrefs.getString(_Keys.scanType);

    if (typeStr == null) {
      return null;
    }

    ScanType? type = ScanType.values.firstWhere((t) => t.toString() == typeStr);

    return type;
  }

  // -- SECURE STORAGE

  static Future<User?> getUserDetails() async {
    String? userDetails = await _secureStorage.read(key: _Keys.login);

    if (userDetails == null) {
      return null;
    }

    return User.fromJson(jsonDecode(userDetails));
  }

  static Future<void> saveUserDetails(User user) async {
    await _secureStorage.write(key: _Keys.login, value: jsonEncode(user));
  }

  static Future<void> deleteUserDetails() async {
    await _secureStorage.delete(key: _Keys.login);
  }
}
