import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tinread_scanner/models/tag_model.dart';
import 'package:tinread_scanner/widgets/alert_dialog.dart';

class ExportFileService {
  ExportFileService._();

  static Future<void> exportTagsToTxt(List<Tag> tags, BuildContext context) async {
    if (tags.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lista este goală! Scanează ceva mai întâi.")),
        );
      }

      return;
    }

    if (await Permission.storage.request().isDenied) {
      if (await Permission.manageExternalStorage.request().isDenied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Permisiune refuzată! Nu pot salva fișierul.")),
          );
        }

        return;
      }
    }

    try {
      Directory downloadsDirectory = Directory('/storage/emulated/0/Download');

      if (!await downloadsDirectory.exists()) {
        downloadsDirectory = Directory('/storage/emulated/0/Documents');
      }

      final String fileName = "Inventar_${DateTime.now().millisecondsSinceEpoch}.txt";
      final String filePath = "${downloadsDirectory.path}/$fileName";
      final File file = File(filePath);

      String fileContent = tags.map((e) => e.tid).join("\r\n");
      await file.writeAsString(fileContent);

      if (context.mounted) showInfoDialog(context, "Export", "Găsești fișierul la calea:\n\n $filePath");
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Eroare la export: $e")),
        );
      }
    }
  }
}
