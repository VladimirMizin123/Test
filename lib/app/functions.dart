import 'dart:ui';

import '../constant/app_colors.dart';
import '../constant/app_string.dart';

Color setColor({required String gender}) {
  if (gender == AppStrings.male) {
    return AppColors.primaryBlue;
  } else if (gender == AppStrings.female) {
    return AppColors.terracotta;
  } else {
    return AppColors.green;
  }
}