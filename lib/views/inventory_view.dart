import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tinread_rfid_scanner/l10n/generated/app_localizations.dart';
import 'package:tinread_rfid_scanner/providers/connectivity_provider.dart';
import 'package:tinread_rfid_scanner/utils/responsive.dart';
import 'package:tinread_rfid_scanner/utils/style.dart';
import 'package:tinread_rfid_scanner/widgets/separator_widget.dart';

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
    final bool isOnline = context.select<ConnectivityProvider, bool>((c) => c.isOnline);

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
                            "${AppLocalizations.of(context).time}: 01:45:32",
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
                        "${AppLocalizations.of(context).filter}:",
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
            ItemsTable(),
            BottomActionBar(
              isOnline: isOnline,
            ),
          ],
        ),
      ),
    );
  }
}

class ItemsTable extends StatefulWidget {
  const ItemsTable({super.key});

  @override
  State<ItemsTable> createState() => _ItemsTableState();
}

class _ItemsTableState extends State<ItemsTable> {
  final tableCol1Width = Responsive.screenWidth / 4;
  final tableCol2Width = Responsive.screenWidth / 2 - 12;
  final tableCol3Width = Responsive.screenWidth / 4 - 12;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 12,
              left: 12,
              right: 12,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: tableCol1Width,
                  child: Text(AppLocalizations.of(context).number_short),
                ),
                SizedBox(
                  width: tableCol2Width,
                  child: Text(AppLocalizations.of(context).situation),
                ),
                SizedBox(
                  width: tableCol3Width,
                  child: Text(AppLocalizations.of(context).actions),
                ),
              ],
            ),
          ),
          Separator(),
          Expanded(
            child: ListView.builder(
              padding: .zero,
              itemCount: 40,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding: .symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: index % 2 == 1 ? lightGrey : kBackgroundColor,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: tableCol1Width,
                        child: Text("5672"),
                      ),
                      SizedBox(
                        width: tableCol2Width,
                        child: Text("În inventariere"),
                      ),
                      SizedBox(
                        width: tableCol3Width,
                        child: Row(
                          spacing: 12,
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              constraints: BoxConstraints(),
                              splashRadius: 1,
                              padding: .zero,
                              onPressed: () {
                                print("delete");
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.trashCan,
                                color: kPrimaryColor,
                                size: 18,
                              ),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              constraints: BoxConstraints(),
                              splashRadius: 1,
                              padding: .zero,
                              onPressed: () {
                                print("compass");
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.compass,
                                color: kPrimaryColor,
                                size: 18,
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
          ),
        ],
      ),
    );
  }
}

class BottomActionBar extends StatefulWidget {
  final bool isOnline;

  const BottomActionBar({
    super.key,
    required this.isOnline,
  });

  @override
  State<BottomActionBar> createState() => _BottomActionBarState();
}

class _BottomActionBarState extends State<BottomActionBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
        spacing: 24,
        children: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: widget.isOnline ? kSuccessTextColor : kDangerTextColor,
                height: 1,
              ),
              children: [
                TextSpan(
                  text: " •  ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: widget.isOnline ? kSuccessIconColor : kDangerIconColor,
                    fontSize: 24,
                  ),
                ),
                TextSpan(
                  text: "Status: ",
                ),
                TextSpan(
                  text: widget.isOnline ? "online" : "offline",
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
    );
  }
}
