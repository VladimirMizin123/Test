import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/back_button_widget.dart';

import '../../../constant/font_utils.dart';

class AddDeliveryAddressScreen extends StatefulWidget {
  const AddDeliveryAddressScreen({super.key});

  @override
  State<AddDeliveryAddressScreen> createState() => _AddDeliveryAddressScreenState();
}

class _AddDeliveryAddressScreenState extends State<AddDeliveryAddressScreen> {
  TextEditingController streetController = TextEditingController();
  TextEditingController apartmentNumberController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
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
                Text('Add delivery address', style: FontUtils.h20(fontColor: AppColors.oxFF010101, fontWeight: FWT.semiBold)),
                Opacity(opacity: 0, child: Text('Edit', style: FontUtils.h16(fontColor: AppColors.oxFF010101))),
              ],
            ).paddingSymmetric(horizontal: 6, vertical: 5.h),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      textFieldWidget(title: 'Street', controller: streetController, hintText: '430 Tanyard Rd, Rocky Mount', onTap: () {}),
                      const SizedBox(height: 10),
                      textFieldWidget(title: 'Apartment number ', controller: streetController, hintText: '18', onTap: () {}),
                      const SizedBox(height: 10),
                      textFieldWidget(title: 'Zip', controller: streetController, hintText: '24151', onTap: () {}),
                      const SizedBox(height: 10),
                      textFieldWidget(title: 'Phone number ', controller: streetController, hintText: '+1 111-111-1111', onTap: () {}),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: simpleTextBorderButton(
                context: context,
                color: AppColors.green,
                buttonLable: 'Save',
                height: screenSize.height * 0.065,
                width: screenSize.width,
                isLoadingWidget: false,
                onTap: () {
                  Get.toNamed('/PaymentSuccessScreen');
                },
                isDarkColor: true,
                isFillColor: true,
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget textFieldWidget({String? title, String? hintText, TextEditingController? controller, VoidCallback? onTap}) {
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
            hintStyle: FontUtils.h12(fontColor: AppColors.middleGray),
            suffixIcon: const Icon(Icons.cancel_outlined, color: AppColors.black),
          ),
        ),
      ],
    );
  }
}
