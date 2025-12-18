// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get signIn => 'Autentificare';

  @override
  String get username => 'Utilizator';

  @override
  String get usernameInputHint => 'ex: ionpopescu86';

  @override
  String get password => 'Parolă';

  @override
  String get rememberMe => 'Ține-mă minte';

  @override
  String get errorDialogHeading => 'Eroare';

  @override
  String get errorDialogContent =>
      'Auch! Serverul a întâmpinat o problemă. Reîncearcă mai târziu.';

  @override
  String get unauthDialogHeading => 'Autentificare';

  @override
  String get unauthDialogContent =>
      'Ne pare rău, utilizatorul sau parola sunt incorecte. Vă rugăm să încercați din nou.';

  @override
  String get home => 'Acasă';

  @override
  String get settings => 'Setări';

  @override
  String get requiredField => 'Acest câmp este obligatoriu';

  @override
  String get requiredUrlField => 'Introdu, te rog, un URL';

  @override
  String get invalidTINREADServer =>
      'Server TINREAD invalid. Încearcă din nou!';
}
