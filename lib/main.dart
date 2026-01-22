import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tinread_rfid_scanner/l10n/generated/app_localizations.dart';
import 'package:tinread_rfid_scanner/models/user_model.dart';
import 'package:tinread_rfid_scanner/providers/connectivity_provider.dart';
import 'package:tinread_rfid_scanner/providers/settings_provider.dart';
import 'package:tinread_rfid_scanner/providers/user_provider.dart';
import 'package:tinread_rfid_scanner/services/localstorage_service.dart';
import 'package:tinread_rfid_scanner/utils/navigation_util.dart';
import 'package:tinread_rfid_scanner/utils/responsive.dart';
import 'package:tinread_rfid_scanner/utils/router.dart';
import 'package:tinread_rfid_scanner/utils/style.dart';

late final String initialRoute;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Responsive.init();

  await LocalStorage.init();

  User? user = await LocalStorage.getUserDetails();
  // initialRoute = user == null ? Routes.login : Routes.home;

  initialRoute = Routes.home;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(user)),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TINREAD RFID Scanner',
      initialRoute: initialRoute,
      navigatorKey: NavigationUtil.navigatorKey,
      onGenerateRoute: PageRouter.generateRoute,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale("ro"), // for testing purposes only
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
