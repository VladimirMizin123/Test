import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/user_survey/user_survey_state.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/repository/get_account_details.dart';
import 'package:gymeats_mobile/repository/sign_up.dart';
import 'package:gymeats_mobile/screen/account_screen/program/program_screen.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/get_all_diet_model.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/get_all_restriction_modal.dart';
import '../../app/functions.dart';
import '../../bloc/user_survey/user_survey_bloc.dart';
import '../../bloc/user_survey/user_survey_event.dart';
import '../../constant/app_TextStyle.dart';
import '../../models/get_survey_model.dart';
import '../../models/sign_up_data_navigate_model.dart';
import '../../widget/app_center_loader.dart';
import '../../widget/app_widget.dart';
import '../../widget/svg_image.dart';
import '../../widget/user_survey_item.dart';

class UserSurveyScreen extends StatefulWidget {
  const UserSurveyScreen({super.key, this.isProfile});

  final bool? isProfile;

  @override
  State<UserSurveyScreen> createState() => _UserSurveyScreenState();
}

class _UserSurveyScreenState extends State<UserSurveyScreen> {
  UserSurveyBloc bloc = UserSurveyBloc();
  SurveyDataQuestion? getSurveyData;
  double percentage = 0.0;
  final searchController = TextEditingController();
  int optionIndex = 0;
  List<int> listIndex = [];
  List<CustomOptions> listOptions = [];
  List<Edge> edgesRestrictionList = [];
  List<DietDetails> dietList = [];
  List<DietDetails> searchDietList = [];
  List<Edge> searchEdgesRestrictionList = [];
  String surveyId = '';
  bool isSearchOn = false;
  UserSignUpDataModel model = Get.arguments as UserSignUpDataModel;
  List<String> restrictionIDList = [];
  String dietId = '';
  String searchDietId = '';
  bool isPreference = false;
  bool isNext = false;
  bool isListen = true;

  List<Color> colorList = [
    Colors.indigoAccent.withOpacity(0.8),
    Colors.redAccent.withOpacity(0.8),
    Colors.purpleAccent.withOpacity(0.8),
    Colors.deepPurpleAccent.withOpacity(0.8),
    Colors.tealAccent.withOpacity(0.8),
    Colors.pinkAccent.withOpacity(0.8),
    Colors.blueAccent.withOpacity(0.8),
    Colors.lightBlueAccent.withOpacity(0.8),
    Colors.cyanAccent.withOpacity(0.8),
    Colors.lightGreenAccent.withOpacity(0.8),
    Colors.greenAccent.withOpacity(0.8),
    Colors.yellowAccent.withOpacity(0.8),
    Colors.deepOrangeAccent.withOpacity(0.8),
    Colors.amberAccent.withOpacity(0.8),
    Colors.orangeAccent.withOpacity(0.8),
    Colors.limeAccent.withOpacity(0.8),
  ];

  @override
  void initState() {
    super.initState();
    debugPrint('widget.gender--> ${model.gender}');
    bloc.add(GetAllRestrictionEvent());
    bloc.add(GetDietPlanEvent());
    bloc.add(GetSurveyData());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.isProfile == true) {
          Navigator.of(context)..pop();

          // Get.off(() => const ProgramScreen());
        }
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          body: BlocConsumer<UserSurveyBloc, UserSurveyState>(
            bloc: bloc,
            builder: (context, state) {
              if (state is LoadSurveyData || state is NextScreenState) {
                return initView();
              }
              if (state is LoadingSurveyData) {
                return const AppCenterLoader();
              }
              if (state is GetDietPlanLoadingState) {
                return const AppCenterLoader();
              }
              if (state is GetAllRestrictionLoadingState) {
                return const AppCenterLoader();
              }
              if (state is ErrorStateData) {
                return Center(
                    child: Text(
                  state.errMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ));
              }

              return const AppCenterLoader();
            },
            listener: (context, state) {
              if (state is LoadSurveyData) {
                getSurveyData = state.surveyData;
                if (isListen == true) {
                  listOptions.add(
                    CustomOptions(
                      optionColor: getSurveyData!.options![0].color ??
                          AppColors.primaryBlue,
                      optionName: getSurveyData!.options![0].label ?? '',
                    ),
                  );
                  bloc.add(CheckSurveyData(index: 0));
                  isListen = false;
                }

                if (state.isAPIData) {
                  surveyId = getSurveyData!.surveyId!;
                }
              }

              if (state is NextScreenState) {
                UserSignUpDataModel userSignUpDataModel = UserSignUpDataModel(
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
                  dietId: searchDietId.isNotEmpty ? searchDietId : dietId,
                  surveyId: surveyId,
                  options: listOptions,
                  restrictionID: restrictionIDList,
                  addAddressModel: model.addAddressModel,
                );

                if (widget.isProfile == true) {
                  print("comes from profile");

                  AccountRepository().updateDietProgramInfo(dietId: dietId);
                  SignUpRepository().addUserRestriction(
                    userid: PreferenceUtils.getString(prefUserData),
                    restrictionList: restrictionIDList,
                  );
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.of(context)..pop();
                  });
                  // Get.off(() => const ProgramScreen());
                } else {
                  Get.toNamed(
                    '/UserPhotoSelectionScreen',
                    arguments: userSignUpDataModel,
                  );
                }
              }

