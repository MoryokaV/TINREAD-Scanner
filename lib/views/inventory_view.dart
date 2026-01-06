import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tinread_rfid_scanner/l10n/generated/app_localizations.dart';
import 'package:tinread_rfid_scanner/utils/responsive.dart';
import 'package:tinread_rfid_scanner/utils/style.dart';

class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  late List<String> filters = [];
  late String selectedFilter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    filters = [AppLocalizations.of(context).all, AppLocalizations.of(context).errors];
    selectedFilter = filters[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconTheme.of(context).copyWith(color: kForegroundColor),
        title: Text(
          AppLocalizations.of(context).inventory,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [bottomShadowSm],
              ),
              child: Column(
                spacing: 20,
                children: [
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      SizedBox(
                        child: Row(
                          spacing: 12,
                          children: [
                            Row(
                              spacing: 8,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.book,
                                  color: kPrimaryColor,
                                  size: 20,
                                ),
                                Text(
                                  "253",
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(color: kBlackColor),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 8,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.triangleExclamation,
                                  color: kPrimaryColor,
                                  size: 20,
                                ),
                                Text(
                                  "12",
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(color: kBlackColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.solidClock,
                            color: kPrimaryColor,
                            size: 20,
                          ),
                          Text(
                            "Timp: 01:45:32",
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(color: kBlackColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    spacing: 12,
                    children: [
                      Text(
                        "Filtru:",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      DropdownButton<String>(
                        isExpanded: false,
                        isDense: true,
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Icon(Icons.filter_list_rounded),
                        ),
                        underline: SizedBox(),
                        iconSize: 22,
                        padding: EdgeInsets.zero,
                        value: selectedFilter,
                        items: filters.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: kForegroundColor),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedFilter = value ?? filters[0];
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.only(
                bottom: Responsive.safePaddingBottom,
                left: 12,
                right: 12,
                top: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [topShadow],
              ),
              child: Row(
                spacing: 24,
                children: [
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(color: kSuccessTextColor, height: 1),
                      children: [
                        TextSpan(
                          text: " •  ",
                          style: TextStyle(fontWeight: FontWeight.w700, color: kSuccessIconColor, fontSize: 24),
                        ),
                        TextSpan(
                          text: "Status: ",
                        ),
                        TextSpan(
                          text: "online",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            // color: kSuccessIconColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
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
                        "Start",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
