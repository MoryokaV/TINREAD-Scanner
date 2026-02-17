import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tinread_scanner/l10n/generated/app_localizations.dart';
import 'package:tinread_scanner/providers/connectivity_provider.dart';
import 'package:tinread_scanner/services/rfid_service.dart';
import 'package:tinread_scanner/utils/responsive.dart';
import 'package:tinread_scanner/utils/style.dart';
import 'package:tinread_scanner/widgets/separator_widget.dart';

class RfidInventoryView extends StatefulWidget {
  const RfidInventoryView({super.key});

  @override
  State<RfidInventoryView> createState() => _RfidInventoryViewState();
}

class _RfidInventoryViewState extends State<RfidInventoryView> with WidgetsBindingObserver {
  late List<String> filters = [];
  late String selectedFilter;
  late final RfidService _rfidService;

  bool isScanning = false;
  List<String> tags = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _rfidService = RfidService();
    _rfidService.onTagsReceived = onTagsReceived;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    filters = [AppLocalizations.of(context).all, AppLocalizations.of(context).errors];
    selectedFilter = filters[0];
  }

  void onTagsReceived(List<String> newTags) {
    if (!mounted) return;

    setState(() {
      tags.addAll(newTags);
    });
  }

  void toggleScan() => isScanning ? stopScan() : startScan();

  void startScan() {
    _rfidService.startScan();

    setState(() => isScanning = true);
  }

  void stopScan() {
    _rfidService.stopScan();

    setState(() => isScanning = false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      stopScan();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    stopScan();

    _rfidService.onTagsReceived = null;
    super.dispose();
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
          AppLocalizations.of(context).rfidInventory,
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
            ItemsTable(
              tags: tags,
            ),
            BottomActionBar(
              isOnline: isOnline,
              isScanning: isScanning,
              toggleScan: toggleScan,
            ),
          ],
        ),
      ),
    );
  }
}

class ItemsTable extends StatefulWidget {
  final List<String> tags;

  const ItemsTable({
    super.key,
    required this.tags,
  });

  @override
  State<ItemsTable> createState() => _ItemsTableState();
}

class _ItemsTableState extends State<ItemsTable> {
  final tableCol1Width = Responsive.screenWidth / 4.5;
  final tableCol2Width = Responsive.screenWidth / 2 - 12;
  final tableCol3Width = Responsive.screenWidth / 3.6 - 12;

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
            child: widget.tags.isNotEmpty
                ? ListView.builder(
                    padding: .zero,
                    itemCount: widget.tags.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      String tag = widget.tags[index];
                      String tagUniqueId = tag.substring(tag.length - 5, tag.length - 1);

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
                              child: Text(tagUniqueId),
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
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 15,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.circleInfo,
                        color: kDisabledIconColor,
                        size: 42,
                      ),
                      Text(
                        AppLocalizations.of(context).emptyInventory,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(color: kDisabledIconColor),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class BottomActionBar extends StatefulWidget {
  final bool isOnline;
  final bool isScanning;
  final VoidCallback toggleScan;

  const BottomActionBar({
    super.key,
    required this.isOnline,
    required this.isScanning,
    required this.toggleScan,
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
              onPressed: widget.toggleScan,
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
                widget.isScanning ? "Stop" : "Start",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
