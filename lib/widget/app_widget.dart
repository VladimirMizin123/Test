import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/app_TextStyle.dart';
import 'package:gymeats_mobile/constant/app_colors.dart';
import 'package:gymeats_mobile/widget/svg_image.dart';

import '../constant/app_string.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    required Color fontColor,
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
            cursorColor: Colors.white,
            style: const TextStyle(
                fontWeight: FontWeight.w900, color: Colors.white),
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
            visible: isSuffix,
            child: const Text(
              AppStrings.lbs,
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
          image: AppStrings.icSearch,
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
            onTap: (){
              onClear();
            },
            child: const SvgImage(
              image: AppStrings.icClose,
            ).marginOnly(right: 15),
          ),
        ),
      ],
    ),
  );
}

showToast({required String message, required bool isSuccess}) {

  if(isSuccess){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }else{
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        backgroundColor: Colors.red,
        fontSize: 16.0
    );
  }

}