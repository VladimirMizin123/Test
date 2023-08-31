import 'package:flutter/material.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';

enum FWT {
  bold,
  semiBold,
  medium,
  regular,
  lightMedium,
  light,
}

class FontUtils {
  static FontWeight getFontWeight(FWT fwt) {
    switch (fwt) {
      case FWT.light:
        return FontWeight.w200;
      case FWT.lightMedium:
        return FontWeight.w300;
      case FWT.regular:
        return FontWeight.w400;
      case FWT.medium:
        return FontWeight.w500;
      case FWT.semiBold:
        return FontWeight.w600;
      case FWT.bold:
        return FontWeight.w900;
    }
  }

  static TextStyle h6({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? AppColors.green,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 6,
      fontFamily: 'Avenir',
    );
  }

  static TextStyle h8({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? AppColors.green,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 8,
      fontFamily: 'Avenir',
    );
  }

  static TextStyle h10({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? AppColors.green,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 10,
      fontFamily: 'Avenir',
    );
  }

  static TextStyle h12({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? AppColors.green,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 12,
      fontFamily: 'Avenir',
    );
  }

  static TextStyle h14({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? AppColors.green,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 14,
      fontFamily: 'Avenir',
    );
  }

  static TextStyle h15({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? AppColors.green,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 15,
      fontFamily: 'Avenir',
    );
  }

  static TextStyle h16({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? AppColors.green,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 16,
      fontFamily: 'Avenir',
    );
  }
   static TextStyle h17({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? AppColors.green,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 17,
      fontFamily: 'Avenir',
    );
  }

  static TextStyle h18({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? AppColors.green,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 18,
      fontFamily: 'Avenir',
    );
  }

  static TextStyle h20({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? AppColors.green,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 20,
      fontFamily: 'Avenir',
    );
  }

  static TextStyle h22({
    required Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? AppColors.green,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 22,
      fontFamily: 'Avenir',
    );
  }

  static TextStyle h24({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? AppColors.green,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 24,
      fontFamily: 'Avenir',
    );
  }

  static TextStyle h26({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? AppColors.green,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 26,
      fontFamily: 'Avenir',
    );
  }

  static TextStyle h28({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? AppColors.green,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 28,
      fontFamily: 'Avenir',
    );
  }

  static TextStyle h34({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? AppColors.green,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 34,
      fontFamily: 'Avenir',
    );
  }

  static TextStyle h40({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? AppColors.green,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 40,
      fontFamily: 'Avenir',
    );
  }

  static TextStyle h48({
    Color? fontColor,
    FWT fontWeight = FWT.regular,
  }) {
    return TextStyle(
      color: fontColor ?? AppColors.green,
      fontWeight: getFontWeight(fontWeight),
      fontSize: 48,
      fontFamily: 'Avenir',
    );
  }
}
