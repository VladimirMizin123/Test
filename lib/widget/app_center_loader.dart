import 'package:flutter/material.dart';
import 'package:gymeats_mobile/constant/app_colors.dart';

class AppCenterLoader extends StatefulWidget {
  const AppCenterLoader({super.key});

  @override
  State<AppCenterLoader> createState() => _AppCenterLoaderState();
}

class _AppCenterLoaderState extends State<AppCenterLoader> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.appColor),
    );
  }
}
