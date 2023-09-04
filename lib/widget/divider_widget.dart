import 'package:flutter/material.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppColors.disable, thickness: 1.2);
  }
}
