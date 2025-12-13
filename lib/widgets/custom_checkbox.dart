import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tinread_rfid_scanner/utils/style.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double size;
  final Color activeColor;
  final Color checkColor;
  final Color borderColor;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 18,
    this.activeColor = kPrimaryColor,
    this.checkColor = Colors.white,
    this.borderColor = lightGrey,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value ? activeColor : Colors.transparent,
          border: Border.all(
            color: value ? activeColor : borderColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: value
            ? Center(
                child: FaIcon(
                  FontAwesomeIcons.check,
                  size: size * 0.7,
                  color: checkColor,
                ),
              )
            : null,
      ),
    );
  }
}
