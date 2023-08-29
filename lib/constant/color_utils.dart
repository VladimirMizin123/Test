import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  static const letsEatButton = Color(0xFFCE6B53);
  static const letsEat = Color(0xFFF9D5C5);
  static const appColor = Color(0xFF336633);
  static const disabledColor = Color(0xFFC7C8CA);
  static const grayColor = Color(0xFFA2A4A7);
  static const switchColor = Color(0xFF34C759);
  static const blueFocusedColor = Color(0xFF003D4F);

  static ThemeData lightTheme() {
    return ThemeData(
      primaryColor: const Color(0xFF004C63),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF004C63),
        onPrimary: Color(0xFF004C63),
        secondary: Color(0xFFD9E9EE),
        onSecondary: Color(0xFFD9E9EE),
        error: Color(0xFFFF9500),
        onError: Color(0xFFFF9500),
        background: Color(0xFFE5E5E5),
        onBackground: Color(0xFFE5E5E5),
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFFFFFFFF),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xFF004C63),
        textTheme: ButtonTextTheme.primary,
      ),
      fontFamily: 'Avenir',
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w300,
            height: 1.5,
            color: const Color(0xFF5F5F5F)),
        hintStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w300,
            height: 1.5,
            color: const Color(0xFF5F5F5F)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0XFFFF3B30)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          // H1
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -2.5,
        ),
        displayMedium: TextStyle(
          // H2
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
        headlineSmall: TextStyle(
          //H5
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          // Body 1
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          // Body 1
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
        bodySmall: TextStyle(
          // Body 2
          fontSize: 12,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  static const black = Color(0xFF000000);

  static const green = Color(0xFF336633);
  static const primaryBlue = Color(0xFF004C63);
  static const terracotta = Color(0xFFCE6B53);

  static const greenPressed = Color(0xFF1F3D1F);
  static const bluePressed = Color(0xFF002E3B);
  static const terracottaPressed = Color(0xFFA55642);

  static const mint = Color(0xFFC1EACE);
  static const skyBlue = Color(0xFFD9E9EE);
  static const coral = Color(0xFFF9D5C5);

  static const whiteColor = Color(0xFFFFFFFF);
  static const lightGrey = Color(0xFFECECED);
  static const disable = Color(0xFFC7C8CA);
  static const middleGray = Color(0xFF5F5F5F);
  static const darkGray = Color(0xFF373737);
  static const oxFF010101 = Color(0xFF010101);
  static const newDarkBlue = Color(0xFF6A909D);
  static const inactive = Color(0xFFD9D9D9);
  static const gray = Color(0xFFA2A4A7);
}
