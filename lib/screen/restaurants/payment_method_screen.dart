import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/screen/restaurants/add_debit_card_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  List<dynamic> data = [];
  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    data = jsonDecode(pref.getString('cardData').toString());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Row(
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
                    'Payment',
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

              ///Payment method --------------------------------------------------------------------
              data.isEmpty
                  ? const SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
                      child: Text(
                        'Saved payment methods',
                        style: FontUtils.h18(
                          fontColor: const Color(0xff5F5F5F),
                          fontWeight: FWT.medium,
                        ),
                      ),
                    ),

              data.isEmpty
                  ? const SizedBox()
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: data.length,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 1,
                              color: AppColors.terracotta,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(0xff004C63).withOpacity(0.08),
                                offset: const Offset(0, 0),
                                blurRadius: 16,
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(AssetsUtils.icVisa),
                              const SizedBox(
                                width: 15,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Visa',
                                    style: TextStyle(
                                      color: Color(0xff010101),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Ending 1234',
                                    style: TextStyle(
                                      color: Color(0xff010101),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  await Get.to(
                                    () => AddDebitCardScreen(data: data[index]),
                                    transition: Transition.fadeIn,
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text('Edit',
                                        style: FontUtils.h14(
                                            fontColor: AppColors.terracotta,
                                            fontWeight: FWT.lightMedium)),
                                    const Icon(
                                      Icons.keyboard_arrow_right_sharp,
                                      color: AppColors.terracotta,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),

              ///Payment method --------------------------------------------------------------------
              Padding(
                padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
                child: Text(
                  'Add payment method',
                  style: FontUtils.h18(
                    fontColor: const Color(0xff5F5F5F),
                    fontWeight: FWT.medium,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff004C63).withOpacity(0.08),
                      offset: const Offset(0, 0),
                      blurRadius: 16,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AssetsUtils.icVisa,
                      height: 22.h,
                      width: 50.w,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      'Debit/Credit',
                      style: TextStyle(
                        color: Color(0xff010101),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        await Get.to(
                          () => const AddDebitCardScreen(),
                          transition: Transition.fadeIn,
                        )!
                            .then((value) {
                          setState(() {
                            getData();
                          });
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            'Add',
                            style: FontUtils.h14(
                              fontColor: AppColors.terracotta,
                              fontWeight: FWT.lightMedium,
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_right_sharp,
                            color: AppColors.terracotta,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const Spacer(),

              // GestureDetector(
              //   onTap: () {},
              //   child: Container(
              //     height: 45.h,
              //     margin: EdgeInsets.only(bottom: 40.h),
              //     width: Get.width,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(8.r),
              //       color: const Color(0xffCE6B53),
              //     ),
              //     child: Center(
              //       child: Text(
              //         'Confirm',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 18.sp,
              //           fontWeight: FontWeight.w500,
              //           fontFamily: 'Avenir',
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
