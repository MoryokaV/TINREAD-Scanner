import 'package:flutter/foundation.dart';
import 'package:tinread_scanner/models/user_model.dart';
import 'package:tinread_scanner/services/localstorage_service.dart';

class UserProvider extends ChangeNotifier {
  User? currentUser;

  UserProvider(User? user) {
    currentUser = user;
  }

  Future<void> setUser(User user, bool rememberMe) async {
    if (rememberMe) await LocalStorage.saveUserDetails(user);

    currentUser = user;

    notifyListeners();
  }

  Future<void> logout() async {
    await LocalStorage.deleteUserDetails();

    currentUser = null;

    notifyListeners();
  }
}
