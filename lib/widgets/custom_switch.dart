import 'package:flutter/material.dart';
import 'package:tinread_rfid_scanner/utils/style.dart';

class CustomSwitch extends StatefulWidget {
  final void Function()? onTap;
  final bool enabled;

  const CustomSwitch({
    super.key,
    required this.onTap,
    required this.enabled,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            width: 50,
            height: 25,
            padding: EdgeInsets.all(3),
            color: widget.enabled ? kPrimaryColor : lightGrey,
            child: Stack(
              children: [
                AnimatedPositioned(
                  left: widget.enabled ? 19 : 0,
                  top: 0,
                  bottom: 0,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeIn,
                  child: Container(
                    width: 25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(offset: Offset(0, 2), color: Colors.black12, blurRadius: 4),
                      ],
                    ),
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
