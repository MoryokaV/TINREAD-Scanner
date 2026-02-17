import 'package:flutter/material.dart';
import 'package:tinread_scanner/utils/style.dart';

class Separator extends StatelessWidget {
  final double? width;
  final double? paddingBottom;

  const Separator({
    super.key,
    this.width,
    this.paddingBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 12,
        bottom: paddingBottom ?? 0,
      ),
      child: SizedBox(
        width: width,
        height: 1,
        child: Divider(
          color: lightGrey,
          thickness: 1,
        ),
      ),
    );
  }
}
