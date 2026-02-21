import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tinread_scanner/l10n/generated/app_localizations.dart';
import 'package:tinread_scanner/providers/connectivity_provider.dart';
import 'package:tinread_scanner/providers/tags_provider.dart';
import 'package:tinread_scanner/utils/responsive.dart';
import 'package:tinread_scanner/utils/style.dart';
import 'package:tinread_scanner/widgets/alert_dialog.dart';
import 'package:tinread_scanner/widgets/select_scanner_modal.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Widget buildMultimediaItemContainer(
    BuildContext context, {
    required String icon,
    required String name,
    required void Function() onTap,
  }) {
    double itemSize = (Responsive.screenWidth - 39) / 2;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Ink(
        width: itemSize,
        height: itemSize,
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1,
            color: lightGrey,
          ),
        ),
        child: Column(
          spacing: 15,
          mainAxisAlignment: .center,
          children: [
            SvgPicture.asset(
              icon,
              width: 72,
              colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
            ),
            Text(
              name,
              textScaler: Responsive.textScalingNone,
              textAlign: .center,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontSize: 16,
                color: kForegroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 24,
        ),
        child: Column(
          children: [
            Image.asset(
              "assets/images/tinread_tiny.png",
              width: Responsive.screenWidth / 2,
            ),
            SizedBox(height: Responsive.safeBlockVertical * 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "UNȘTPB - Centrul Universitar Pitești",
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: .center,
              ),
            ),
            SizedBox(height: Responsive.safeBlockVertical * 3),
            Consumer<ConnectivityProvider>(
              builder: (context, connectivity, _) {
                return Container(
                  padding: EdgeInsets.only(
                    left: 20,
                    top: 10,
                    bottom: 10,
                    right: 20,
                  ),
                  decoration: BoxDecoration(
                    color: connectivity.isOnline ? kSuccessIconColor : kDangerIconColor,
                    borderRadius: .circular(100),
                  ),
                  child: Row(
                    spacing: 12,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: .circular(100),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white, height: 1),
                          children: [
                            TextSpan(
                              text: "${AppLocalizations.of(context).deviceStatus}: ",
                            ),
                            TextSpan(
                              text: connectivity.isOnline ? "online" : "offline",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Spacer(),
            Wrap(
              spacing: 15,
              runSpacing: 15,
              alignment: WrapAlignment.spaceBetween,
              children: [
                buildMultimediaItemContainer(
                  context,
                  icon: "assets/icons/book.svg",
                  name: AppLocalizations.of(context).inventory,
                  onTap: () => openScannerSelectModal(context),
                ),
                buildMultimediaItemContainer(
                  context,
                  icon: "assets/icons/upload.svg",
                  name: AppLocalizations.of(context).uploadToTINREAD,
                  onTap: () {},
                ),
                buildMultimediaItemContainer(
                  context,
                  icon: "assets/icons/download.svg",
                  name: AppLocalizations.of(context).downloadFile,
                  onTap: () {},
                ),
                buildMultimediaItemContainer(
                  context,
                  icon: "assets/icons/eraser.svg",
                  name: AppLocalizations.of(context).reset,
                  onTap: () {
                    showConfirmDialog(
                      context,
                      title: "Atenție!",
                      content: "Ești sigur că vrei să ștergi toate etichetele scanate?",
                      onConfirm: () async {
                        await context.read<TagsProvider>().clear();
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
