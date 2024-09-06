import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({
    super.key,
    this.readOnly = false,
    this.hintText,
    this.showPrefixIcon = true,
    required this.onChange,
    this.onTap,
    required this.controller,
  });
  final bool readOnly;
  final String? hintText;
  final bool showPrefixIcon;
  final Function(String?) onChange;
  final Function()? onTap;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: boxShadowWidget,
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        style: FontUtils.h14(
          fontColor: AppColors.black,
          fontWeight: FWT.lightMedium,
        ),
        onTap: () => onTap?.call(),
        onChanged: (String? value) => onChange.call(value),
        decoration: InputDecoration(
          contentPadding: showPrefixIcon
              ? EdgeInsets.zero
              : const EdgeInsets.fromLTRB(15, 0, 15, 0),
          prefixIcon: showPrefixIcon
              ? SvgPicture.asset(
                  AssetsUtils.icSearch,
                  fit: BoxFit.scaleDown,
                )
              : null,
          hintText: hintText ?? 'Search',
          hintStyle: FontUtils.h14(
            fontColor: AppColors.middleGray,
            fontWeight: FWT.lightMedium,
          ).copyWith(height: 1.8),
          border: InputBorder.none,
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
