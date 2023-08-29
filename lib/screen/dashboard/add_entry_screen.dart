import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import '../../constant/string_utils.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final routeName = '/add-Entry-screen';
  final entryController = TextEditingController();
  final minutesController = TextEditingController();
  final caloriesBurnedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height.h,
        width: size.width.w,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  size: 25.sp,
                  color: AppColors.darkGray,
                ),
                Text(
                  StringUtils.addEntry,
                  style: textTheme.displayMedium?.copyWith(color: Colors.black),
                ).paddingOnly(right: 28.w),
                const SizedBox(),
              ],
            ).paddingOnly(top: 30.h),
            dashBoardCardView(
              width: 335.w,
              margin: EdgeInsets.symmetric(vertical: 20.h),
              child: Column(
                children: [
                  commonUserTypeTextField(
                    hintText: StringUtils.running,
                    controller: entryController,
                    context: context,
                    width: double.infinity.w,
                    fontSize: 16.sp,
                    borderColor: AppColors.primaryBlue,
                    fontWeight: FontWeight.w400,
                    isSuffix: false,
                    valueColor: AppColors.darkGray,
                    fontColor: AppColors.darkGray,
                    cursorColor: AppColors.darkGray,
                    textInputType: TextInputType.text,
                    onChange: (value) {},
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'minutes',
                        style: textTheme.bodyLarge
                            ?.copyWith(color: AppColors.darkGray),
                      ),
                      commonUserTypeTextField(
                          hintText: '25',
                          controller: minutesController,
                          context: context,
                          width: 80.w,
                          fontSize: 16.sp,
                          borderColor: AppColors.primaryBlue,
                          fontWeight: FontWeight.w400,
                          isSuffix: false,
                          valueColor: AppColors.darkGray,
                          fontColor: AppColors.darkGray,
                          cursorColor: AppColors.darkGray,
                          textInputType: TextInputType.number,
                          onChange: (value) {}),
                    ],
                  ).paddingOnly(top: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Calories Burned',
                        style: textTheme.bodyLarge
                            ?.copyWith(color: AppColors.darkGray),
                      ),
                      commonUserTypeTextField(
                          hintText: '200cal',
                          controller: caloriesBurnedController,
                          context: context,
                          width: 80.w,
                          fontSize: 16.sp,
                          borderColor: AppColors.primaryBlue,
                          fontWeight: FontWeight.w400,
                          isSuffix: false,
                          valueColor: AppColors.darkGray,
                          fontColor: AppColors.darkGray,
                          cursorColor: AppColors.darkGray,
                          textInputType: TextInputType.text,
                          onChange: (value) {}),
                    ],
                  ).paddingOnly(top: 8.h),
                ],
              ).paddingAll(16),
            ),
            const Spacer(),
            buildButton(
                    context: context,
                    title: StringUtils.save,
                    hasImage: false,
                    textColor: AppColors.skyBlue,
                    onPressed: () {},
                    bgColor: AppColors.primaryBlue)
                .paddingOnly(bottom: 20.h),
          ],
        ).paddingSymmetric(horizontal: 20.w),
      ),
    );
  }

  Widget waterDetailsView(
      {String? waterIcon,
      String? waterQuantity,
      double? height,
      void Function()? onTap}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          waterIcon.toString(),
          height: height,
          width: 48.w,
        ),
        Text(
          '$waterQuantity ml',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.darkGray),
        ).paddingOnly(top: 3.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 25.h,
            width: 25.w,
            margin: EdgeInsets.only(top: 5.h),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.skyBlue,
            ),
            child: const Center(
              child: Icon(
                Icons.add,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        )
      ],
    );
  }
}
