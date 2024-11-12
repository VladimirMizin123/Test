// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
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
                  placeholder: AssetsUtils.restaurantGrocery,
                ),
              )
            : Center(
                child: Image.asset(
                  AssetsUtils.restaurantGrocery,
                  height: 30,
                ),
              ),
      );

  Widget storeGenericImg([double? size]) => SizedBox(
        height: size ?? 37,
        width: size ?? 37,
        child: (restaurantImg.isNotEmpty)
            ? ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: NetworkImageWidget(
                  url: restaurantImg,
                  fit: BoxFit.cover,
                  placeholder: AssetsUtils.icGenericLogo,
                ),
              )
            : Center(
                child: Image.asset(
                  AssetsUtils.icGenericLogo,
                  height: 30,
                ),
              ),
      );
}
