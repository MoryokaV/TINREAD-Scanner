// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get signIn => 'Sign In';

  @override
  String get username => 'Username';

  @override
  String get usernameInputHint => 'e.g. johnpeter86';

  @override
  String get password => 'Password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get errorDialogHeading => 'Error';

  @override
  String get errorDialogContent =>
      'Oops! The server encountered a problem. Please try again later.';

  @override
  String get unauthDialogHeading => 'Sign in';

  @override
  String get unauthDialogContent =>
      'Sorry, your username or password is incorrect. Please try again.';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get requiredField => 'This field is required';

  @override
  String get requiredUrlField => 'Please enter a URL';

  @override
  String get invalidTINREADServer => 'Invalid TINREAD server. Try again!';

  @override
  String get inventory => 'Inventory';

  @override
  String get uploadToTINREAD => 'Upload to TINREAD';

  @override
  String get downloadFile => 'Download file';

  @override
  String get reset => 'Reset';
}
