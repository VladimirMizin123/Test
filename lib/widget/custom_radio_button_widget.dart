import 'package:flutter/material.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';

typedef OnChanged = String? Function(String?)?;

class CustomRadioButtonWidget extends StatefulWidget {
  final String value;
  final String groupValue;
  final OnChanged onChanged;

  const CustomRadioButtonWidget({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
  });

  @override
  State<CustomRadioButtonWidget> createState() =>
      _CustomRadioButtonWidgetState();
}

class _CustomRadioButtonWidgetState extends State<CustomRadioButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.2,
      child: Radio(
        visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        value: widget.value,
        groupValue: widget.groupValue,
        activeColor: AppColors.green,
        onChanged: widget.onChanged,
      ),
    );
  }
}
