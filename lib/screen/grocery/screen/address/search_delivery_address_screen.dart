import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';

import '../../../../constant/color_utils.dart';
import '../../../../constant/font_utils.dart';

class SearchDeliveryAddressScreen extends StatefulWidget {
  const SearchDeliveryAddressScreen({super.key});

  @override
  State<SearchDeliveryAddressScreen> createState() => _SearchDeliveryAddressScreenState();
}

class _SearchDeliveryAddressScreenState extends State<SearchDeliveryAddressScreen> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(
              AssetsUtils.gymEatsLogo,
              height: 20.h,
              width: 56.w,
              color: AppColors.primaryBlue,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButtonWidget(),
                Text('Search delivery address', style: FontUtils.h20(fontColor: AppColors.oxFF010101, fontWeight: FWT.semiBold)),
                Opacity(opacity: 0, child: Text('Edit', style: FontUtils.h16(fontColor: AppColors.oxFF010101))),
              ],
            ).paddingSymmetric(horizontal: 6, vertical: 5.h),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  boxShadow: boxShadowWidget,
                ),
                child: TextFormField(
                  controller: controller,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: AppColors.black),
                    hintText: 'Search for item',
                    hintStyle: FontUtils.h16(),
                    border: InputBorder.none,
                    suffixIcon: const Icon(Icons.cancel_outlined, color: AppColors.black),
                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed('/AddDeliveryAddressScreen');
                },
                child: Container(
                  decoration:  BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    boxShadow: boxShadowWidget,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Can\'t find your address?',
                              style: FontUtils.h16(fontWeight: FWT.medium, fontColor: AppColors.black),
                            ),
                            Text(
                              'Use a map',
                              style: FontUtils.h12(fontColor: AppColors.terracotta),
                            ),
                          ],
                        ),
                        SvgPicture.asset(AssetsUtils.icFlagIcon, color: AppColors.terracotta),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
