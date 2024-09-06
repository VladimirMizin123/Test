// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';

class CartRoundButton extends StatelessWidget {
  const CartRoundButton({super.key, required this.onTap});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap.call(),
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.green,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: SvgPicture.asset(
            AssetsUtils.icShoppingIcon,
            color: AppColors.green,
          ),
        ),
      ),
    );
  }
}

enum CartAction {
  add,
  remove,
  delete,
  text,
}

class CartActionButton extends StatelessWidget {
  const CartActionButton({
    super.key,
    this.count,
    required this.onTap,
    required this.action,
  });
  final String? count;
  final Function() onTap;
  final CartAction action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap.call(),
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          border: action != CartAction.remove
              ? Border.all(
                  color: action == CartAction.text
                      ? AppColors.disable
                      : AppColors.mint,
                  width: 2)
              : null,
          borderRadius: BorderRadius.circular(10),
          color: action == CartAction.add
              ? AppColors.mint
              : action == CartAction.remove
                  ? const Color.fromRGBO(217, 233, 238, 1)
                  : null,
        ),
        child: Center(
          child: switch (action) {
            CartAction.add => const Icon(
                Icons.add,
                size: 27,
                color: AppColors.green,
              ),
            CartAction.delete => SvgPicture.asset(
                AssetsUtils.icDelete,
                color: AppColors.green,
              ),
            CartAction.remove => const Icon(
                Icons.remove,
                size: 27,
                color: Color.fromRGBO(22, 75, 99, 1),
              ),
            CartAction.text => Text(
                "$count",
                style: FontUtils.h16(
                  fontColor: AppColors.darkGray,
                  fontWeight: FWT.semiBold,
                ),
              ),
          },
        ),
      ),
    );
  }
}
