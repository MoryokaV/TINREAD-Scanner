import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tinread_scanner/l10n/generated/app_localizations.dart';
import 'package:tinread_scanner/models/user_model.dart';
import 'package:tinread_scanner/providers/settings_provider.dart';
import 'package:tinread_scanner/providers/user_provider.dart';
import 'package:tinread_scanner/utils/responsive.dart';
import 'package:tinread_scanner/utils/router.dart';
import 'package:tinread_scanner/utils/style.dart';
import 'package:tinread_scanner/widgets/custom_switch.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  User? user;
  late UserProvider userProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    userProvider = Provider.of<UserProvider>(context, listen: true);
    user = userProvider.currentUser;
  }

  void _logoutUser() async {
    await userProvider.logout();

    if (mounted) Navigator.pushNamedAndRemoveUntil(context, Routes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>().settings;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: Responsive.safeBlockHorizontal * 10,
                right: Responsive.safeBlockHorizontal * 5,
                bottom: Responsive.safeBlockVertical * 5,
              ),
              child: Row(
                spacing: 5,
                mainAxisAlignment: .center,
                crossAxisAlignment: .start,
                children: [
                  SvgPicture.asset(
                    "assets/icons/bookshelves.svg",
                    height: Responsive.safeBlockVertical * 16,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          "Utilizator",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "UNȘTPB - Centrul Universitar Pitești",
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: kDimmedForegroundColor),
                        ),
                        SizedBox(height: 15),
                        InkWell(
                          onTap: _logoutUser,
                          splashColor: kPrimaryColor.withAlpha(40),
                          highlightColor: kPrimaryColor.withAlpha(50),
                          child: Ink(
                            padding: EdgeInsets.only(bottom: 2),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: kPrimaryColor,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: .min,
                              spacing: 10,
                              children: [
                                Text(
                                  AppLocalizations.of(context).logout,
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                  ),
                                ),
                                SvgPicture.asset(
                                  "assets/icons/logout.svg",
                                  width: 20,
                                  colorFilter: ColorFilter.mode(
                                    kPrimaryColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            MenuTile(
              title: AppLocalizations.of(context).sound,
              leading: SizedBox(
                height: 30,
                child: CustomSwitch(
                  enabled: settings.soundEnabled,
                  onTap: () {
                    context.read<SettingsProvider>().setSound(!settings.soundEnabled);
                  },
                ),
              ),
            ),

            MenuTile(
              title: AppLocalizations.of(context).checkForUpdates,
              leading: FaIcon(
                FontAwesomeIcons.chevronRight,
                color: kDisabledIconColor,
                size: 18,
              ),
            ),
            MenuTile(
              title: AppLocalizations.of(context).privacyPolicy,
              leading: FaIcon(
                FontAwesomeIcons.chevronRight,
                color: kDisabledIconColor,
                size: 18,
              ),
            ),
            MenuTile(
              title: "${AppLocalizations.of(context).about} TINREAD RFID Scanner",
              leading: FaIcon(
                FontAwesomeIcons.chevronRight,
                color: kDisabledIconColor,
                size: 18,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                //TODO: dynamic build and version
                "Powered by IME România 2026 © v1.0.1 build 1436",
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class MenuTile extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final Widget leading;

  const MenuTile({
    super.key,
    this.onTap,
    required this.title,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              child: Row(
                spacing: 6,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: kForegroundColor,
                      fontWeight: FontWeight.w400,
                    ),
                    textScaler: Responsive.textScalingNone,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: leading,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Divider(
                thickness: 1,
                height: 1,
                color: lightGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
