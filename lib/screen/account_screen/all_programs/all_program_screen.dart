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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/screen/account_screen/account/account_scrren_widget.dart';
import 'package:gymeats_mobile/screen/account_screen/all_programs/program_detail/program_detail_screen.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_bloc.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_state.dart';
import 'package:gymeats_mobile/screen/account_screen/model/get_all_programs_model.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import '../../../constant/asset_utils.dart';
import '../../../constant/color_utils.dart';
import '../../../widget/svg_image.dart';

class AllProgramScreen extends StatefulWidget {
  const AllProgramScreen({super.key});

  @override
  State<AllProgramScreen> createState() => _AllProgramScreenState();
}

class _AllProgramScreenState extends State<AllProgramScreen> {
  // List programList = [
  //   {
  //     "image": AssetsUtils.appleLogo,
  //     "title": "Keto",
  //     "subtitle": "by Dr. David"
  //   },
  //   {
  //     "image": AssetsUtils.appleLogo,
  //     "title": "Keto",
  //     "subtitle": "by Dr. David"
  //   },
  //   {
  //     "image": AssetsUtils.appleLogo,
  //     "title": "Keto",
  //     "subtitle": "by Dr. David"
  //   },
  //   {
  //     "image": AssetsUtils.appleLogo,
  //     "title": "Keto",
  //     "subtitle": "by Dr. David"
  //   },
  //   {
  //     "image": AssetsUtils.appleLogo,
  //     "title": "Keto",
  //     "subtitle": "by Dr. David"
  //   },
  //   {
  //     "image": AssetsUtils.appleLogo,
  //     "title": "Keto",
  //     "subtitle": "by Dr. David"
  //   },
  //   {
  //     "image": AssetsUtils.appleLogo,
  //     "title": "Keto",
  //     "subtitle": "by Dr. David"
  //   },
  //   {
  //     "image": AssetsUtils.appleLogo,
  //     "title": "Keto",
  //     "subtitle": "by Dr. David"
  //   },
  //   {
  //     "image": AssetsUtils.appleLogo,
  //     "title": "Keto",
  //     "subtitle": "by Dr. David"
  //   },
  // ];
  AccountBloc accountBloc = AccountBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      accountBloc.add(GetAllProgramEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AccountTitleWidget(
          title: "All Programs",
          widget: Expanded(
            child: Container(
                margin: EdgeInsets.only(top: 150.h),
                child: BlocConsumer(
                  bloc: accountBloc,
                  builder: (context, state) {
                    if (state is GetAllProgramLoadingState) {
                      return const AppCenterLoader();
                    }

                    if (state is GetAllProgramErrorState) {
                      return Center(
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: AppColors.primaryBlue,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                      );
                    }

                    if (state is GetAllProgramSuccessState) {
                      List<ProgramModel> programModelData =
                          state.programModelData;

                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: programModelData.length,
                          itemBuilder: (context, index) {
                            var data = programModelData[index].node;
                            return Container(
                              margin: EdgeInsets.only(
                                  left: 8.w,
                                  right: 8.w,
                                  bottom: 15.h,
                                  top: 3.h),
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
                                leading: CircleAvatar(
                                  radius: 30.w,
                                  child: CachedNetworkImage(
                                    imageUrl: data?.programIcons ?? "",
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        ClipRRect(
                                      borderRadius: BorderRadius.circular(10.w),
                                      child: const Icon(
                                        Icons.error,
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  data?.name ?? '',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  data?.author ?? "",
                                  style: const TextStyle(color: Colors.black),
                                ),
                                trailing: const SvgImage(
                                    image: AssetsUtils.forwardArrow),
                                onTap: () {
                                  Get.to(() => ProgramDetailScreen(
                                      programId: data?.id ?? ""));
                                  // const ProgramDetailScreen();
                                },
                              ).paddingOnly(top: 4.h, bottom: 4.h),
                            );
                          });
                    }

                    return const Center(
                      child: Text(
                        'No Data',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    );
                  },
                  listener: (context, state) {},
                )).paddingOnly(left: 15.w, right: 15.w),
          ),
        ),
      ),
    );
  }
}
