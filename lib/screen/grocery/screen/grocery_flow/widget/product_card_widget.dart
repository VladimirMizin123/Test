// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/screen/grocery/screen/grocery_flow/widget/cart_round_button.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/widget/network_image_widget.dart';
import 'package:popover/popover.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({
    super.key,
    this.categoryName,
    this.menuItem,
    this.imgSize = 100,
    this.qty,
    this.showDiscount = true,
    this.storeName,
    this.add = false,
    this.isGroceryItem = false,
    this.onTap,
    required this.onCartTap,
    required this.onRemove,
    required this.onAdd,
  });
  final String? categoryName;
  final MenuItemList? menuItem;
  final double imgSize;
  final int? qty;
  final bool showDiscount;
  final String? storeName;
  final bool add;
  final bool isGroceryItem;
  final Function()? onTap;
  final Function() onCartTap;
  final Function() onRemove;
  final Function() onAdd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap?.call(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20,
            width: 44,
            decoration: BoxDecoration(
              color: showDiscount ? AppColors.terracotta : null,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
            ),
            child: showDiscount
                ? Text(
                    "-15%",
                    textAlign: TextAlign.center,
                    style: FontUtils.h12(
                      fontColor: AppColors.whiteColor,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          5.width,
          if (menuItem?.image != null) ...[
            NetworkImageWidget(
              url: menuItem!.image ?? "",
              height: imgSize,
              width: 65,
            ),
          ] else ...[
            Container(width: 65),
          ],
          25.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: isGroceryItem ? (" ") : "",
                          style: FontUtils.h16(
                            fontColor: AppColors.appColor,
                            fontWeight: FWT.semiBold,
                          ).copyWith(
                            backgroundColor: AppColors.skyBlue,
                            height: 1.6,
                          ),
                          children: [
                            TextSpan(
                              text: isGroceryItem ? ("$categoryName") : "",
                              style: FontUtils.h16(
                                fontColor: AppColors.appColor,
                                fontWeight: FWT.semiBold,
                              ).copyWith(
                                backgroundColor: AppColors.skyBlue,
                                decoration: TextDecoration.underline,
                                height: 1.6,
                                wordSpacing: 5,
                              ),
                            ),
                            TextSpan(
                              text: isGroceryItem ? (" ") : "",
                              style: FontUtils.h16(
                                fontColor: AppColors.appColor,
                                fontWeight: FWT.semiBold,
                              ).copyWith(
                                backgroundColor: AppColors.skyBlue,
                                height: 1.6,
                              ),
                            ),
                            TextSpan(
                              text: (isGroceryItem ? " " : "") +
                                  (menuItem?.name ?? ""),
                              style: FontUtils.h12(
                                fontColor: AppColors.darkGray,
                              ).copyWith(
                                backgroundColor: AppColors.transparentColor,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isGroceryItem) ...[
                      GestureDetector(
                        onTap: () => showPopover(
                          barrierColor: AppColors.transparentColor,
                          context: context,
                          bodyBuilder: (context) {
                            return GestureDetector(
                              onTap: () => {
                                Navigator.pop(context),
                              },
                              child: Container(
                                height: 50,
                                color: Colors.white,
                                child: Align(
                                  child: Text(
                                    StringUtils.inYourShoppingList,
                                    style: FontUtils.h12(
                                      fontColor: AppColors.brown,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          width: 120,
                          height: 50,
                          arrowDxOffset: context.width - 50,
                          arrowDyOffset: -55,
                          backgroundColor: Colors.white,
                          direction: PopoverDirection.right,
                        ),
                        child: Container(
                          height: 24,
                          width: 24,
                          decoration: const BoxDecoration(
                            color: AppColors.skyBlue,
                            shape: BoxShape.circle,
                          ),
                          child: Align(
                            child: SvgPicture.asset(
                              AssetsUtils.icList,
                              color: AppColors.newDarkBlue,
                              height: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                8.height,
                Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: AppColors.terracotta, size: 20),
                    3.width,
                    Text(
                      'Available in: ',
                      style: FontUtils.h12(
                          fontColor: AppColors.middleGray,
                          fontWeight: FWT.semiBold),
                    ),
                  ],
                ),
                10.height,
                Text(
                  storeName ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: FontUtils.h12(
                      fontColor: AppColors.black, fontWeight: FWT.semiBold),
                ),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (qty == null || qty! <= 0) ...[
                      CartRoundButton(onTap: () => onCartTap.call()),
                    ] else ...[
                      Expanded(
                        child: Row(
                          children: [
                            CartActionButton(
                              action: (qty ?? 0) <= 1
                                  ? CartAction.delete
                                  : CartAction.remove,
                              onTap: () => onRemove.call(),
                            ),
                            8.width,
                            CartActionButton(
                              action: CartAction.text,
                              count: "${qty!}",
                              onTap: () {},
                            ),
                            8.width,
                            CartActionButton(
                              action: CartAction.add,
                              onTap: () => onAdd.call(),
                            ),
                          ],
                        ),
                      ),
                    ],
                    Column(
                      children: [
                        if (showDiscount)
                          Text(
                            "\$ 5.99",
                            style: FontUtils.h17(
                              fontColor: AppColors.black,
                              fontWeight: FWT.medium,
                            ).copyWith(decoration: TextDecoration.lineThrough),
                          ),
                        Text(
                          menuItem?.formattedPrice ?? "\$ 4.99",
                          style: FontUtils.h17(
                            fontColor: showDiscount
                                ? AppColors.terracotta
                                : AppColors.black,
                            fontWeight: FWT.medium,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          20.width,
        ],
      ),
    );
  }
}
