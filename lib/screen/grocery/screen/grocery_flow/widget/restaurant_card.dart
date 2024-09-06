import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/widget/network_image_widget.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    super.key,
    required this.index,
    required this.selectedIndex,
    this.store,
    required this.logoPhotos,
    this.isLoading = false,
    required this.onTap,
  });
  final int index;
  final int? selectedIndex;
  final Store? store;
  final List<String> logoPhotos;
  final bool isLoading;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    bool selected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onTap.call(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: boxShadowWidget,
          color: AppColors.whiteColor,
          border: selected
              ? Border.all(
                  color: AppColors.primaryBlueColor,
                )
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: logoPhotos.isEmpty
                  ? Image.asset(AssetsUtils.restaurantGrocery, height: 90.h)
                  : NetworkImageWidget(
                      url: logoPhotos[0],
                      height: 90.h,
                      placeholder: AssetsUtils.restaurantGrocery,
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store?.name ?? "-",
                    style: FontUtils.h14(fontColor: AppColors.black),
                  ),
                  Text(
                    getAddress(store?.address),
                    style: const TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 12,
                      color: AppColors.darkGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            5.width,
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 22,
                  width: 22,
                  decoration: isLoading
                      ? null
                      : BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.primaryBlue, width: 2),
                        ),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: selected,
                              child: Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryBlue),
                                height: 14.h,
                                width: 14.w,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String getAddress(Address? address) {
    List<String?> addresslist = [
      address?.streetAddr,
      address?.city,
      address?.state
    ]..removeWhere((element) => element == null || element.trim().isEmpty);

    return addresslist.join(" , ");
  }
}
