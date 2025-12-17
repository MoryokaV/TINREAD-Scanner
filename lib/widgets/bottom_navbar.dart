import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tinread_rfid_scanner/l10n/generated/app_localizations.dart';
import 'package:tinread_rfid_scanner/utils/style.dart';
import 'package:tinread_rfid_scanner/views/home_view.dart';
import 'package:tinread_rfid_scanner/views/settings_view.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int pageIndex = 0;

  void switchPage(int newIndex) {
    setState(() => pageIndex = newIndex);
  }

  AppBar? getAppBar(BuildContext context) {
    switch (pageIndex) {
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomeView(),
      SettingsView(),
    ];

    return Scaffold(
      body: pages[pageIndex],
      appBar: getAppBar(context),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 10,
          unselectedFontSize: 14,
          selectedFontSize: 16,
          iconSize: 24,
          unselectedLabelStyle: const TextStyle(fontFamily: bodyFont),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: bodyFont,
          ),
          type: BottomNavigationBarType.fixed,
          currentIndex: pageIndex,
          items: [
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.solidHouse),
              label: AppLocalizations.of(context).home,
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.gear),
              label: AppLocalizations.of(context).settings,
            ),
          ],
          onTap: switchPage,
        ),
      ),
    );
  }
}