              if (state is PreviousScreenState) {
                if (widget.isProfile == true) {
                  Navigator.of(context)..pop();
                  // Get.off(() => const ProgramScreen());
                } else {
                  Get.toNamed('/UserTypeScreen', arguments: model);
                }
              }

              if (state is GetAllRestrictionSuccessState) {
                edgesRestrictionList = state.edgesRestrictionList ?? [];
              }
              if (state is GetDietPlanSuccessState) {
                dietList = state.edgesRestrictionList ?? [];
              }
            },
          ),
        ),
      ),
    );
  }

  Widget initView() => Container(
        padding: EdgeInsets.all(20.0.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      if (widget.isProfile == true) {
                        Navigator.of(context)..pop();
                        // Get.off(() => const ProgramScreen());
                      } else {
                        Get.back();
                      }
                    },
                    child: const SvgImage(
                      image: AssetsUtils.icBack,
                    ),
                  ),
                ),
                if (widget.isProfile != true)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
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
                          dietId:
                              searchDietId.isNotEmpty ? searchDietId : dietId,
                          surveyId: surveyId,
                          options: listOptions,
                          restrictionID: restrictionIDList,
                          addAddressModel: model.addAddressModel,
                        );

                        Get.toNamed('/UserPhotoSelectionScreen',
                            arguments: userSignUpDataModel);
                      },
                      child: const Text('SKIP'),
                    ),
                  ),
