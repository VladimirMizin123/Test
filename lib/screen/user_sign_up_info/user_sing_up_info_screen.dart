// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/controller/home_screen_controller.dart';
import 'package:gymeats_mobile/extention/ext_on_list.dart';
import 'package:gymeats_mobile/screen/user_survey/user_survey_screen.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import '../../app/functions.dart';
import '../../bloc/user_sign_up_info/user_sign_up_info_bloc.dart';
import '../../bloc/user_sign_up_info/user_sign_up_info_event.dart';
import '../../constant/app_TextStyle.dart';
import '../../constant/asset_utils.dart';
import '../../constant/color_utils.dart';
import '../../constant/string_utils.dart';
import '../../models/sign_up_data_navigate_model.dart';
import '../../widget/app_widget.dart';
import '../../widget/svg_image.dart';

class UserSignUpInfoScreen extends StatefulWidget {
  const UserSignUpInfoScreen({super.key});

  @override
  State<UserSignUpInfoScreen> createState() => _UserSignUpInfoScreenState();
}

class _UserSignUpInfoScreenState extends State<UserSignUpInfoScreen> {
  Color color = AppColors.primaryBlue;
  UserSignUpDataModel model = Get.arguments as UserSignUpDataModel;
  String userInfoImage = AssetsUtils.icMaleChart;
  UserSignUpInfoBloc bloc = UserSignUpInfoBloc();
  HomeScreenController homeScreenController = Get.find<HomeScreenController>();

  PageController pageController = PageController();
  final GlobalKey _alertKey = GlobalKey();
  int currentPage = 0;
  int itemsPerPage = 4;

  @override
  void initState() {
    super.initState();
    bloc.add(LatLogEvent());
    pageController = PageController(initialPage: 0);
    if (model.gender == StringUtils.male) {
      userInfoImage = AssetsUtils.icMaleChart;
      color = AppColors.primaryBlue;
    } else if (model.gender == StringUtils.female) {
      userInfoImage = AssetsUtils.icFemaleChart;
      color = AppColors.terracotta;
    } else {
      userInfoImage = AssetsUtils.icNonChart;
      color = AppColors.green;
    }
  }

