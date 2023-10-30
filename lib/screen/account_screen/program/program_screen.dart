import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/app_TextStyle.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/screen/account_screen/all_programs/all_program_screen.dart';
import 'package:gymeats_mobile/screen/account_screen/all_programs/program_detail/program_detail_screen.dart';
import 'package:gymeats_mobile/widget/svg_image.dart';
import '../account/account_scrren_widget.dart';

class ProgramScreen extends StatefulWidget {
  const ProgramScreen({super.key});

  @override
  State<ProgramScreen> createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {
  List programList = [
    {
      "image": AssetsUtils.pencil,
      "title": "Retake Assessment",
      "color": AppColors.disable,
      "screen": const ProgramDetailScreen()
    },
    {
      "image": AssetsUtils.globalIcn,
      "title": "View All Programs",
      "color": AppColors.whiteColor,
      "screen": const AllProgramScreen(),
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AccountTitleWidget(
                title: "Program",
                widget: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: EdgeInsets.only(top: 150.h, right: 23.w, left: 23.w),
                  color: AppColors.transparentColor,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200, spreadRadius: 1),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            "Your current Program is:",
                            style: AppTextStyle.gymEatsStyle.copyWith(
                                fontSize: 16.sp, color: AppColors.middleGray),
                          ),
                          subtitle: Text(
                            "Diet",
                            style: AppTextStyle.gymEatsStyle.copyWith(
                                fontSize: 24.sp,
                                color: AppColors.darkGreyColor),
                          ),
                          leading: SvgImage(image: AssetsUtils.gymEatsImage),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      accountScreenListWidget(
                          children: List.generate(programList.length, (index) {
                        var data = programList[index];
                        return accountScreenDataWidget(
                          onTap: () {
                            print('object');
                            Get.to(data["screen"]);
                          },
                          color: data["color"],
                          leading: SvgImage(image: data["image"]),
                          title: Text(data["title"]),
                          trailing: const SvgImage(
                            image: AssetsUtils.forwardArrow,
                          ),
                        );
                      })),
                    ],
                  ),
                ).paddingOnly(top: 5.h),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
