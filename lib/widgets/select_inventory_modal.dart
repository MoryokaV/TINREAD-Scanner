import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tinread_scanner/controllers/inventory_controller.dart';
import 'package:tinread_scanner/models/inventory_model.dart';
import 'package:tinread_scanner/utils/responsive.dart';
import 'package:tinread_scanner/utils/style.dart';
import 'package:tinread_scanner/widgets/loading_spinner.dart';

class SelectInventoryModal extends StatefulWidget {
  const SelectInventoryModal({super.key});

  @override
  State<SelectInventoryModal> createState() => _SelectInventoryModalState();
}

class _SelectInventoryModalState extends State<SelectInventoryModal> {
  late final List<Inventory> inventories;
  final InventoryController _inventoryController = InventoryController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    inventories = await _inventoryController.fetchInventories();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ui.ImageFilter.blur(
        sigmaX: 4,
        sigmaY: 4,
      ),
      child: Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            clipBehavior: Clip.hardEdge,
            width: Responsive.screenWidth * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              boxShadow: shadowLg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            backgroundColor: Colors.white24,
                            child: IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.xmark,
                                size: 18,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Alege o inventariere activă",
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          "Etichetele scanate vor fi încărcate în platforma TINREAD în inventarierea selectată",
                          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: Colors.white.withAlpha(200),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: Responsive.screenHeight * 0.6,
                    minHeight: Responsive.screenHeight * 0.1,
                  ),
                  child: !isLoading
                      ? ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 20, top: 10),
                          itemCount: inventories.length,
                          itemBuilder: (context, index) {
                            final Inventory inventory = inventories[index];

                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {},
                                child: Ink(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(inventory.name),
                                            ),
                                            const SizedBox(width: 15),
                                            Icon(
                                              FontAwesomeIcons.chevronRight,
                                              color: kDisabledIconColor,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Divider(
                                          thickness: 1,
                                          height: 1,
                                          color: lightGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : SizedBox(
                          height: Responsive.screenHeight * 0.1,
                          child: LoadingSpinner(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
