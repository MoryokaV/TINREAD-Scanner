import 'package:flutter/material.dart';

const Color kBackgroundColor = Color(0xfffaf9f8);
const Color kBlackColor = Color(0xff343a40);
const Color kForegroundColor = Color(0xff495057);
const Color kPrimaryColor = Color(0xffff6044);
const Color kPrimaryColorDarkShade = Color(0xffe0482d);
const Color kSecondaryColor = Color(0xff3982c3);
const Color kDimmedForegroundColor = Color(0xff868E96);
Color kDisabledIconColor = Colors.grey[500]!;
const Color lightGrey = Color(0xFFE5E7EB);
const Color lighterGrey = Color(0xFFF3F4F6);

const Color kDangerTextColor = Color(0xffDC2626);
const Color kDangerIconColor = Color(0xffEF4444);
const Color kWarningTextColor = Color(0xffD97706);
const Color kWarningIconColor = Color(0xffF59E0B);
const Color kSuccessTextColor = Color(0xff059669);
const Color kSuccessIconColor = Color(0xff10B981);

const BoxShadow shadowSm = BoxShadow(
  color: Colors.black26,
  offset: Offset(0, 1),
  blurRadius: 2,
  spreadRadius: 1,
);

const BoxShadow bottomShadowSm = BoxShadow(
  color: Colors.black26,
  offset: Offset(0, 2),
  blurRadius: 10,
  spreadRadius: -4,
);

const BoxShadow bottomShadowLg = BoxShadow(
  color: Colors.black45,
  offset: Offset(0, 4),
  blurRadius: 10,
  spreadRadius: -5,
);

const BoxShadow globalShadow = BoxShadow(
  color: Colors.black12,
  offset: Offset(0, 0),
  spreadRadius: 1,
  blurRadius: 3,
);

const BoxShadow topShadow = BoxShadow(
  color: Colors.black12,
  offset: Offset(0, -1.5),
  blurRadius: 4,
  spreadRadius: 0.5,
);

const List<BoxShadow> shadowLg = [
  BoxShadow(
    color: Colors.black12,
    offset: Offset(0, 10),
    blurRadius: 15,
    spreadRadius: -3,
  ),
  BoxShadow(
    color: Colors.black12,
    offset: Offset(0, 4),
    blurRadius: 6,
    spreadRadius: -4,
  ),
];

const String bodyFont = "Lato";
const String serifFont = "Spectral";

final ThemeData appTheme = ThemeData(
  useMaterial3: false,
  scaffoldBackgroundColor: kBackgroundColor,
  primaryColor: kPrimaryColor,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: kSecondaryColor,
    primary: kPrimaryColor,
  ),
  textTheme: const TextTheme(
    labelLarge: TextStyle(
      color: kBlackColor,
      fontFamily: bodyFont,
      fontWeight: FontWeight.w500,
      fontSize: 18,
    ),
    labelMedium: TextStyle(
      color: kDimmedForegroundColor,
      fontFamily: bodyFont,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ),
    labelSmall: TextStyle(
      color: kDimmedForegroundColor,
      fontFamily: bodyFont,
      letterSpacing: 0,
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
    bodyLarge: TextStyle(
      color: kForegroundColor,
      fontFamily: bodyFont,
      fontSize: 18,
    ),
    bodyMedium: TextStyle(
      color: kForegroundColor,
      fontFamily: bodyFont,
      fontSize: 16,
    ),
    displayLarge: TextStyle(
      color: kBlackColor,
      fontFamily: bodyFont,
      fontSize: 24,
      height: 1.4,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
    ),
    displayMedium: TextStyle(
      color: kBlackColor,
      fontFamily: bodyFont,
      fontWeight: FontWeight.w700,
      fontSize: 20,
      height: 1.3,
      letterSpacing: -0.2,
    ),
    displaySmall: TextStyle(
      color: kBlackColor,
      fontFamily: bodyFont,
      fontWeight: FontWeight.w600,
      fontSize: 18,
      height: 1.3,
      letterSpacing: -0.1,
    ),
    headlineSmall: TextStyle(
      color: kForegroundColor,
      fontFamily: bodyFont,
      letterSpacing: -0.1,
      fontWeight: FontWeight.w500,
      fontSize: 18,
    ),
    headlineMedium: TextStyle(
      color: kForegroundColor,
      fontFamily: bodyFont,
      letterSpacing: -0.1,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
    headlineLarge: TextStyle(
      color: kForegroundColor,
      fontFamily: bodyFont,
      letterSpacing: -0.1,
      fontWeight: FontWeight.w600,
      fontSize: 22,
    ),
  ),
);
