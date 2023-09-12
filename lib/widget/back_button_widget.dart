import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // return const Icon(Icons.keyboard_arrow_left_outlined, size: 30);
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: GestureDetector(onTap: () {
       Get.back();
      }, child: SvgPicture.asset(AssetsUtils.icBackArrow)),
    );
  }
}
