import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_list.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';

class CustomizationHeader extends StatelessWidget {
  const CustomizationHeader({
    super.key,
    required this.customization,
    this.style,
    this.parentTitle,
    this.setBackButton = false,
    this.onBack,
  });
  final Customization? customization;
  final TextStyle? style;
  final String? parentTitle;
  final bool setBackButton;
  final Function()? onBack;

  @override
  Widget build(BuildContext context) {
    bool setSubTitle = parentTitle != null && setBackButton;
    return Row(
      children: [
        if (setBackButton) ...[
          IconButton(
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            onPressed: () => onBack?.call(),
            icon: const Icon(Icons.arrow_back),
          ).paddingOnly(bottom: parentTitle != null ? 25 : 0),
          20.width,
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (setSubTitle) ...[
                Text(
                  parentTitle!,
                  style: style ??
                      FontUtils.h17(
                        fontColor: Colors.black,
                        fontWeight: FWT.medium,
                      ),
                )
              ],
              Text(
                customization?.name ?? '',
                style: style ??
                    (!setSubTitle
                        ? FontUtils.h18(
                            fontColor: Colors.black,
                            fontWeight: FWT.semiBold,
                          )
                        : FontUtils.h16(
                            fontColor: Colors.black,
                            fontWeight: FWT.semiBold,
                          )),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customization?.minChoiceOptions == 0
                      ? Expanded(
                          child: Text(
                            'Optional',
                            style: FontUtils.h14(
                              fontColor: AppColors.middleGray,
                              fontWeight: FWT.regular,
                            ),
                          ),
                        )
                      : Expanded(
                          child: Row(
                            children: [
                              Text(
                                'Choose ${customization?.minChoiceOptions ?? 1} option',
                                style: FontUtils.h14(
                                  fontColor: Colors.black,
                                  fontWeight: FWT.regular,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: AppColors.coral,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Required',
                                  style: FontUtils.h12(
                                    fontColor: AppColors.terracotta,
                                    fontWeight: FWT.regular,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NestedCustomizationHeader extends StatelessWidget {
  const NestedCustomizationHeader({
    super.key,
    required this.customization,
    this.style,
  });
  final Customization? customization;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    bool isOptinal = customization?.minChoiceOptions == 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                customization?.name ?? '',
                style: style ??
                    FontUtils.h18(
                      fontColor: Colors.black,
                      fontWeight: FWT.semiBold,
                    ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              isOptinal
                  ? 'Optional'
                  : 'Choose ${customization?.minChoiceOptions ?? 1} option',
              style: FontUtils.h12(
                fontColor: AppColors.middleGray,
                fontWeight: FWT.regular,
              ),
            ),
            if (!isOptinal) ...[
              Text(
                'Required',
                style: FontUtils.h12(
                  fontColor: AppColors.terracotta,
                  fontWeight: FWT.regular,
                ),
              )
            ],
          ].addBetweenItems(8.width),
        ),
      ],
    ).paddingOnly(left: 15);
  }
}
