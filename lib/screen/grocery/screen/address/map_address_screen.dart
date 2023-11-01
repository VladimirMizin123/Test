import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';

class MapAddressScreen extends StatelessWidget {
  const MapAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          const GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(21.2408, 72.8806),
              zoom: 15,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          AssetsUtils.gymEatsLogo,
                          height: 20.h,
                          width: 56.w,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: const BackButtonWidget()
                              .paddingSymmetric(horizontal: 6, vertical: 10.h)),
                    ],
                  ),
                ),
                Container(
                  color: AppColors.whiteColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Add delivery address',
                            style: FontUtils.h18(
                                fontColor: AppColors.black,
                                fontWeight: FWT.medium),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            boxShadow: boxShadowWidget,
                          ),
                          child: TextFormField(
                            onTap: () {
                              Get.toNamed('/SearchDeliveryAddressScreen');
                            },
                            readOnly: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search,
                                  color: AppColors.black),
                              hintText: 'Search for item',
                              hintStyle: FontUtils.h16(),
                              border: InputBorder.none,
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              SvgPicture.asset(AssetsUtils.icLocationIcon,
                                  color: AppColors.terracotta),
                              const SizedBox(width: 10),
                              Text(
                                'Current location',
                                style: FontUtils.h20(
                                  fontColor: AppColors.terracotta,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              SvgPicture.asset(AssetsUtils.icFlagIcon,
                                  color: AppColors.black),
                              const SizedBox(width: 10),
                              Text(
                                'Recent address',
                                style: FontUtils.h20(
                                  fontColor: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        simpleTextBorderButton(
                          context: context,
                          color: AppColors.green,
                          buttonLable: 'Save',
                          height: screenSize.height * 0.065,
                          width: screenSize.width,
                          isLoadingWidget: false,
                          onTap: () {
                            Get.back();
                          },
                          isDarkColor: true,
                          isFillColor: true,
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            AssetsUtils.gymEatsLogo,
                            height: 20.h,
                            width: 56.w,
                            color: AppColors.green,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
