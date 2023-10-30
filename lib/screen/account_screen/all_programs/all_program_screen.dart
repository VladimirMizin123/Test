/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/widget/svg_image.dart';

class AllProgramScreen extends StatefulWidget {
  const AllProgramScreen({super.key});

  @override
  State<AllProgramScreen> createState() => _AllProgramScreenState();
}

class _AllProgramScreenState extends State<AllProgramScreen> {
  List programList = [
    {
      "image": AssetsUtils.appleLogo,
      "title": "Keto",
      "subtitle": "by Dr. David"
    },
    {
      "image": AssetsUtils.appleLogo,
      "title": "Keto",
      "subtitle": "by Dr. David"
    },
    {
      "image": AssetsUtils.appleLogo,
      "title": "Keto",
      "subtitle": "by Dr. David"
    },
    {
      "image": AssetsUtils.appleLogo,
      "title": "Keto",
      "subtitle": "by Dr. David"
    },
    {
      "image": AssetsUtils.appleLogo,
      "title": "Keto",
      "subtitle": "by Dr. David"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              snap: false,
              toolbarHeight: 120,
              backgroundColor: AppColors.whiteColor,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(20.w, 40.h, 12.w, 40.h),
                  height: 10,
                  width: 15,
                  child: const SvgImage(
                    image: AssetsUtils.icBackArrow,
                  ),
                ),
              ),
              title: Center(
                child: Column(
                  children: [
                    const Text("All Programs"),
                    SizedBox(height: 15.h),
                    Container(
                      height: 40.h,
                      width: 95.h,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AssetsUtils.gymEatsSpoon),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ],
                ),
              ),
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                // centerTitle: true,
                background: Stack(
                  children: [
                    Image.asset(
                      AssetsUtils.lightBlueBackGroundImage,
                    ),
                    */
/* Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(left: 25.w, right: 25.w),
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F6F9),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                    ),*/ /*

                  ],
                ),
              ),
            )
          ],
          body: Container(
            margin: EdgeInsets.only(left: 25.w, right: 25.w, top: 20.h),
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
            ),
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: programList.length,
                itemBuilder: (context, index) {
                  var data = programList[index];
                  return Container(
                    margin: EdgeInsets.only(
                        left: 8.w, right: 8.w, bottom: 15.h, top: 3.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset:
                              const Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Container(
                        height: 55.w,
                        width: 55.w,
                        decoration: const BoxDecoration(
                          color: AppColors.middleGray,
                          shape: BoxShape.circle,
                        ),
                        child: SvgImage(image: data["image"]),
                      ),
                      title: Text(data["title"]),
                      subtitle: Text(data["subtitle"]),
                      trailing: const SvgImage(image: AssetsUtils.forwardArrow),
                    ).paddingOnly(top: 4.h, bottom: 4.h),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/screen/account_screen/account/account_scrren_widget.dart';

import '../../../constant/asset_utils.dart';
import '../../../constant/color_utils.dart';
import '../../../widget/svg_image.dart';

class AllProgramScreen extends StatefulWidget {
  const AllProgramScreen({super.key});

  @override
  State<AllProgramScreen> createState() => _AllProgramScreenState();
}

class _AllProgramScreenState extends State<AllProgramScreen> {
  List programList = [
    {
      "image": AssetsUtils.appleLogo,
      "title": "Keto",
      "subtitle": "by Dr. David"
    },
    {
      "image": AssetsUtils.appleLogo,
      "title": "Keto",
      "subtitle": "by Dr. David"
    },
    {
      "image": AssetsUtils.appleLogo,
      "title": "Keto",
      "subtitle": "by Dr. David"
    },
    {
      "image": AssetsUtils.appleLogo,
      "title": "Keto",
      "subtitle": "by Dr. David"
    },
    {
      "image": AssetsUtils.appleLogo,
      "title": "Keto",
      "subtitle": "by Dr. David"
    },
    {
      "image": AssetsUtils.appleLogo,
      "title": "Keto",
      "subtitle": "by Dr. David"
    },
    {
      "image": AssetsUtils.appleLogo,
      "title": "Keto",
      "subtitle": "by Dr. David"
    },
    {
      "image": AssetsUtils.appleLogo,
      "title": "Keto",
      "subtitle": "by Dr. David"
    },
    {
      "image": AssetsUtils.appleLogo,
      "title": "Keto",
      "subtitle": "by Dr. David"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AccountTitleWidget(
              title: "All Programs",
              widget: Container(
                height: 600,
                margin: EdgeInsets.only(top: 150.h),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: programList.length,
                    itemBuilder: (context, index) {
                      var data = programList[index];
                      return Container(
                        margin: EdgeInsets.only(
                            left: 8.w, right: 8.w, bottom: 15.h, top: 3.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.w),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(
                                  0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Container(
                            height: 55.w,
                            width: 55.w,
                            decoration: const BoxDecoration(
                              color: AppColors.middleGray,
                              shape: BoxShape.circle,
                            ),
                            child: SvgImage(image: data["image"]),
                          ),
                          title: Text(data["title"]),
                          subtitle: Text(data["subtitle"]),
                          trailing:
                              const SvgImage(image: AssetsUtils.forwardArrow),
                        ).paddingOnly(top: 4.h, bottom: 4.h),
                      );
                    }),
              ).paddingOnly(left: 15.w, right: 15.w),
            ),
          ],
        ),
      ),
    );
  }
}
