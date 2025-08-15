// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/font_utils.dart';
import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
import 'package:gymeats_mobile/service/toast_service.dart';
import 'package:gymeats_mobile/widget/svg_image.dart';

import '../constant/string_utils.dart';

Widget buildButton({
  required BuildContext context,
  String? title,
  void Function()? onPressed,
  Color? bgColor,
  Color? textColor,
  bool? hasImage = false,
  String? imagePath,
  bool showLoader = false,
  double borderRadius = 8,
}) {
  return SizedBox(
    width: double.infinity.w,
    height: 48.h,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: showLoader
          ? const Center(
              child: SizedBox(
                height: 28,
                width: 28,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                hasImage == true
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: SvgPicture.asset(
                          imagePath!,
                          height: 24.h,
                          width: 24.w,
                        ),
                      )
                    : const SizedBox(),
                Text(title!,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: textColor, fontSize: 19.sp)),
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
  bool eyeShow = false,
  Function()? onTap,
  Widget? suffixIcon,
  int? maxLength,
  TextEditingController? controller,
  required BuildContext context,
  TextInputType? textInputType,
  void Function(String)? onChanged,
  bool? isWeight = false,
  bool readOnly = false,
  List<TextInputFormatter>? inputFormatters,
}) {
  return SizedBox(
    height: 48.h,
    child: TextFormField(
      controller: controller,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: const Color(0xFF5F5F5F), fontSize: 16.sp),
      obscureText: eyeShow == true
          ? isPassword
              ? false
              : true
          : false,
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
      // readOnly: readOnly,
      onChanged: onChanged,
      maxLength: maxLength ?? 10000,
      decoration: InputDecoration(
        counterText: '',
        hintText: hintText,
        isDense: true,
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
        suffixIcon: eyeShow == true
            ? InkWell(
                onTap: onTap,
                child: Icon(
                    isPassword ? Icons.visibility : Icons.visibility_off,
                    size: 25,
                    color: const Color(0xFF004C63)))
            : null,
      ),
    ),
  );
}

Widget commonUserTypeTextField({
  required String hintText,
  required TextEditingController controller,
  required BuildContext context,
  required double width,
  required double fontSize,
  required FontWeight? fontWeight,
  required Color fontColor,
  required Color valueColor,
  Color? borderColor,
  required Color cursorColor,
  TextInputType? textInputType,
  required Function(String value) onChange,
  bool isSuffix = false,
  bool isReadOnly = false,
  List<TextInputFormatter>? inputFormatters,
}) {
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
            readOnly: isReadOnly,
            inputFormatters: inputFormatters,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              filled: false,
              isCollapsed: true,
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
  bool isDense = false,
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
      crossAxisAlignment: CrossAxisAlignment.center,
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
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            onChanged: (value) {
              onChange(value);
            },
            decoration: InputDecoration(
              isDense: isDense,
              filled: false,
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: fontSize.sp,
                fontWeight: FontWeight.w400,
                color: fontColor,
              ),
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

showToast({
  required String message,
  required bool isSuccess,
  Color? color,
  int? timeInSecForIosWeb,
}) {
  if (message.trim().isEmpty) {
    return;
  }
  ToastService.showToast(message, isSuccess: isSuccess, defaultColor: color);
}

Widget arrowButton({String? icon, bool isDisable = false}) {
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
        color: isDisable ? AppColors.disable : null,
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

Widget commonSliderView(
    {String? icon,
    String? title,
    TextTheme? textTheme,
    BuildContext? context,
    int? weightValue}) {
  return GestureDetector(
    onTap: () {
      Get.toNamed("/AddNewItemScreen", arguments: {
        "title": title,
        "date": DateTime.now(),
      });
    },
    child: Container(
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
  MealData? mealData,
  // String? image,
  // String? mealTitle,
  // String? mealDescription,
  // String? mealCal,
  required BuildContext context,
  VoidCallback? onSkipMealTap,
  VoidCallback? onSwapMealTap,
  VoidCallback? onTap,
}) {
  bool isSkipped = (mealData?.isSkipped ?? false);
  bool isEaten = (mealData?.isDone ?? false);
  return GestureDetector(
    onTap: onTap,
    child: Padding(
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
            borderRadius: BorderRadius.circular(14),
          ),
          child: isSkipped || isEaten
              ? Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 80.h,
                            width: 90.w,
                            color: AppColors.lightGrey,
                            child: Center(
                              child: isEaten
                                  ? CircleAvatar(
                                      radius: 15,
                                      backgroundColor: AppColors.primaryBlue,
                                      child: SvgPicture.asset(AssetsUtils.done,
                                          color: AppColors.whiteColor),
                                    )
                                  : SvgPicture.asset(
                                      AssetsUtils.icSkippedIcon,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 80.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  isSkipped
                                      ? StringUtils.skipped
                                      : StringUtils.eaten,
                                  style: FontUtils.h16(
                                      fontColor: AppColors.darkGray,
                                      fontWeight: FWT.regular)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 80.h,
                            width: 90.w,
                            color: AppColors.lightGrey,
                            child: CachedNetworkImage(
                              imageUrl: mealData?.recipe?.mainImage ?? '',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                color: AppColors.lightGrey,
                              )),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(mealData?.meal ?? '',
                                    style: FontUtils.h14(
                                        fontColor: AppColors.darkGray,
                                        fontWeight: FWT.lightMedium)),
                                Text(mealData?.recipe?.name ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: FontUtils.h16(
                                        fontColor: AppColors.darkGray,
                                        fontWeight: FWT.regular)),
                                Text(
                                    "${mealData?.calories?.toStringAsFixed(2)} cal",
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
                        simpleTextBorderButton(
                            context: context,
                            buttonLable: StringUtils.skipMeal,
                            onTap: onSkipMealTap),
                        simpleTextBorderButton(
                            context: context,
                            buttonLable: StringUtils.swapMeal,
                            onTap: onSwapMealTap),
                      ],
                    ),
                  ],
                )),
    ),
  );
}

Widget simpleTextBorderButton({
  BuildContext? context,
  double? height,
  double? width,
  bool isFillColor = false,
  bool isDarkColor = false,
  String? buttonLable,
  VoidCallback? onTap,
  bool isLoadingWidget = false,
  Color? color,
  Color? lableColor,
  Color? txtColor,
}) {
  final screenSize = MediaQuery.of(context!).size;
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Container(
        height: height ?? screenSize.height * 0.04,
        width: width ?? screenSize.width * 0.41,
        decoration: isFillColor
            ? BoxDecoration(
                border: Border.all(
                    color: color ?? AppColors.primaryBlue,
                    width: isDarkColor ? 2 : 1),
                color: color ?? AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(8))
            : BoxDecoration(
                border: Border.all(
                    color: color ?? AppColors.primaryBlue,
                    width: isDarkColor ? 2 : 1),
                borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: isLoadingWidget
              ? Transform.scale(
                  scale: 0.5,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                  ))
              : Text(
                  buttonLable!,
                  style: isFillColor
                      ? FontUtils.h16(
                          fontColor: txtColor ?? AppColors.whiteColor,
                          fontWeight: isDarkColor ? FWT.semiBold : FWT.regular)
                      : FontUtils.h16(
                          fontColor: lableColor ?? AppColors.primaryBlue,
                          fontWeight: isDarkColor ? FWT.semiBold : FWT.regular),
                ),
        ),
      ),
    ),
  );
}

/*
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
}*/
