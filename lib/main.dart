import 'package:flutter/material.dart';
import 'package:tinread_rfid_scanner/utils/navigation_util.dart';
import 'package:tinread_rfid_scanner/utils/responsive.dart';
import 'package:tinread_rfid_scanner/utils/router.dart';
import 'package:tinread_rfid_scanner/utils/style.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Responsive.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TINREAD RFID Scanner',
      initialRoute: Routes.login,
      navigatorKey: NavigationUtil.navigatorKey,
      onGenerateRoute: PageRouter.generateRoute,
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
      // locale: Locale("en"), // for testing purposes only
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) {
          return const Locale('en'); // Default to English
        }
        // Use device locale it is supported
        for (final supportedLanguage in supportedLocales) {
          if (locale.languageCode == supportedLanguage.languageCode) {
            return supportedLanguage;
          }
        }

        // If device locale not supported, fallback to English
        return const Locale('en');
      },
      theme: appTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
