import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController validUntilController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
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
                const BackButtonWidget(),
                Text('Checkout', style: FontUtils.h20(fontColor: AppColors.oxFF010101, fontWeight: FWT.semiBold)),
                Opacity(opacity: 0, child: Text('Edit', style: FontUtils.h16(fontColor: AppColors.oxFF010101))),
              ],
            ).paddingSymmetric(horizontal: 6, vertical: 5.h),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: textFieldWidget(hintText: 'Enter Name Here,', title: 'Name', controller: nameController),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: textFieldWidget(hintText: 'Enter Card Here,', title: 'Card number', controller: cardNumberController),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: textFieldWidget(hintText: 'MM/DD', title: 'Valid until', controller: validUntilController)),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: textFieldWidget(
                              hintText: '***',
                              title: 'CVV',
                              controller: cvvController,
                              trailingWidget: const Icon(Icons.info_outline_rounded, color: AppColors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: simpleTextBorderButton(
                context: context,
                color: AppColors.green,
                buttonLable: 'Checkout ',
                height: screenSize.height * 0.065,
                width: screenSize.width,
                isLoadingWidget: false,
                onTap: () {
                  Get.back();
                },
                isDarkColor: true,
                isFillColor: true,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget textFieldWidget({String? title, String? hintText, TextEditingController? controller, Widget? trailingWidget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          style: FontUtils.h16(fontColor: AppColors.black),
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: FontUtils.h14(fontColor: AppColors.black),
            suffixIcon: trailingWidget,
          ),
        ),
      ],
    );
  }
}
