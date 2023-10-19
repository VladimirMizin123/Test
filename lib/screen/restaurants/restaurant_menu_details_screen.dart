import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class RestaurantMenuDetailsScreen extends StatefulWidget {
  const RestaurantMenuDetailsScreen({super.key});

  @override
  State<RestaurantMenuDetailsScreen> createState() =>
      _RestaurantMenuDetailsScreenState();
}

class _RestaurantMenuDetailsScreenState
    extends State<RestaurantMenuDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 305.h,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  image: DecorationImage(
                    image: AssetImage(AssetsUtils.food3),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Chicken Quesadilla',
                  style: FontUtils.h24(
                    fontColor: Colors.black,
                    fontWeight: FWT.medium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '\$6.00',
                    style: FontUtils.h18(
                      fontColor: Colors.black,
                      fontWeight: FWT.medium,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.w, bottom: 14.h),
                  child: Text(
                    'Fried onions, green peppers, mixed cheese, served with fries',
                    style: FontUtils.h14(
                      fontColor: const Color(0xffA2A4A7),
                      fontWeight: FWT.lightMedium,
                    ),
                  ),
                ),
                Text(
                  'Sauce',
                  style: FontUtils.h18(
                    fontColor: Colors.black,
                    fontWeight: FWT.medium,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Choose 1 option',
                      style: FontUtils.h14(
                        fontColor: Colors.black,
                        fontWeight: FWT.regular,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
                SizedBox(
                  height: 16.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sugar free barbecue',
                      style: FontUtils.h18(
                        fontColor: Colors.black,
                        fontWeight: FWT.medium,
                      ),
                    ),
                    const Spacer(),
                    Image.asset(
                      AssetsUtils.icAdd,
                      height: 24.h,
                    )
                  ],
                ),
                const SizedBox(
                  height: 13,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sugar free barbecue',
                      style: FontUtils.h18(
                        fontColor: Colors.black,
                        fontWeight: FWT.medium,
                      ),
                    ),
                    const Spacer(),
                    Image.asset(
                      AssetsUtils.icAdd,
                      height: 24.h,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Container(
                          height: size.height * 0.060,
                          width: size.height * 0.060,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.terracotta)),
                          child: Center(
                              child: SvgPicture.asset(
                            AssetsUtils.icDelete,
                            color: AppColors.terracotta,
                          )),
                          // child: const Center(child: Icon(Icons.remove, size: 27)),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        height: size.height * 0.060,
                        width: size.height * 0.060,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.disable),
                            borderRadius: BorderRadius.circular(6)),
                        child: Center(
                            child: Text(
                          '0',
                          style: FontUtils.h18(
                              fontWeight: FWT.semiBold,
                              fontColor: AppColors.darkGray),
                        )),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        child: Container(
                          height: size.height * 0.060,
                          width: size.height * 0.060,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: AppColors.coral,
                          ),
                          child: const Center(
                            child: Icon(Icons.add,
                                size: 27, color: AppColors.terracotta),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                simpleTextBorderButton(
                  color: AppColors.terracotta,
                  width: size.width,
                  isFillColor: true,
                  height: 48.h,
                  isLoadingWidget: false,
                  buttonLable: 'Add to Cart',
                  lableColor: Colors.white,
                  onTap: () {},
                  context: context,
                  isDarkColor: false,
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Image.asset(
                    AssetsUtils.gymEatsSpoon,
                    height: 22.h,
                    width: 56.w,
                    color: AppColors.terracotta,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
