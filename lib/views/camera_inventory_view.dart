import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tinread_rfid_scanner/providers/settings_provider.dart';
import 'package:tinread_rfid_scanner/services/localstorage_service.dart';
import 'package:tinread_rfid_scanner/utils/responsive.dart';
import 'package:tinread_rfid_scanner/utils/style.dart';
import 'package:tinread_rfid_scanner/widgets/alert_dialog.dart';

// TODO: autosave (check on crash)

class CameraInventoryView extends StatefulWidget {
  const CameraInventoryView({super.key});

  @override
  State<CameraInventoryView> createState() => _CameraInventoryViewState();
}

class _CameraInventoryViewState extends State<CameraInventoryView> with WidgetsBindingObserver {
  bool flash = false;

  late final AudioPlayer audioPlayer = AudioPlayer();
  late final MobileScannerController scannerController = MobileScannerController(
    cameraResolution: Size(1080, 1920),
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    detectionTimeoutMs: 1000,
    torchEnabled: flash,
    autoStart: true,
  );

  late List<String> codes;
  int failAttempts = 0;

  void _handleBarcode(BarcodeCapture result) async {
    String newCode = result.barcodes.first.rawValue!;

    if (!codes.contains(newCode)) {
      failAttempts = 0;

      setState(() {
        codes.add(newCode);
      });

      if (context.read<SettingsProvider>().settings.soundEnabled) {
        await audioPlayer.play(AssetSource("audio/beep.mp3"));
      }
    } else {
      failAttempts += 1;

      if (failAttempts >= 4) {
        await audioPlayer.play(AssetSource("audio/error.mp3"));
      }

      if (failAttempts >= 8) {
        failAttempts = 0;

        if (mounted) showInfoDialog(context, "Atenție", "Codul $newCode se află deja în listă");
      }
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    codes = LocalStorage.getCurrentInventory() ?? [];
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await scannerController.dispose();
    await LocalStorage.saveCurrentInventory(codes);
    WidgetsBinding.instance.removeObserver(this);
  }

  // save on app quit
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      await LocalStorage.saveCurrentInventory(codes);
    }
  }

  Widget buildBooksNumberText() {
    String text = "${codes.length} cărți scanate";

    if (codes.length == 1) {
      text = "O carte scanată";
    } else if (codes.length >= 20) {
      text = "${codes.length} de cărți scanate";
    }

    return Text(
      text,
      style: Theme.of(context).textTheme.labelMedium,
    );
  }

  Future<void> exportCodesToTxt() async {
    if (codes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lista este goală! Scanează ceva mai întâi.")),
      );
      return;
    }

    if (await Permission.storage.request().isDenied) {
      if (await Permission.manageExternalStorage.request().isDenied) {
        if (mounted) {
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

      String fileContent = codes.join("\r\n");
      await file.writeAsString(fileContent);

      if (mounted) showInfoDialog(context, "Export", "Găsești fișierul la calea:\n\n $filePath");
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Eroare la export: $e")),
        );
      }
    }
  }

  void resetList() {
    showConfirmDialog(
      context,
      title: "Reset",
      content: 'Ești sigur că vrei să ștergi lista de coduri?',
      onConfirm: () {
        setState(() {
          codes.clear();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kBackgroundColor,
          elevation: 2,
          titleSpacing: 0,
          centerTitle: true,
          title: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: "Inventariere",
                ),
              ],
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ),
          bottom: TabBar(
            labelColor: kPrimaryColor,
            indicatorColor: kPrimaryColor,
            indicatorWeight: 2.5,
            labelStyle: TextStyle(fontSize: 18),
            onTap: (int newIndex) {
              if (newIndex == 1) {
                setState(() {
                  flash = false;
                });
              }
            },
            tabs: [
              Tab(
                text: "Scanner",
              ),
              Tab(
                text: "Listă",
              ),
            ],
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.adaptive.arrow_back,
              color: kForegroundColor,
            ),
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: TabBarView(
            children: [
              Column(
                children: [
                  Expanded(
                    child: MobileScanner(
                      controller: scannerController,
                      fit: BoxFit.cover,
                      onDetect: _handleBarcode,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      bottom: Responsive.safePaddingBottom > 0 ? Responsive.safePaddingBottom : 12,
                      left: 24,
                      right: 24,
                      top: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [topShadow],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                flash = !flash;
                                scannerController.toggleTorch();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              iconSize: 22,
                            ),
                            icon: Padding(
                              padding: .only(right: 12),
                              child: FaIcon(
                                flash ? FontAwesomeIcons.solidLightbulb : FontAwesomeIcons.lightbulb,
                                color: Colors.white,
                              ),
                            ),

                            label: Text(
                              "Flash: ${flash ? "pornit" : "oprit"}",
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                        Spacer(),
                        FaIcon(
                          FontAwesomeIcons.book,
                          color: kPrimaryColor,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          codes.length.toString(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                    child: Row(
                      spacing: 12,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.book,
                          color: kPrimaryColor,
                          size: 24,
                        ),
                        buildBooksNumberText(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: .zero,
                      itemCount: codes.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: .symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: index % 2 == 0 ? lightGrey : kBackgroundColor,
                          ),
                          child: Row(
                            children: [
                              Text(codes[index]),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      bottom: Responsive.safePaddingBottom > 0 ? Responsive.safePaddingBottom : 12,
                      left: 12,
                      right: 12,
                      top: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [topShadow],
                    ),
                    child: Row(
                      spacing: 12,
                      children: [
                        OutlinedButton.icon(
                          onPressed: resetList,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            side: BorderSide(
                              color: kDangerIconColor,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          icon: Padding(
                            padding: .only(right: 12),
                            child: FaIcon(
                              FontAwesomeIcons.eraser,
                              size: 20,
                              color: kDangerIconColor,
                            ),
                          ),
                          label: Text(
                            "Reset",
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(color: kDangerTextColor),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: exportCodesToTxt,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: Text(
                              "Export Fișier",
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
