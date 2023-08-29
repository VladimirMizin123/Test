import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/widget/svg_image.dart';

import '../constant/string_utils.dart';

Widget buildButton(
    {required BuildContext context,
    String? title,
    void Function()? onPressed,
    Color? bgColor,
    Color? textColor,
    bool? hasImage = false,
    String? imagePath}) {
  return SizedBox(
    width: double.infinity.w,
    height: 48.h,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          hasImage == true
              ? Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 4),
                  child: SvgPicture.asset(
                    imagePath!,
                    height: 24.h,
                    width: 20.w,
                  ),
                )
              : const SizedBox(),
          Text(title!,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: textColor)),
        ],
      ),
    ),
  );
}

Widget buildBorderButton({
  required BuildContext context,
  String? title,
  void Function()? onPressed,
  Color? bgColor,
  Color? textColor,
  required Color borderColor,
}) {
  return SizedBox(
    width: double.infinity.w,
    height: 48.h,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: borderColor)),
      ),
      child: Text(title!,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: textColor)),
    ),
  );
}

Widget commonTextField({
  String? hintText,
  bool isPassword = false,
  TextEditingController? controller,
  required BuildContext context,
}) {
  return SizedBox(
    height: 48.h,
    child: TextFormField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: const Color(0xFF5F5F5F),
          ),
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF5F5F5F)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    ),
  );
}

Widget commonUserTypeTextField(
    {required String hintText,
    required TextEditingController controller,
    required BuildContext context,
    required double width,
    required double fontSize,
    required FontWeight? fontWeight,
    required Color fontColor,
    required Color valueColor,
    Color? borderColor,
    required Color cursorColor,
    required TextInputType textInputType,
    required Function(String value) onChange,
    bool isSuffix = false}) {
  return Container(
    height: 48.h,
    width: width.w,
    decoration: BoxDecoration(
      border: Border.all(
          color: Colors.grey.shade300, // Set border color
          width: 1.0), // Set border width
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
    ),
    child: Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: textInputType,
            cursorColor: cursorColor,
            style: TextStyle(fontWeight: fontWeight, color: valueColor),
            onChanged: (value) {
              onChange(value);
            },
            decoration: InputDecoration(
              filled: false,
              hintText: hintText,
              hintStyle: TextStyle(
                  fontSize: fontSize.sp,
                  fontWeight: FontWeight.w400,
                  color: fontColor),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    BorderSide(color: borderColor ?? Colors.transparent),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    BorderSide(color: borderColor ?? Colors.transparent),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    BorderSide(color: borderColor ?? Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    BorderSide(color: borderColor ?? Colors.transparent),
              ),
            ),
          ),
        ),
        Visibility(
            visible: isSuffix,
            child: const Text(
              StringUtils.lbs,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
            ).marginOnly(right: 5))
      ],
    ),
  );
}

Widget commonSearchTextField({
  required String hintText,
  required TextEditingController controller,
  required BuildContext context,
  required double fontSize,
  required Color fontColor,
  required TextInputType textInputType,
  required Function(String value) onChange,
  required Function() onClear,
}) {
  return Container(
    height: 48.h,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryBlue.withOpacity(0.10),
          spreadRadius: 0,
          blurRadius: 10,
          offset: const Offset(0, 0), // changes position of shadow
        ),
      ],
    ),
    child: Row(
      children: [
        const SvgImage(
          image: AssetsUtils.icSearch,
        ).marginOnly(left: 15),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: textInputType,
            style: TextStyle(
              fontSize: fontSize.sp,
              fontWeight: FontWeight.w400,
            ),
            onChanged: (value) {
              onChange(value);
            },
            decoration: InputDecoration(
              filled: false,
              hintText: hintText,
              hintStyle: TextStyle(
                  fontSize: fontSize.sp,
                  fontWeight: FontWeight.w400,
                  color: fontColor),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ),
        Visibility(
          visible: controller.text.isNotEmpty,
          child: InkWell(
            onTap: () {
              onClear();
            },
            child: const SvgImage(
              image: AssetsUtils.icClose,
            ).marginOnly(right: 15),
          ),
        ),
      ],
    ),
  );
}

showToast({required String message, required bool isSuccess}) {
  if (isSuccess) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  } else {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        backgroundColor: Colors.red,
        fontSize: 16.0);
  }
}

Widget arrowButton({String? icon}) {
  return Container(
    height: 30.h,
    width: 30.w,
    decoration: BoxDecoration(
      color: Colors.white60,
      shape: BoxShape.circle,
      border: Border.all(
          style: BorderStyle.solid,
          color: AppColors.disable,
          width: 1.0), // Set border width
    ),
    child: Center(
      child: Image.asset(
        icon.toString(),
        height: 13.h,
        width: 13.w,
      ),
    ),
  );
}

Widget buildGymEatsHeader({Widget? child, Color? bgColor}) {
  return Container(
    width: double.infinity.w,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: child,
  );
}

Widget dashBoardCardView(
    {Widget? child,
    double? height,
    double? width,
    EdgeInsetsGeometry? margin}) {
  return Container(
    height: height,
    width: width,
    margin: margin,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.r),
      color: Colors.white,
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 76, 99, 0.08),
          blurRadius: 5,
          offset: Offset(1, 1),
        )
      ],
    ),
    child: child,
  );
}

Widget commonSliderView({
  String? icon,
  String? title,
  TextTheme? textTheme,
}) {
  return Container(
    height: 48.h,
    width: 170.w,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 76, 99, 0.08),
            spreadRadius: 0.5,
            blurRadius: 0.5,
            offset: Offset(0, 0),
          ),
        ]),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            icon.toString(),
            height: 28.h,
            width: 28.w,
          ),
          Text(
            title.toString(),
            style:
                textTheme?.headlineSmall?.copyWith(color: AppColors.darkGray),
          ),
          addIcon(),
        ],
      ),
    ),
  );
}

Widget addIcon() {
  return Container(
    height: 40.h,
    width: 45.w,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.r),
      color: AppColors.skyBlue,
    ),
    child: const Center(
      child: Icon(
        Icons.add,
        color: AppColors.primaryBlue,
      ),
    ),
  );
}

Widget mealPlanCard({
  String? mealTitle,
  String? mealDescription,
  String? mealCal,
  required BuildContext context,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(0, 76, 99, 0.08),
              blurRadius: 5,
              spreadRadius: 2)
        ],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                AssetsUtils.defaultImage,
                height: 80.h,
                width: 90.w,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 80.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(mealTitle ?? '',
                          style: FontUtils.h14(
                              fontColor: AppColors.darkGray,
                              fontWeight: FWT.lightMedium)),
                      Text(mealDescription ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: FontUtils.h16(
                              fontColor: AppColors.darkGray,
                              fontWeight: FWT.regular)),
                      Text(mealCal ?? '',
                          style: FontUtils.h14(
                              fontColor: AppColors.letsEatButton,
                              fontWeight: FWT.lightMedium)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.arrow_forward_ios_outlined,
                  size: 18, color: AppColors.middleGray)
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              simpleTextBorderButton(context, 'Skip Meal'),
              simpleTextBorderButton(context, 'Swap Meal'),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget simpleTextBorderButton(BuildContext context, String buttonLable) {
  final screenSize = MediaQuery.of(context).size;
  return Container(
    height: screenSize.height * 0.04,
    width: screenSize.width * 0.41,
    decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryBlue),
        borderRadius: BorderRadius.circular(10)),
    child: Center(
        child: Text(buttonLable,
            style: FontUtils.h16(
                fontColor: AppColors.primaryBlue, fontWeight: FWT.regular))),
  );
}