/*
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: LinearPercentIndicator(
                      animation: true,
                      lineHeight: 6.0,
                      percent: percentage,
                      barRadius: const Radius.circular(100),
                      progressColor: AppColors.terracotta,
                      backgroundColor: AppColors.lightGrey,
                    ),
                  ),
                )
*/
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: Image.asset(
                AssetsUtils.gymEatsLogo,
                fit: BoxFit.cover,
                color: setColor(gender: model.gender!),
                height: 60.h,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              getSurveyData!.label!,
              textAlign: TextAlign.center,
              style: AppTextStyle.gymEatsStyle.copyWith(
                  color: setColor(gender: model.gender!),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500),
            ).paddingOnly(top: 10),
            SizedBox(
              height: 20.h,
            ),
            commonSearchTextField(
              fontColor: Colors.white,
              controller: searchController,
              fontSize: 13,
              hintText: StringUtils.required,
              textInputType: TextInputType.text,
              context: context,
              onChange: (String? value) {
                // bloc.add(SearchData(
                //   text: value,
                // ));
                setState(() {
                  // if (value != null || value != '') {
                  if (value!.isNotEmpty) {
                    isSearchOn = true;
                    if (isPreference == true) {
                      searchEdgesRestrictionList = edgesRestrictionList
                          .where((item) => item.node.name
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    } else {
                      searchDietList = dietList
                          .where((item) => item.dietName
                              .toString()
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    }
                  } else {
                    isSearchOn = false;
                  }
                });
              },
              onClear: () {
                for (var data in searchDietList) {
                  data.select = false;
                }
                for (var data in searchEdgesRestrictionList) {
                  data.node.isRestricted = false;
                }

                setState(() {
                  searchController.clear();
                  isSearchOn = false;
                  FocusScope.of(context).unfocus();
                });
                // bloc.add(SearchData(
                //   text: searchController.text,
                // ));
              },
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: isSearchOn
                  ? isPreference == true
                      ? searchEdgesRestrictionList.isEmpty
                          ? const Text('No Search Found!')
                          : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                crossAxisSpacing: 6.0,
                                mainAxisSpacing: 8.0,
                                children: List.generate(
                                  searchEdgesRestrictionList.length,
                                  (index) {
                                    return UserSurveyPreferenceSearchItems(
                                      data: searchEdgesRestrictionList[index],
                                      index: index,
                                      onTap: () {
                                        if (isPreference == false) {
                                          for (var element in searchDietList) {
                                            element.select = false;
                                          }

                                          searchDietList[index].select =
                                              !searchDietList[index].select;

                                          bloc.add(
                                              CheckSurveyData(index: index));

                                          searchDietId =
                                              searchDietList[index].id!;
                                          setState(() {});
                                        } else {
                                          setState(() {
                                            searchEdgesRestrictionList[index]
                                                    .node
                                                    .isRestricted =
                                                !searchEdgesRestrictionList[
                                                        index]
                                                    .node
                                                    .isRestricted;

                                            if (restrictionIDList.contains(
                                                searchEdgesRestrictionList[
                                                        index]
                                                    .node
                                                    .id)) {
                                              restrictionIDList.remove(
                                                  searchEdgesRestrictionList[
                                                          index]
                                                      .node
                                                      .id);

                                              for (int i = 0;
                                                  i < listOptions.length;
                                                  i++) {
                                                if (listOptions[i].optionName ==
                                                    searchEdgesRestrictionList[
                                                            index]
                                                        .node
                                                        .name) {
                                                  listOptions.removeAt(i);
                                                }
                                              }
                                              setState(() {});
                                            } else {
                                              restrictionIDList.add(
                                                  searchEdgesRestrictionList[
                                                          index]
                                                      .node
                                                      .id);
                                              listOptions.add(CustomOptions(
                                                  optionColor: colorList[
                                                      index % colorList.length],
                                                  optionName:
                                                      searchEdgesRestrictionList[
                                                              index]
                                                          .node
                                                          .name));
                                            }
                                          });
                                        }

                                        int indexAt = getSurveyData!.options!
                                            .indexWhere((element) =>
                                                element.label?.toLowerCase() ==
                                                searchEdgesRestrictionList[
                                                        index]
                                                    .node
                                                    .name
                                                    .toLowerCase());

                                        bloc.add(
                                            CheckSurveyData(index: indexAt));

                                        print('=------->>>>>>>>$listOptions');
                                      },
                                    );
                                  },
                                ),
                              ),
                            )
                      : searchDietList.isEmpty
                          ? const Text('No Search Found!')
                          : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                crossAxisSpacing: 6.0,
                                mainAxisSpacing: 8.0,
                                children: List.generate(
                                  searchDietList.length,
                                  (index) {
                                    return Builder(builder: (context) {
                                      listOptions.forEach((element) {
                                        if (element.optionName
                                                .replaceAll(" Diet", "")
                                                .toLowerCase() ==
                                            searchDietList[index]
                                                .dietName
                                                ?.replaceAll(" Diet", "")
                                                .toLowerCase()) {
                                          searchDietList[index].select = true;
                                        } else {
                                          searchDietList[index].select = false;
                                        }
                                      });
                                      return UserSurveySearchItems(
                                        data: searchDietList[index],
                                        index: index,
                                        onTap: () {
                                          searchDietId =
                                              searchDietList[index].id!;

                                          if (searchDietList[index].select ==
                                              true) {
                                            searchDietList[index].select =
                                                false;
                                          } else {
                                            searchDietList[index].select = true;
                                          }

                                          ///new code
                                          if (searchDietList[index].select ==
                                              true) {
                                            listOptions.clear();
                                            int indexAt = getSurveyData!
                                                .options!
                                                .indexWhere((element) =>
                                                    element.label
                                                        ?.replaceAll(
                                                            " Diet", "")
                                                        .toLowerCase() ==
                                                    searchDietList[index]
                                                        .dietName
                                                        ?.replaceAll(
                                                            " Diet", "")
                                                        .toLowerCase());

                                            print(
                                                "DIET:-----> ${dietId}\n RESTRICTION ID:----->  ${getSurveyData!.options![indexAt].restrictionId!}");
                                            dietId = getSurveyData!
                                                .options![indexAt]
                                                .restrictionId!;
                                            /* int  indexAt =
                                              listOptions.indexWhere(
                                                      (element) =>
                                                  element.optionName
                                                      .replaceAll(
                                                      " Diet", "") ==
                                                      searchDietList[index]
                                                          .dietName
                                                          ?.replaceAll(
                                                          " Diet", ""));
                                             */

                                            bloc.add(CheckSurveyData(
                                                index: indexAt));

                                            listOptions.add(CustomOptions(
                                                optionColor: searchDietList[
                                                                index]
                                                            .colorCode !=
                                                        null
                                                    ? Color(int.parse(
                                                        "0xff${searchDietList[index].colorCode.toString().replaceFirst('#', "")}"))
                                                    : AppColors.primaryBlue,
                                                optionName:
                                                    searchDietList[index]
                                                            .dietName ??
                                                        ''));
                                          } else {
                                            int indexAt = listOptions
                                                .indexWhere((element) =>
                                                    element.optionName
                                                        .replaceAll(" Diet", "")
                                                        .toLowerCase() ==
                                                    searchDietList[index]
                                                        .dietName
                                                        ?.replaceAll(
                                                            " Diet", "")
                                                        .toLowerCase());

                                            indexAt >= 0
                                                ? listOptions.removeAt(indexAt)
                                                : null;
                                            bloc.add(CheckSurveyData(
                                                index: indexAt));
                                          }
                                        },
                                        // onTap: () {
                                        //   setState(() {
                                        //     searchEdgesRestrictionList![index]
                                        //             .node
                                        //             .isRestricted =
                                        //         !searchEdgesRestrictionList![index]
                                        //             .node
                                        //             .isRestricted;
                                        //     if (restrictionIDList.contains(
                                        //         searchEdgesRestrictionList![index]
                                        //             .node
                                        //             .id)) {
                                        //       restrictionIDList.remove(
                                        //           searchEdgesRestrictionList![index]
                                        //               .node
                                        //               .id);
                                        //       listOptions.removeWhere((element) =>
                                        //           element.optionName ==
                                        //           searchEdgesRestrictionList![index]
                                        //               .node
                                        //               .name);
                                        //     } else {
                                        //       restrictionIDList.add(
                                        //           searchEdgesRestrictionList![index]
                                        //               .node
                                        //               .id);
                                        //       listOptions.add(CustomOptions(
                                        //           optionColor: colorList[
                                        //               index % colorList.length],
                                        //           optionName:
                                        //               searchEdgesRestrictionList![
                                        //                       index]
                                        //                   .node
                                        //                   .name));
                                        //     }
                                        //   });
                                        // },
                                      );
                                    });
                                  },
                                ),
                              ),
                            )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        crossAxisSpacing: 6.0,
                        mainAxisSpacing: 8.0,
                        children: List.generate(
                          getSurveyData!.options!.length,
                          (index) {
                            return Builder(builder: (context) {
                              if (getSurveyData!.options![index].optionType ==
                                  "preferences") {
                                getSurveyData!.options![index].isSelect = false;

                                listOptions.forEach((element) {
                                  if (element.optionName
                                          .replaceAll(" Diet", "")
                                          .toLowerCase() ==
                                      getSurveyData!.options![index].label
                                          ?.replaceAll(" Diet", "")
                                          .toLowerCase()) {
                                    getSurveyData!.options![index].isSelect =
                                        true;
                                  } else {
                                    getSurveyData!.options![index].isSelect =
                                        false;
                                  }
                                });

                                if (dietId ==
                                    getSurveyData!
                                        .options![index].restrictionId!) {
                                  getSurveyData!.options![index].isSelect =
                                      true;
                                }
                              }
                              return UserSurveyItems(
                                data: getSurveyData!.options![index],
                                onClick: () {
                                  optionIndex = index;
                                  if (getSurveyData!
                                          .options![index].optionType ==
                                      "preferences") {
                                    if (listOptions.isEmpty) {
                                      getSurveyData!.options![index].isSelect =
                                          true;
                                      listOptions.add(CustomOptions(
                                          optionColor: getSurveyData!
                                                  .options![index].color ??
                                              AppColors.primaryBlue,
                                          optionName: getSurveyData!
                                                  .options![index].label ??
                                              ''));
                                      bloc.add(CheckSurveyData(index: index));
                                    } else {
                                      if (getSurveyData!
                                          .options![index].isSelect) {
                                        dietId = "";
                                        getSurveyData!
                                            .options![index].isSelect = false;
                                        listOptions.removeWhere((element) =>
                                            getSurveyData!
                                                .options![index].isSelect ==
                                            false);
                                      } else {
                                        dietId = getSurveyData!
                                            .options![index].restrictionId!;
                                        print(
                                            "DIET:-----> ${dietId}\nREID:-----> ${getSurveyData!.options![index].restrictionId!}");

                                        getSurveyData!
                                            .options![index].isSelect = true;

                                        listOptions.add(CustomOptions(
                                            optionColor: getSurveyData!
                                                    .options![index].color ??
                                                AppColors.primaryBlue,
                                            optionName: getSurveyData!
                                                    .options![index].label ??
                                                ''));
                                        bloc.add(CheckSurveyData(index: index));
                                      }
                                    }

                                    setState(() {});
                                  } else {
                                    if (getSurveyData!
                                        .options![index].isSelect) {
                                      listOptions.removeWhere((element) =>
                                          element.optionName ==
                                          getSurveyData!.options![index].label);
                                    } else {
                                      listOptions.add(CustomOptions(
                                          optionColor: getSurveyData!
                                                  .options![index].color ??
                                              AppColors.primaryBlue,
                                          optionName: getSurveyData!
                                                  .options![index].label ??
                                              ''));
                                    }

                                    /// ID
                                    bloc.add(CheckSurveyData(index: index));
                                    setState(() {
                                      if (getSurveyData!
                                              .options![index].restrictionId !=
                                          null) {
                                        if (restrictionIDList.contains(
                                            getSurveyData!.options![index]
                                                .restrictionId)) {
                                          restrictionIDList.remove(
                                              getSurveyData!.options![index]
                                                  .restrictionId);
                                        } else {
                                          restrictionIDList.add(getSurveyData!
                                              .options![index].restrictionId!);
                                        }
                                      }
                                    });

                                    log(dietId, name: "dietId");
                                    for (var d in restrictionIDList) {
                                      log(d, name: "restrictionIDList");
                                    }
                                    log('listOptions---------->>>>>> $listOptions');
                                  }
                                },
                              );
                            });
                          },
                        ),
                      ),
                    ),
            ),
            isSearchOn == true
                ? const SizedBox()
                : Visibility(
                    visible: !(MediaQuery.of(context).viewInsets.bottom != 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: buildBorderButton(
                                  context: context,
                                  onPressed: () {
                                    if (listIndex.isNotEmpty) {
                                      optionIndex =
                                          listIndex[listIndex.length - 1];
                                      listIndex.removeLast();
                                    }
                                    if (optionIndex == 0) {
                                      setState(() {
                                        isPreference = false;
                                      });
                                    }

                                    bloc.add(NextPrevSurveyClick(
                                        index: optionIndex, isNext: false));
                                  },
                                  textColor:
                                      setColor(gender: model.gender ?? ""),
                                  borderColor:
                                      setColor(gender: model.gender ?? ''),
                                  bgColor: Colors.white,
                                  title: StringUtils.previous)
                              .paddingOnly(top: 10.h),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: buildButton(
                                  context: context,
                                  onPressed: () {
                                    optionIndex = getSurveyData!.options!
                                        .indexWhere((value) => value.isSelect);
                                    listIndex.add(optionIndex);

                                    bloc.add(
                                      NextPrevSurveyClick(
                                        index: optionIndex,
                                        isNext: true,
                                      ),
                                    );

                                    if (isPreference == false) {
                                      setState(() {
                                        isPreference = true;
                                      });
                                    }
                                  },
                                  textColor: Colors.white,
                                  bgColor: setColor(gender: model.gender ?? ''),
                                  title: StringUtils.next)
                              .paddingOnly(top: 10.h),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      );
}

class CustomOptions {
  final String optionName;
  final Color optionColor;

  CustomOptions({required this.optionColor, required this.optionName});
}
