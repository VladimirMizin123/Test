import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/account_screen/all_programs/program_detail/program_detail_scrern_widget.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_bloc.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_event.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_state.dart';
import 'package:gymeats_mobile/screen/account_screen/model/programs_info_model.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import '../../../../constant/asset_utils.dart';
import '../../../../constant/color_utils.dart';
import '../../../../widget/back_button_widget.dart';
import '../../../../widget/svg_image.dart';

class ProgramDetailScreen extends StatefulWidget {
  final String programId;
  const ProgramDetailScreen({super.key, required this.programId});

  @override
  State<ProgramDetailScreen> createState() => _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends State<ProgramDetailScreen> {
  List recipesList = [
    {"image": AssetsUtils.food3, "title": "Cilantro Soup"},
    {"image": AssetsUtils.food3, "title": "Cilantro Soup"},
    {"image": AssetsUtils.food3, "title": "Cilantro Soup"},
  ];

  final List<Tab> tabs = <Tab>[
    Tab(
      child: Text("Eat",
          style: TextStyle(
              color: AppColors.primaryBlueColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500)),
    ),
    Tab(
      child: Text("Eat Less",
          style: TextStyle(
              color: AppColors.primaryBlueColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500)),
    ),
    Tab(
      child: Text("Avoid",
          style: TextStyle(
              color: AppColors.primaryBlueColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500)),
    ),
  ];
  AccountBloc accountBloc = AccountBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      accountBloc.add(GetProgramInfoEvent(widget.programId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer(
          bloc: accountBloc,
          builder: (BuildContext context, state) {
            if (state is GetProgramInfoLoadingState) {
              return const AppCenterLoader();
            }
            if (state is UpdateDietProgramLoadingState) {
              return const AppCenterLoader();
            }

            if (state is GetProgramInfoErrorState) {
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
            if (state is GetProgramInfoSuccessState) {
              ProgramInfo data = state.programInfo;

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 230,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(data.backgroundImage ?? ""),
                              // image: AssetImage(AssetsUtils.vegetable),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Positioned(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14.w,
                                    backgroundColor: AppColors.whiteColor,
                                    child: Container(
                                        height: 17.w,
                                        width: 17.w,
                                        child: const Center(
                                          child: BackButtonWidget(),
                                        )),
                                  ),
                                  SizedBox(
                                    width: 90.w,
                                  ),
                                  Image.asset(AssetsUtils.gymEatsWhiteLogo),
                                ],
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              Container(
                                padding:
                                    EdgeInsets.only(top: 10.h, bottom: 10.h),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 30.w,
                                      backgroundColor:
                                          AppColors.primaryBlueColor,
                                      child: const SvgImage(
                                        image: AssetsUtils.appleLogo,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Text(data.name ?? '',
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500)),
                                    Text('by ${data.author ?? ''}',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w300,
                                            color: AppColors.middleGray)),
                                  ],
                                ),
                              )
                            ],
                          ).paddingOnly(top: 32.h, left: 20.w, right: 20.w),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("About",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24.sp))
                            .paddingOnly(right: 20.w, left: 20.w),
                        Text(data.descriptionShort ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp))
                            .paddingOnly(right: 20.w, left: 20.w),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(data.descriptionLong ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp))
                            .paddingOnly(right: 20.w, left: 20.w),
                        SizedBox(
                          height: 8.h,
                        ),
                        Container(
                          height: 170.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  spreadRadius: 1,
                                  blurRadius: 3),
                            ],
                          ),
                          padding: EdgeInsets.only(
                            top: 8.h,
                            left: 8.w,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Sample Recipes",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18.sp))
                                  .paddingOnly(left: 7.w),
                              SizedBox(
                                height: 6.h,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: recipesList.length,
                                  itemBuilder: (context, index) {
                                    var data = recipesList[index];
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 180.w,
                                          height: 90.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.w),
                                            image: DecorationImage(
                                                image:
                                                    AssetImage(data["image"]),
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                        Text(data["title"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16.sp)),
                                      ],
                                    ).paddingAll(7.w);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          "What to Eat",
                          style: TextStyle(
                              fontSize: 24.sp, fontWeight: FontWeight.w500),
                        ).paddingOnly(right: 20.w, left: 20.w),
                        Container(
                          // height: 700,
                          // color: Colors.red,
                          child: Column(
                            children: [
                              DefaultTabController(
                                length: tabs.length,
                                child: Column(
                                  children: [
                                    TabBar(
                                      isScrollable: false,
                                      indicatorColor:
                                          AppColors.primaryBlueColor,
                                      tabs: tabs,
                                    ),
                                    Container(
                                      height: 250.h,
                                      child: TabBarView(children: [
                                        Container(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: List.generate(
                                                data.cpcsIngredientGroups
                                                        ?.increase?.length ??
                                                    0,
                                                (index) => expandTileWidget(
                                                    title: Text(data
                                                            .cpcsIngredientGroups
                                                            ?.increase?[index]
                                                            .name ??
                                                        ""),
                                                    children: [
                                                      (data
                                                                  .cpcsIngredientGroups
                                                                  ?.increase?[
                                                                      index]
                                                                  .description
                                                                  ?.isEmpty ??
                                                              true)
                                                          ? const SizedBox()
                                                          : eatTabWidget(
                                                              creaseData: data
                                                                  .cpcsIngredientGroups
                                                                  ?.increase?[index]),
                                                    ]),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: List.generate(
                                                data.cpcsIngredientGroups
                                                        ?.decrease?.length ??
                                                    0,
                                                (index) => expandTileWidget(
                                                    title: Text(data
                                                            .cpcsIngredientGroups
                                                            ?.decrease?[index]
                                                            .name ??
                                                        ""),
                                                    children: [
                                                      (data
                                                                  .cpcsIngredientGroups
                                                                  ?.decrease?[
                                                                      index]
                                                                  .description
                                                                  ?.isEmpty ??
                                                              true)
                                                          ? const SizedBox()
                                                          : eatTabWidget(
                                                              creaseData: data
                                                                  .cpcsIngredientGroups
                                                                  ?.decrease?[index]),
                                                    ]),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: List.generate(
                                                data.cpcsIngredientGroups?.avoid
                                                        ?.length ??
                                                    0,
                                                (index) => expandTileWidget(
                                                    title: Text(data
                                                            .cpcsIngredientGroups
                                                            ?.avoid?[index]
                                                            .name ??
                                                        ""),
                                                    children: [
                                                      (data
                                                                  .cpcsIngredientGroups
                                                                  ?.avoid?[
                                                                      index]
                                                                  .description
                                                                  ?.isEmpty ??
                                                              true)
                                                          ? const SizedBox()
                                                          : eatTabWidget(
                                                              creaseData: data
                                                                  .cpcsIngredientGroups
                                                                  ?.avoid?[index]),
                                                    ]),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        BlocConsumer(
                          bloc: accountBloc,
                          builder: (context, state) {
                            return buildButton(
                                    context: context,
                                    title: "Start New Program",
                                    onPressed: () {
                                      accountBloc.add(UpdateProgramDietEvent(
                                          widget.programId));
                                    },
                                    textColor: AppColors.whiteColor,
                                    bgColor: AppColors.primaryBlueColor)
                                .paddingOnly(
                                    left: 22.w, right: 22.w, top: 12.h);
                          },
                          listener: (context, state) {},
                        )
                      ],
                    ),
                  ],
                ),
              );
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
          listener: (context, state) {
            if (state is UpdateDietProgramSuccessState) {
              accountBloc.add(GetProgramInfoEvent(widget.programId));
            }
          },
        ),
      ),
    );
  }
}
