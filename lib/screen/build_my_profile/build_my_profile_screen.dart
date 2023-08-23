import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import '../../constant/app_colors.dart';
import '../../constant/app_string.dart';

class BuildMyProfileScreen extends StatefulWidget {
  const BuildMyProfileScreen({super.key});

  @override
  State<BuildMyProfileScreen> createState() => _BuildMyProfileScreenState();
}

class _BuildMyProfileScreenState extends State<BuildMyProfileScreen> {
  final routeName = '/build_my_profile_screen';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height.h,
        width: size.width.w,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppStrings.buildProfileBG), fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SvgPicture.asset(
                AppStrings.roundBlueLogo,
                height: 90.h,
                width: 90.w,
                color: Colors.white,
              ).paddingOnly(top: 28.h),
              buildGymEatsHeader(
                bgColor: Colors.white.withOpacity(0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.mindyPro,
                      style: textTheme.displayMedium
                          ?.copyWith(color: const Color(0xFF000000)),
                    ).paddingOnly(bottom: 3.h, left: 3.w, right: 3.w),
                    Text(
                      AppStrings.welcomeCommunity,
                      style: textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF000000), height: 1.2),
                    ).paddingOnly(bottom: 5.h, left: 3.w, right: 3.w),
                    Text(
                      AppStrings.welcomeCommunitySub,
                      style: textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF000000), height: 1.2),
                    ).paddingOnly(bottom: 8.h, left: 3.w, right: 3.w),
                    Text(
                      AppStrings.welcomeCommunityDescription,
                      style: textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF000000), height: 1.2),
                    ).paddingOnly(left: 3.w, right: 3.w),
                    buildButton(
                      context: context,
                      bgColor: AppColors.primaryBlue,
                      onPressed: () {},
                      textColor: AppColors.skyBlue,
                      title: AppStrings.buildMyProfile,
                      hasImage: false,
                    ).paddingOnly(
                        right: 3.w, left: 3.w, top: 13.h, bottom: 3.h),
                  ],
                ),
              ).paddingOnly(top: 225.h),
            ],
          ),
        ),
      ),
    );
  }
}
