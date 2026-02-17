import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinread_scanner/views/camera_inventory_view.dart';
import 'package:tinread_scanner/views/rfid_inventory_view.dart';
import 'package:tinread_scanner/views/login_view.dart';
import 'package:tinread_scanner/widgets/bottom_navbar.dart';

class Routes {
  Routes._();

  static const login = "/login";
  static const home = '/home';
  static const cameraInventory = "/camera_inventory";
  static const rfidInventory = "/rfid_inventory";
}

class PageRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return adaptivePageRoute(builder: (context) => const BottomNavbar());
      case Routes.login:
        return adaptivePageRoute(builder: (context) => LoginView());
      case Routes.cameraInventory:
        return adaptivePageRoute(builder: (context) => CameraInventoryView());
      case Routes.rfidInventory:
        return adaptivePageRoute(builder: (context) => RfidInventoryView());
      default:
        return null;
    }
  }

  static Route<dynamic> adaptivePageRoute({required Widget Function(BuildContext) builder}) {
    return Platform.isIOS ? CupertinoPageRoute(builder: builder) : MaterialPageRoute(builder: builder);
  }
}
