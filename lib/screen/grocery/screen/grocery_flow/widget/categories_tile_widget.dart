// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/screen/restaurants/model/categorie_model.dart';
import 'package:gymeats_mobile/widget/network_image_widget.dart';

class CategoriesTileWidget extends StatelessWidget {
  const CategoriesTileWidget({
    super.key,
    this.category,
    this.showIcon = true,
    required this.onTap,
  });

  final Category? category;
  final bool showIcon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap.call(),
      child: Row(
        children: [
          if (showIcon) ...[
            ClipOval(
              child: category?.image != null
                  ? NetworkImageWidget(
                      url: category!.image!,
                      placeholder:
                          AssetsUtils.getCategoryIcon(category?.name ?? ""),
                      height: 48,
                      width: 48,
                    )
                  : Image.asset(
                      AssetsUtils.getCategoryIcon(category?.name ?? ""),
                      height: 48,
                      width: 48,
                      fit: BoxFit.cover,
                    ),
            ),
            16.width,
          ],
          Expanded(
            child: Text(
              category?.name ?? "",
              style: FontUtils.h16(
                fontColor: AppColors.oxFF010101,
              ),
            ),
          ),
          16.width,
          SvgPicture.asset(
            AssetsUtils.forwardArrow,
            color: AppColors.green,
          ),
        ],
      ).paddingOnly(left: 14, right: 14),
    );
  }
}