  @override
  void dispose() {
    pageController.dispose(); // Dispose of the PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String?> goalList = dialGoalList
        .asMap()
        .map((i, e) {
          return MapEntry(i, homeScreenController.selectedItems[i] ? e : null);
        })
        .values
        .toList();
    List<CustomOptions> stringList = [
      model.options?.map((e) => e).toList() ?? [],
      goalList
          .where((element) => element != null)
          .toList()
          .asMap()
          .map(
            (i, e) => MapEntry(
              i,
              CustomOptions(optionColor: color, optionName: e!),
            ),
          )
          .values
          .toList(),
    ].expand((element) => element).toList();

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height.h,
          width: MediaQuery.of(context).size.width.w,
          padding: const EdgeInsets.all(12),
          child: BlocConsumer(
            builder: (context, state) {
              return Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 50.w),
                          Image.asset(
                            AssetsUtils.gymEatsLogo,
                            fit: BoxFit.cover,
                            color: color,
                            height: 60.h,
                          ),
                          if (model.userProfileImage != null) ...{
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                height: 50,
                                width: 50,
                                model.userProfileImage!,
                                fit: BoxFit.fill,
                              ),
                            ),
                          } else ...{
                            SizedBox(width: 50.w),
                          }
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        StringUtils.howDoesThisProfileLook,
                        style: AppTextStyle.gymEatsStyle.copyWith(
                            color: color,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500),
                      ).paddingOnly(top: 10),
                      SizedBox(height: 10.h),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 290,
                                  height: 290,
                                  child: SvgImage(
                                    fit: BoxFit.fill,
                                    image: userInfoImage,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(model.age!,
                                                style: AppTextStyle.gymEatsStyle
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 31.sp,
                                                        fontWeight:
                                                            FontWeight.w800))
                                            .paddingOnly(top: 5)
                                            .marginOnly(left: 90),
                                        Text(
                                                (model.height ?? "")
                                                    .replaceAll(".", "'"),
                                                style: AppTextStyle.gymEatsStyle
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 31.sp,
                                                        fontWeight:
                                                            FontWeight.w800))
                                            .paddingOnly(top: 5)
                                            .marginOnly(right: 105),
                                      ],
                                    ),
                                    Text(model.weight!,
                                            style: AppTextStyle.gymEatsStyle
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 31.sp,
                                                    fontWeight:
                                                        FontWeight.w800))
                                        .marginOnly(top: 60, right: 10),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 50),
                            // Align(
                            //   alignment: Alignment.bottomLeft,
                            //   child: SizedBox(
                            //     height: 100,
                            //     child: PageView.builder(
                            //       scrollDirection: Axis.horizontal,
                            //       controller: pageController,
                            //       itemCount:
                            //           (stringList.length / itemsPerPage).ceil(),
                            //       onPageChanged: (int page) {
                            //         setState(() {
                            //           currentPage = page;
                            //         });
                            //       },
                            //       itemBuilder:
                            //           (BuildContext context, int index) {
                            //         final startIndex = index * itemsPerPage;
                            //         final endIndex =
                            //             (index + 1) * itemsPerPage <
                            //                     stringList.length
                            //                 ? (index + 1) * itemsPerPage
                            //                 : stringList.length;
                            //         final pageData = stringList.sublist(
                            //             startIndex, endIndex);

                            //         return Row(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.stretch,
                            //           mainAxisAlignment: pageData.length > 3
                            //               ? MainAxisAlignment.spaceEvenly
                            //               : MainAxisAlignment.start,
                            //           children: List.generate(pageData.length,
                            //               (index) {
                            //             return Container(
                            //               height: 70.h,
                            //               width: 70.w,
                            //               padding: const EdgeInsets.all(18),
                            //               margin: EdgeInsets.only(
                            //                   right:
                            //                       index == (pageData.length - 1)
                            //                           ? 0
                            //                           : 2.5,
                            //                   left: index == 0 ? 0 : 2.5),
                            //               alignment: Alignment.center,
                            //               decoration: BoxDecoration(
                            //                   shape: BoxShape.circle,
                            //                   color:
                            //                       pageData[index].optionColor),
                            //               child: Text(
                            //                 pageData[index].optionName,
                            //                 textAlign: TextAlign.center,
                            //                 style: const TextStyle(
                            //                     fontSize: 12.0,
                            //                     color: Colors.white,
                            //                     fontWeight: FontWeight.w400),
                            //               ),
                            //             );
                            //           }),
                            //         );
                            //       },
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(height: 12),
                            // _buildPageIndicator(stringList),
                            ListView.builder(
                              itemCount: stringList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Transform.scale(
                                      scale: 1.5,
                                      child: Theme(
                                        data: ThemeData(
                                          unselectedWidgetColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                        child: AbsorbPointer(
                                          absorbing: true,
                                          child: Radio(
                                            visualDensity: const VisualDensity(
                                                horizontal: -4.0,
                                                vertical: -4.0),
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            groupValue: true,
                                            value: true,
                                            activeColor:
                                                Theme.of(context).primaryColor,
                                            onChanged: (_) {},
                                          ),
                                        ),
                                      ),
                                    ).paddingOnly(left: 10),
                                    Expanded(
                                      child: Text(
                                        stringList[index].optionName,
                                        style:
                                            AppTextStyle.gymEatsStyle.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ].addBetweenItems(const SizedBox(width: 15)),
                                ).paddingOnly(top: 10, bottom: 10);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildBorderButton(
                                context: context,
                                onPressed: () {
                                  Get.back();
                                },
                                textColor: setColor(gender: model.gender!),
                                borderColor: setColor(gender: model.gender!),
                                bgColor: Colors.white,
                                title: StringUtils.previous)
                            .paddingOnly(top: 25.h),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: buildButton(
                                context: context,
                                onPressed: () async {
                                  openLoader();
                                  UserSignUpDataModel userSignUpDataModel =
                                      UserSignUpDataModel(
                                    firstName: model.firstName,
                                    lastName: model.lastName,
                                    email: model.email,
                                    password: model.password,
                                    userName: model.userName,
                                    confirmPassword: model.confirmPassword,
                                    phoneNumber: model.phoneNumber,
                                    gender: model.gender,
                                    age: model.age,
                                    height: model.height,
                                    weight: model.weight,
                                    dietId: model.dietId,
                                    surveyId: model.surveyId,
                                    userProfileImage: model.userProfileImage,
                                    latitude: model.addAddressModel?.latitude
                                        .toString(),
                                    longitude: model.addAddressModel?.longitude
                                        .toString(),
                                    restrictionID: model.restrictionID,
                                    addAddressModel: model.addAddressModel,
                                    userId: model.userId,
                                    surveyReq: model.surveyReq,
                                  );
                                  bloc.add(
                                    SignUpApiEvent(
                                      model: userSignUpDataModel,
                                      onComplete: () {
                                        if (_alertKey.currentContext != null) {
                                          Get.back();
                                        }
                                      },
                                    ),
                                  );
                                },
                                textColor: Colors.white,
                                bgColor: setColor(gender: model.gender!),
                                title: StringUtils.next)
                            .paddingOnly(top: 25.h),
                      ),
                    ],
                  )
                ],
              );
            },
            bloc: bloc,
            listener: (context, state) {},
          ),
        ),
      ),
    );
  }

  Future<void> openLoader() async {
    try {
      DateTime time = DateTime.now();

      showGeneralDialog(
        context: context,
        pageBuilder: (_, __, ___) {
          return Material(
            key: _alertKey,
            color: AppColors.transparentColor,
            child: Align(
              alignment: Alignment.center,
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 13),
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      height: 200,
                      width: 270,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.black),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 60,
                            child: Align(
                              alignment: Alignment.center,
                              child: StreamBuilder(
                                stream: Stream.periodic(
                                    const Duration(milliseconds: 1000)),
                                builder: (context, snapshot) {
                                  int ml = DateTime.now()
                                      .difference(time)
                                      .inMilliseconds;
                                  return Text(
                                    ml > 8000
                                        ? StringUtils.almostThere
                                        : ml > 4000
                                            ? StringUtils
                                                .accountingForRestriction
                                            : StringUtils.generatingNewMealPlan,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.black,
                                      fontFamily: "Avenir",
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(
                            height: 30,
                            width: 30,
                            child: AppCenterLoader(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }
}
