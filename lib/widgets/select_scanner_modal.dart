import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tinread_rfid_scanner/utils/responsive.dart';
import 'package:tinread_rfid_scanner/utils/router.dart';
import 'package:tinread_rfid_scanner/utils/style.dart';

void openScannerSelectModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    constraints: BoxConstraints(),
    builder: (BuildContext context) {
      return TapRegion(
        onTapOutside: (_) => Navigator.pop(context),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: Responsive.safeBlockHorizontal * 15,
                    height: 5,
                    decoration: BoxDecoration(
                      color: lightGrey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Selectează metoda de inventariere",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, Routes.rfidInventory),
                  borderRadius: BorderRadius.circular(16),
                  child: Ink(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: lightGrey, width: 1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      spacing: 12,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: SvgPicture.asset(
                            "assets/icons/signal.svg",
                            width: Responsive.safeBlockHorizontal * 18,
                            fit: BoxFit.contain,
                            colorFilter: ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
                          ),
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            spacing: 6,
                            children: [
                              Text(
                                "Cititor RFID",
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              Text(
                                "Scanează automat etichetele din apropiere, folosind cititorul dispozitivului",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, Routes.cameraInventory),
                  borderRadius: BorderRadius.circular(16),
                  child: Ink(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: lightGrey, width: 1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      spacing: 12,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: SvgPicture.asset(
                            "assets/icons/barcode-scanner.svg",
                            width: Responsive.safeBlockHorizontal * 18,
                            fit: BoxFit.contain,
                            colorFilter: ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
                          ),
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            spacing: 6,
                            children: [
                              Text(
                                "Scanner coduri de bare",
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              Text(
                                "Realizează inventarierea apăsând butonul portocaliu de declanșare a senzorului",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (Responsive.safePaddingBottom == 0) const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
    },
  );
}
