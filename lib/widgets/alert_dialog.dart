import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:tinread_scanner/l10n/generated/app_localizations.dart';
import 'package:tinread_scanner/utils/api_exceptions.dart';

bool _isDialogActive = false;

void showErrorDialog(BuildContext context, ApiException exception) {
  String title = "";
  String content = "";

  switch (exception) {
    case ServerException():
      title = AppLocalizations.of(context).errorDialogHeading;
      content = AppLocalizations.of(context).errorDialogContent;
    case UnauthorizedException():
      title = AppLocalizations.of(context).unauthDialogHeading;
      content = AppLocalizations.of(context).unauthDialogContent;
  }

  _showAdaptiveDialog(context, title, content);
}

void showInfoDialog(BuildContext context, String title, String content) => _showAdaptiveDialog(context, title, content);

void _showAdaptiveDialog(BuildContext context, String title, String content) {
  Future.delayed(Duration.zero, () {
    if (!context.mounted) return;

    if (_isDialogActive) return;

    _isDialogActive = true;

    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              child: const Text("Ok"),
              onPressed: () {
                _isDialogActive = false;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ).then((_) {
        _isDialogActive = false;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                _isDialogActive = false;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ).then((_) {
        _isDialogActive = false;
      });
    }
  });
}

void showConfirmDialog(
  BuildContext context, {
  required String title,
  required String content,
  required Function onConfirm,
}) {
  Future.delayed(Duration.zero, () {
    if (!context.mounted) return;

    if (_isDialogActive) return;

    _isDialogActive = true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anulează'),
          ),
          TextButton(
            onPressed: () {
              onConfirm();

              Navigator.pop(context);
            },
            child: const Text('Da'),
          ),
        ],
      ),
    ).then((_) {
      _isDialogActive = false;
    });
  });
}
