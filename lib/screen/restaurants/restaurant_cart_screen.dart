import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/restaurants/checkout_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class RestaurantCart extends StatefulWidget {
  const RestaurantCart({super.key});

  @override
  State<RestaurantCart> createState() => _RestaurantCartState();
}

class _RestaurantCartState extends State<RestaurantCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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

            Padding(
              padding:
                  EdgeInsets.only(top: 3, bottom: 20.h, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                    ),
                  ),
                  const Text(
                    'Restaurant / Cart',
                    style: TextStyle(
                      color: Color(0xFF010101),
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    width: 30,
                  )
                ],
              ),
            ),

            /// Cart List ----------------------------------------------------------------

            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: 2,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        IntrinsicHeight(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '1x',
                                      style: FontUtils.h18(
                                        fontColor: Colors.black,
                                        fontWeight: FWT.medium,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 230.w,
                                          child: Text(
                                            'Smoked Mackerel Salad With Fennel And Apple',
                                            style: FontUtils.h16(
                                                fontColor: AppColors.darkGray,
                                                fontWeight: FWT.regular),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 230.w,
                                          child: Text(
                                            'Fried onions, green peppers, mixed cheese, served with fries',
                                            style: FontUtils.h14(
                                              fontColor:
                                                  const Color(0xffA2A4A7),
                                              fontWeight: FWT.light,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      '\$6.00',
                                      style: FontUtils.h18(
                                        fontColor: Colors.black,
                                        fontWeight: FWT.medium,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                        AssetsUtils.icRemove,
                                        height: 22.h,
                                        alignment: Alignment.bottomLeft,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Image.asset(
                                        AssetsUtils.icAdd,
                                        height: 22.h,
                                        alignment: Alignment.bottomLeft,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        index == 1
                            ? const SizedBox()
                            : Divider(
                                endIndent: 20.w,
                                indent: 20.w,
                                height: 25.h,
                                color: AppColors.disabledColor,
                                thickness: 1,
                              )
                      ],
                    ),
                  );
                },
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Delivery fee',
                          style: FontUtils.h14(
                            fontColor: AppColors.darkGray,
                            fontWeight: FWT.lightMedium,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.info_outline),
                        const Spacer(),
                        Text(
                          'FREE',
                          style: FontUtils.h14(
                            fontColor: AppColors.darkGray,
                            fontWeight: FWT.lightMedium,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Text(
                            'Service fee',
                            style: FontUtils.h14(
                              fontColor: AppColors.darkGray,
                              fontWeight: FWT.lightMedium,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.info_outline),
                          const Spacer(),
                          Text(
                            '\$4.00',
                            style: FontUtils.h14(
                              fontColor: AppColors.darkGray,
                              fontWeight: FWT.lightMedium,
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Service fee tax',
                          style: FontUtils.h14(
                            fontColor: AppColors.darkGray,
                            fontWeight: FWT.lightMedium,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '\$0.30',
                          style: FontUtils.h14(
                            fontColor: AppColors.darkGray,
                            fontWeight: FWT.lightMedium,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Row(
                        children: [
                          Text(
                            'Total',
                            style: FontUtils.h18(
                              fontColor: AppColors.darkGray,
                              fontWeight: FWT.medium,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '\$ 16.37',
                            style: FontUtils.h24(
                              fontColor: const Color(0xff010101),
                              fontWeight: FWT.medium,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: simpleTextBorderButton(
                        color: AppColors.terracotta,
                        width: MediaQuery.of(context).size.width,
                        isFillColor: true,
                        height: 40.h,
                        isLoadingWidget: false,
                        buttonLable: 'Checkout ',
                        lableColor: Colors.white,
                        onTap: () {
                          Get.to(
                            () => const CheckOutScreen(),
                            transition: Transition.fadeIn,
                          );
                        },
                        context: context,
                        isDarkColor: false,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
