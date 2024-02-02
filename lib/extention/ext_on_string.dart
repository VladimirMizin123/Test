// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/widget/network_image_widget.dart';

extension ExtString on String {
  String get restaurantImg => PreferenceUtils.getString("${this}_img");

  Widget storeImg([double? size]) => SizedBox(
        height: size ?? 37,
        width: size ?? 37,
        child: (restaurantImg.isNotEmpty)
            ? ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: NetworkImageWidget(
                  url: restaurantImg,
                  fit: BoxFit.cover,
                ),
              )
            : Center(
                child: SvgPicture.asset(
                  AssetsUtils.gymEatsLogoRound,
                  color: AppColors.green,
                  height: 30,
                ),
              ),
      );
}
