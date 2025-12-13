import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinread_rfid_scanner/views/login_view.dart';

class Routes {
  Routes._();

  static const home = '/home';
  static const login = "/login";
}

class PageRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return adaptivePageRoute(builder: (context) => const Scaffold());
      case Routes.login:
        return adaptivePageRoute(builder: (context) => LoginView());
      default:
        return null;
    }
  }

  static Route<dynamic> adaptivePageRoute({required Widget Function(BuildContext) builder}) {
    return Platform.isIOS ? CupertinoPageRoute(builder: builder) : MaterialPageRoute(builder: builder);
  }
}
