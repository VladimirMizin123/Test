import 'package:flutter/material.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';

typedef OnChanged = String? Function(bool?)?;

class CustomCheckboxWidget extends StatefulWidget {
  final bool value;
  final OnChanged onChanged;

  const CustomCheckboxWidget({super.key, required this.value, this.onChanged});

  @override
  State<CustomCheckboxWidget> createState() => _CustomCheckboxWidgetState();
}

class _CustomCheckboxWidgetState extends State<CustomCheckboxWidget> {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.4,
      child: Checkbox(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        value: widget.value,
        onChanged: widget.onChanged,
        activeColor: AppColors.appColor,
      ),
    );
  }
}
