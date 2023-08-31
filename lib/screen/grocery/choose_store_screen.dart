import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';

class ChooseStoreScreen extends StatelessWidget {
  const ChooseStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
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
                const Icon(Icons.keyboard_arrow_left_outlined, size: 30),
                Text('Grocery List', style: FontUtils.h20(fontColor: AppColors.oxFF010101, fontWeight: FWT.semiBold)),
                Text('Edit', style: FontUtils.h16(fontColor: AppColors.oxFF010101)),
              ],
            ).paddingSymmetric(horizontal: 20.w, vertical: 5.h),
            Text(
              'Choose a Store',
              style: FontUtils.h24(fontColor: AppColors.green, fontWeight: FWT.semiBold),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffDDDDDD),
                      blurRadius: 4,
                      spreadRadius: 1,
                      offset: Offset(0.0, 0.0),
                    )
                  ],
                ),
                child: TextFormField(
                  onTap: () {},
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: AppColors.darkGray),
                    hintText: 'Search',
                    hintStyle: FontUtils.h16(fontColor: AppColors.middleGray),
                    border: InputBorder.none,
                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xffDDDDDD),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                  offset: Offset(0.0, 0.0),
                                )
                              ],
                              color: AppColors.whiteColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                              child: Row(
                                children: [
                                  const Image(image: AssetImage(AssetsUtils.demoIcon)),
                                  const Column(
                                    children: [
                                      Text('The nearest time for pickup,'),
                                      Text('tomorrow at 10am'),
                                    ],
                                  ),
                                  Container(
                                    height: 24.h,
                                    width: 24.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppColors.primaryBlue, width: 2),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Visibility(
                                          visible: true,
                                          child: Container(
                                            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryBlue),
                                            height: 16.h,
                                            width: 16.w,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
