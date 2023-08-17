import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymeats_mobile/constant/app_TextStyle.dart';

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

Widget commonTextField(
    {String? hintText,
    TextEditingController? controller,
    required BuildContext context}) {
  GlobalKey globalKey = GlobalKey();
  return SizedBox(
    height: 48.h,
    child: TextFormField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: const Color(0xFF5F5F5F),
          ),
      decoration: InputDecoration(
        hintText: hintText,
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
