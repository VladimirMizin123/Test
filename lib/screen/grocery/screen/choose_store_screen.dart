import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';
import 'package:gymeats_mobile/widget/box_shadow_widget.dart';
import 'package:gymeats_mobile/widget/custom_radio_button_widget.dart';

class ChooseStoreScreen extends StatelessWidget {
  const ChooseStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButtonWidget(),
                Image.asset(
                  AssetsUtils.gymEatsLogo,
                  height: 35.h,
                  color: AppColors.green,
                ),
                Text('Edit', style: FontUtils.h16(fontColor: AppColors.oxFF010101)),
              ],
            ).paddingSymmetric(horizontal: 6, vertical: 5.h),
            const SizedBox(height: 10),
            Text(
              'Choose a Store',
              style: FontUtils.h24(fontColor: AppColors.green, fontWeight: FWT.semiBold),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                decoration:  BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  boxShadow: boxShadowWidget,
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Column(
                        children: [
                          Container(
                            decoration:  BoxDecoration(
                              boxShadow: boxShadowWidget,
                              color: AppColors.whiteColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              child: Row(
                                children: [
                                  const Expanded(flex: 4, child: Center(child: Image(image: AssetImage(AssetsUtils.icDemoIcon)))),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'The nearest time for pickup,',
                                          style: FontUtils.h14(fontColor: AppColors.black),
                                        ),
                                        Text(
                                          'tomorrow at 10am',
                                          style: FontUtils.h12(fontColor: AppColors.black, fontWeight: FWT.semiBold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Expanded(
                                      flex: 1,
                                      child: CustomRadioButtonWidget(
                                        value: '1',
                                        groupValue: 'STORE',
                                      )
                                      // Container(
                                      //   height: 24.h,
                                      //   width: 24.w,
                                      //   decoration: BoxDecoration(
                                      //     shape: BoxShape.circle,
                                      //     border: Border.all(color: AppColors.primaryBlue, width: 2),
                                      //   ),
                                      //   child: Column(
                                      //     crossAxisAlignment: CrossAxisAlignment.center,
                                      //     mainAxisAlignment: MainAxisAlignment.center,
                                      //     children: [
                                      //       Visibility(
                                      //         visible: true,
                                      //         child: Container(
                                      //           decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryBlue),
                                      //           height: 16.h,
                                      //           width: 16.w,
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
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
