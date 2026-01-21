import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinread_rfid_scanner/views/camera_inventory_view.dart';
import 'package:tinread_rfid_scanner/views/inventory_view.dart';
import 'package:tinread_rfid_scanner/views/login_view.dart';
import 'package:tinread_rfid_scanner/widgets/bottom_navbar.dart';

class Routes {
  Routes._();

  static const login = "/login";
  static const home = '/home';
  static const inventory = "/inventory";
}

class PageRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return adaptivePageRoute(builder: (context) => const BottomNavbar());
      case Routes.login:
        return adaptivePageRoute(builder: (context) => LoginView());
      case Routes.inventory:
        return adaptivePageRoute(builder: (context) => CameraInventoryView());
      default:
        return null;
    }
  }

  static Route<dynamic> adaptivePageRoute({required Widget Function(BuildContext) builder}) {
    return Platform.isIOS ? CupertinoPageRoute(builder: builder) : MaterialPageRoute(builder: builder);
  }
}
