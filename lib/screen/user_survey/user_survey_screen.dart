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
import 'package:gymeats_mobile/extention/ext_on_list.dart';
import 'package:gymeats_mobile/repository/get_account_details.dart';
import 'package:gymeats_mobile/repository/sign_up.dart';
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
  int pageIndex = 0;
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
  String restrictionName = "";
  bool noneSelected = false;

  List<DataOption> sOptions = [];

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
    searchEdgesRestrictionList.sort((a, b) =>
        a.node.name.toLowerCase().compareTo(b.node.name.toLowerCase()));

    return WillPopScope(
      onWillPop: () {
        if (widget.isProfile == true) {
          Navigator.of(context).pop();

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

                bool isSelected = getSurveyData?.options
                        ?.any((element) => element.isSelect) ??
                    false;
                if (!isSelected) {
                  int index = getSurveyData?.options
                          ?.indexWhere((element) => element.label == "None") ??
                      -1;
                  if (!index.isNegative) {
                    getSurveyData?.options?[index].isSelect = true;
                    noneSelected = true;
                  }
                }
                noneSelected = getSurveyData?.options?.any((element) =>
                        element.isSelect && element.label == "None") ??
                    false;

                setState(() {});
                if (isListen == true) {
                  listOptions.add(
                    CustomOptions(
                      optionColor: getSurveyData!.options![0].color ??
                          AppColors.primaryBlue,
                      optionName: getSurveyData!.options![0].label ?? '',
                    ),
                  );
                  dietId = getSurveyData?.options?[0].restrictionId ?? '';
                  log(dietId);
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
                  userId: model.userId,
                  surveyReq: getSurveyReq(),
                );

                if (widget.isProfile == true) {
                  AccountRepository().updateDietProgram(
                      req: userSignUpDataModel.surveyReq ?? {});
                  SignUpRepository().addUserRestriction(
                    userid: PreferenceUtils.getString(prefUserData),
                    restrictionList: restrictionIDList,
                  );
                  Future.delayed(const Duration(seconds: 2), () {
                    Get.back();
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
                  Navigator.of(context).pop();
                  // Get.off(() => const ProgramScreen());
                } else {
                  Get.toNamed('/UserTypeScreen', arguments: model);
                }
              }

              if (state is GetAllRestrictionSuccessState) {
                edgesRestrictionList = state.edgesRestrictionList ?? [];

                searchEdgesRestrictionList = edgesRestrictionList
                    .where((item) => item.node.name
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()))
                    .toList();

                for (var ele in searchEdgesRestrictionList) {
                  if (restrictionIDList.contains(ele.node.id)) {
                    ele.node.isRestricted = true;
                  } else {
                    ele.node.isRestricted = false;
                  }
                }
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
                        Navigator.of(context).pop();
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
                          userId: model.userId,
                          surveyReq: getSurveyReq(),
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
              fontColor: Colors.grey,
              controller: searchController,
              fontSize: 13,
              hintText: switch (pageIndex) {
                0 => "Diet",
                1 => "Allergies",
                2 => "Health conditions",
                _ => "Medications",
              },
              textInputType: TextInputType.text,
              context: context,
              isDense: true,
              onChange: (String? value) {
                setState(() {});

                // ! Search Code

                if (value!.isNotEmpty) {
                  isSearchOn = true;
                  if (isPreference == true) {
                    searchEdgesRestrictionList = edgesRestrictionList
                        .where((item) => item.node.name
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()))
                        .toList();

                    for (var ele in searchEdgesRestrictionList) {
                      if (restrictionIDList.contains(ele.node.id)) {
                        ele.node.isRestricted = true;
                      } else {
                        ele.node.isRestricted = false;
                      }
                    }
                  } else {
                    log("SINGLE SEARCH");
                    for (var element in dietList) {
                      log(element.dietName ?? '', name: "DIET NAME");
                    }
                    searchDietList = dietList
                        .where((item) => item.dietName
                            .toString()
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  }
                } else {
                  isSearchOn = false;
                  searchEdgesRestrictionList = edgesRestrictionList
                      .where((item) => item.node.name
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase()))
                      .toList();

                  for (var ele in searchEdgesRestrictionList) {
                    if (restrictionIDList.contains(ele.node.id)) {
                      ele.node.isRestricted = true;
                    } else {
                      ele.node.isRestricted = false;
                    }
                  }
                }
              },
              onClear: () {
                for (var data in searchDietList) {
                  data.select = false;
                }
                // for (var data in searchEdgesRestrictionList) {
                //   data.node.isRestricted = false;
                // }

                setState(() {
                  searchController.clear();
                  isSearchOn = false;
                  FocusScope.of(context).unfocus();
                  searchEdgesRestrictionList = edgesRestrictionList
                      .where((item) => item.node.name
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase()))
                      .toList();

                  for (var ele in searchEdgesRestrictionList) {
                    if (restrictionIDList.contains(ele.node.id)) {
                      ele.node.isRestricted = true;
                    } else {
                      ele.node.isRestricted = false;
                    }
                  }
                });
              },
            ),
            Expanded(
              child: Builder(
                builder: (_) {
                  sOptions = getSurveyData?.options
                          ?.where((element) =>
                              element.label?.toLowerCase().contains(
                                    searchController.text.toLowerCase(),
                                  ) ??
                              false)
                          .toList() ??
                      [];
                  sOptions.sort((a, b) {
                    if (a.label == "None") return -1;
                    if (b.label == "None") return 1;
                    return (a.label?.toLowerCase() ?? "")
                        .compareTo((b.label?.toLowerCase() ?? ""));
                  });

                  for (var element in sOptions) {
                    if (element.label == "None") {
                      element.isSelect = noneSelected;
                    } else {
                      element.isSelect = listOptions.firstWhereOrNull(
                              (e) => e.optionName == element.label) !=
                          null;
                    }
                  }

                  return sOptions.isEmpty && searchEdgesRestrictionList.isEmpty
                      ? const Text(
                          'No Data Found!',
                          style: TextStyle(color: Colors.black),
                        ).paddingOnly(top: 30.h)
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              ListView(
                                padding: const EdgeInsets.only(top: 20),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: List<Widget>.generate(
                                  sOptions.length,
                                  (index) {
                                    return Builder(builder: (context) {
                                      if (sOptions[index].optionType ==
                                          "preferences") {
                                        sOptions[index].isSelect = false;

                                        for (var element in listOptions) {
                                          if (sOptions[index].label != "None") {
                                            if (element.optionName
                                                    .replaceAll("Diet", "")
                                                    .trim()
                                                    .toLowerCase() ==
                                                sOptions[index]
                                                    .label
                                                    ?.replaceAll("Diet", "")
                                                    .trim()
                                                    .toLowerCase()) {
                                              sOptions[index].isSelect = true;
                                            } else {
                                              sOptions[index].isSelect = false;
                                            }
                                          } else {}
                                        }

                                        if (dietId != '' &&
                                            dietId ==
                                                sOptions[index]
                                                    .restrictionId!) {
                                          sOptions[index].isSelect = true;
                                        }
                                      }
                                      return UserSurveyItems(
                                        data: sOptions[index],
                                        onClick: () {
                                          if (noneSelected == true &&
                                              (sOptions[index].label ?? '') !=
                                                  "None") {
                                            // int i = sOptions.indexWhere(
                                            //     (element) =>
                                            //         element.label == "None");
                                            int i = getSurveyData?.options
                                                    ?.indexWhere((element) =>
                                                        element.label ==
                                                        "None") ??
                                                -1;
                                            if (i.isNegative) {
                                              return null;
                                            }
                                            getSurveyData
                                                ?.options?[i].isSelect = false;
                                            noneSelected = false;
                                          }

                                          if ((sOptions[index].label ?? '') ==
                                              "None") {
                                            sOptions[index].isSelect =
                                                !sOptions[index].isSelect;

                                            for (var element
                                                in searchEdgesRestrictionList) {
                                              element.node.isRestricted = false;
                                              restrictionIDList.removeWhere(
                                                  (el) =>
                                                      element.node.id == el);
                                            }

                                            noneSelected =
                                                sOptions[index].isSelect;

                                            for (int i = 0;
                                                i < sOptions.length;
                                                i++) {
                                              if (i != 0) {
                                                sOptions[i].isSelect = false;
                                              }
                                            }

                                            for (int surveyIndex = 0;
                                                surveyIndex <
                                                    (getSurveyData
                                                            ?.options?.length ??
                                                        0);
                                                surveyIndex++) {
                                              for (int indexL = 0;
                                                  indexL < listOptions.length;
                                                  indexL++) {
                                                if (listOptions[indexL]
                                                        .optionName ==
                                                    getSurveyData
                                                        ?.options?[surveyIndex]
                                                        .label) {
                                                  listOptions.removeAt(indexL);
                                                }
                                              }
                                            }

                                            for (int i = 0;
                                                i < sOptions.length;
                                                i++) {
                                              for (int ind = 0;
                                                  ind <
                                                      restrictionIDList.length;
                                                  ind++) {
                                                if (sOptions[i].restrictionId ==
                                                    restrictionIDList[ind]) {
                                                  restrictionIDList
                                                      .removeAt(ind);
                                                }
                                              }
                                            }

                                            setState(() {});
                                          } else {
                                            noneSelected = false;
                                            restrictionName = '';

                                            optionIndex = index;
                                            if (sOptions[index].optionType ==
                                                "preferences") {
                                              if (listOptions.isEmpty) {
                                                sOptions[index].isSelect = true;
                                                listOptions.add(CustomOptions(
                                                    optionColor: sOptions[index]
                                                            .color ??
                                                        AppColors.primaryBlue,
                                                    optionName:
                                                        sOptions[index].label ??
                                                            ''));
                                                bloc.add(CheckSurveyData(
                                                    index: index));
                                              } else {
                                                if (sOptions[index].isSelect) {
                                                  dietId = "";
                                                  sOptions[index].isSelect =
                                                      false;
                                                  setState(() {});
                                                  listOptions.removeWhere(
                                                      (element) =>
                                                          sOptions[index]
                                                              .label ==
                                                          element.optionName);
                                                } else {
                                                  dietId = sOptions[index]
                                                      .restrictionId!;

                                                  getSurveyData!.options![index]
                                                      .isSelect = true;

                                                  for (var element
                                                      in getSurveyData
                                                              ?.options ??
                                                          []) {
                                                    for (int loIndex = 0;
                                                        loIndex <
                                                            listOptions.length;
                                                        loIndex++) {
                                                      if (element.label ==
                                                          listOptions[loIndex]
                                                              .optionName) {
                                                        listOptions
                                                            .removeAt(loIndex);
                                                      }
                                                    }
                                                  }

                                                  listOptions.add(CustomOptions(
                                                      optionColor:
                                                          sOptions[index]
                                                                  .color ??
                                                              AppColors
                                                                  .primaryBlue,
                                                      optionName:
                                                          sOptions[index]
                                                                  .label ??
                                                              ''));

                                                  bloc.add(CheckSurveyData(
                                                      index: index));
                                                }
                                              }

                                              setState(() {});
                                            } else {
                                              if (sOptions[index].isSelect) {
                                                listOptions.removeWhere(
                                                    (element) =>
                                                        element.optionName ==
                                                        sOptions[index].label);
                                              } else {
                                                listOptions.add(CustomOptions(
                                                    optionColor: sOptions[index]
                                                            .color ??
                                                        AppColors.primaryBlue,
                                                    optionName:
                                                        sOptions[index].label ??
                                                            ''));
                                              }

                                              /// ID
                                              int sIndex = getSurveyData
                                                      ?.options
                                                      ?.indexWhere((element) =>
                                                          sOptions[index].id ==
                                                          element.id) ??
                                                  -1;

                                              bloc.add(CheckSurveyData(
                                                  index: sIndex));
                                              setState(() {
                                                if (sOptions[index]
                                                        .restrictionId !=
                                                    null) {
                                                  if (restrictionIDList
                                                      .contains(sOptions[index]
                                                          .restrictionId)) {
                                                    restrictionIDList.remove(
                                                        sOptions[index]
                                                            .restrictionId);
                                                  } else {
                                                    restrictionIDList.add(
                                                        sOptions[index]
                                                            .restrictionId!);
                                                    log("Restriction Call $restrictionIDList");
                                                  }
                                                }
                                              });
                                            }
                                          }
                                        },
                                      );
                                    });
                                  },
                                ).addBetweenItems(const SizedBox(height: 5.0)),
                              ),
                              // ! Extra Data
                              if (pageIndex == 1) ...[
                                const SizedBox(height: 8),
                                Builder(builder: (_) {
                                  searchEdgesRestrictionList.sort((a, b) => a
                                      .node.name
                                      .toLowerCase()
                                      .compareTo(b.node.name.toLowerCase()));
                                  return ListView(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: List.generate(
                                      searchEdgesRestrictionList.length,
                                      (index) {
                                        return UserSurveyPreferenceSearchItems(
                                          data:
                                              searchEdgesRestrictionList[index],
                                          index: index,
                                          onTap: () {
                                            if (noneSelected) {
                                              int i = getSurveyData?.options
                                                      ?.indexWhere((element) =>
                                                          element.label ==
                                                          "None") ??
                                                  -1;
                                              if (i.isNegative) {
                                                return;
                                              }
                                              getSurveyData?.options?[i]
                                                  .isSelect = false;
                                              noneSelected = false;
                                            }
                                            if (isPreference == false) {
                                              for (var element
                                                  in searchDietList) {
                                                element.select = false;
                                              }

                                              searchDietList[index].select =
                                                  !searchDietList[index].select;

                                              bloc.add(CheckSurveyData(
                                                  index: index));

                                              searchDietId =
                                                  searchDietList[index].id!;
                                              setState(() {});
                                            } else {
                                              setState(() {
                                                searchEdgesRestrictionList[
                                                            index]
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
                                                    if (listOptions[i]
                                                            .optionName ==
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
                                                          index %
                                                              colorList.length],
                                                      optionName:
                                                          searchEdgesRestrictionList[
                                                                  index]
                                                              .node
                                                              .name));
                                                }
                                              });
                                            }

                                            int indexAt = getSurveyData!
                                                .options!
                                                .indexWhere((element) =>
                                                    element.label
                                                        ?.toLowerCase() ==
                                                    searchEdgesRestrictionList[
                                                            index]
                                                        .node
                                                        .name
                                                        .toLowerCase());

                                            bloc.add(CheckSurveyData(
                                                index: indexAt));
                                          },
                                        );
                                      },
                                    ),
                                  );
                                }),
                              ],
                            ],
                          ),
                        );
                },
              ),
            ),
            Visibility(
              visible: !(MediaQuery.of(context).viewInsets.bottom != 0),
              child: Row(
                children: [
                  Expanded(
                    child: buildBorderButton(
                            context: context,
                            onPressed: () {
                              // if (listIndex.isNotEmpty) {
                              //   optionIndex = listIndex[listIndex.length - 1];
                              //   listIndex.removeLast();
                              // }

                              // if (pageIndex >= 1) {
                              //   pageIndex = pageIndex - 1;
                              // }
                              // bloc.add(NextPrevSurveyClick(
                              //     index: optionIndex, isNext: false));
                              resetSearchField();
                              if (listIndex.isNotEmpty) {
                                optionIndex = listIndex[listIndex.length - 1];
                                listIndex.removeLast();
                              }

                              if (pageIndex >= 1) {
                                pageIndex = pageIndex - 1;
                              }
                              if (optionIndex == 0) {
                                setState(() {
                                  isPreference = false;
                                });
                              }

                              ///make isPreference == true when it comes to first index
                              if (pageIndex == 0) {
                                setState(() {
                                  isPreference = false;
                                });
                              }
                              bloc.add(NextPrevSurveyClick(
                                  index: optionIndex,
                                  isNext: false,
                                  pageIndex: pageIndex - 1));
                            },
                            textColor: setColor(gender: model.gender ?? ""),
                            borderColor: setColor(gender: model.gender ?? ''),
                            bgColor: Colors.white,
                            title: StringUtils.previous)
                        .paddingOnly(top: 10.h),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: buildButton(
                            context: context,
                            onPressed: () {
                              resetSearchField();
                              getSurveyReq();
                              optionIndex = getSurveyData!.options!
                                  .indexWhere((value) => value.isSelect);
                              listIndex.add(optionIndex);
                              bool isSurveySelected = getSurveyData?.options
                                      ?.any((element) => element.isSelect) ??
                                  false;

                              bool isRestricted = searchEdgesRestrictionList
                                  .any((element) => element.node.isRestricted);

                              bloc.add(
                                NextPrevSurveyClick(
                                  index: optionIndex,
                                  isNext: true,
                                  searchEdgesRestrictionList:
                                      searchEdgesRestrictionList,
                                  pageIndex: pageIndex,
                                ),
                              );

                              if ((isSurveySelected ||
                                      (isRestricted && pageIndex == 1)) &&
                                  pageIndex < 3) {
                                pageIndex = pageIndex + 1;
                              }

                              if (isPreference == false) {
                                isPreference = true;
                              }
                              noneSelected = false;
                              setState(() {});
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

  Map<String, dynamic> getSurveyReq() {
    Map<String, dynamic> req = {
      "userId": model.userId ?? userId,
      "programId": "",
      "dietId": dietId,
      "surveyDetails": {},
    };

    for (int i = 0; i < bloc.listSurveyData.length; i++) {
      SurveyDataQuestion selOptions = bloc.listSurveyData[i];
      String label = selOptions.label ?? "";
      String optType = label.contains("diet")
          ? "diet"
          : label.contains("allergies")
              ? "allergy"
              : label.contains("health")
                  ? "health"
                  : "medication";

      req["surveyDetails"].addAll(
        {
          optType: {
            "id": selOptions.id,
            "label": label,
            "options": [
              ...(selOptions.options
                      ?.where((element) => element.isSelect)
                      .map((e) => e.label)
                      .toList() ??
                  []),
              ...(optType == "allergy"
                  ? edgesRestrictionList
                      .where((element) => element.node.isRestricted)
                      .map((e) => e.node.name)
                      .toList()
                  : [])
            ],
          }
        },
      );
    }
    return req;
  }

  void resetSearchField() {
    isSearchOn = false;
    searchController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

class CustomOptions {
  final String optionName;
  final Color optionColor;

  CustomOptions({required this.optionColor, required this.optionName});
}
