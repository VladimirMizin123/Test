import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/user_survey/user_survey_bloc.dart';
import 'package:gymeats_mobile/bloc/user_survey/user_survey_event.dart';
import 'package:gymeats_mobile/bloc/user_survey/user_survey_state.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_list.dart';
import 'package:gymeats_mobile/extention/ext_on_number.dart';
import 'package:gymeats_mobile/models/get_survey_model.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_bloc.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_event.dart';
import 'package:gymeats_mobile/screen/account_screen/bloc/account_state.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/get_all_diet_model.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/svg_image.dart';
import 'package:gymeats_mobile/widget/user_survey_item.dart';

class EditDietScreen extends StatefulWidget {
  const EditDietScreen({super.key});

  @override
  State<EditDietScreen> createState() => _EditDietScreenState();
}

class _EditDietScreenState extends State<EditDietScreen> {
  UserSurveyBloc bloc = UserSurveyBloc();
  AccountBloc account = AccountBloc();
  final searchController = TextEditingController();
  List<DietDetails> dietList = [];
  bool isSearchOn = false;
  String? selectedDietId;
  bool isLoading = false;
  bool currentProgramLoader = false;
  String? myProgram;
  bool btnLoader = false;

  @override
  void initState() {
    super.initState();
    account.add(GetCurrentProgramEvent());
    bloc.add(GetDietPlanEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer(
          bloc: account,
          builder: (_, __) {
            return BlocConsumer<UserSurveyBloc, UserSurveyState>(
              bloc: bloc,
              builder: (context, state) {
                if (isLoading || currentProgramLoader) {
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
                    ),
                  );
                }
                return initView();
              },
              listener: (context, state) {
                if (state is UpdateDietLoading) {
                  btnLoader = state.isLoading;
                  setState(() {});
                  return;
                }
                isLoading = state is GetDietPlanLoadingState;
                if (state is GetDietPlanSuccessState) {
                  dietList = state.edgesRestrictionList ?? [];
                  dietList.sort(
                    (a, b) => (a.dietName ?? "").compareTo(b.dietName ?? ""),
                  );
                }
                setState(() {});
              },
            );
          },
          listener: (_, state) {
            if (state is GetCurrentProgramLoadingState) {
              currentProgramLoader = true;
            }
            if (state is GetCurrentProgramSuccessState) {
              myProgram = state.myProgram.programName ?? "";
              currentProgramLoader = false;
              setState(() {});
            }
          },
        ),
      ),
    );
  }

  Widget initView() => Container(
        padding: EdgeInsets.fromLTRB(20.h, 10.h, 20.h, 10.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const SvgImage(
                      image: AssetsUtils.icBack,
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Image.asset(
                AssetsUtils.gymEatsLogo,
                fit: BoxFit.cover,
                color: AppColors.primaryBlue,
                height: 30.h,
              ),
            ),
            SizedBox(height: 20.h),
            commonSearchTextField(
              fontColor: Colors.grey,
              controller: searchController,
              fontSize: 13,
              hintText: "Diet",
              textInputType: TextInputType.text,
              context: context,
              isDense: true,
              onChange: (String? value) {
                setState(() {});
              },
              onClear: () {
                setState(() {});
              },
            ),
            Expanded(
              child: Builder(
                builder: (_) {
                  return Builder(
                    builder: (_) {
                      List<DietDetails> filterDiet = dietList
                          .where(
                            (element) => (element.dietName?.toLowerCase() ?? "")
                                .contains(searchController.text.toLowerCase()),
                          )
                          .toList();

                      return filterDiet.isEmpty
                          ? Center(
                              child: const Text(
                                'No Data Found!',
                                style: TextStyle(color: Colors.black),
                              ).paddingOnly(top: 30.h),
                            )
                          : ListView(
                              padding: const EdgeInsets.only(top: 10),
                              shrinkWrap: true,
                              children: List<Widget>.generate(
                                filterDiet.length,
                                (index) {
                                  return UserSurveyItems(
                                    scale: 1.2,
                                    data: DataOption(
                                      label: filterDiet[index].dietName,
                                      isSelect: selectedDietId == null
                                          ? filterDiet[index].dietName ==
                                              myProgram
                                          : filterDiet[index].id ==
                                              selectedDietId,
                                    ),
                                    onClick: () {
                                      selectedDietId = filterDiet[index].id;
                                      setState(() {});
                                    },
                                  );
                                },
                              ).addBetweenItems(const SizedBox(height: 5.0)),
                            );
                    },
                  );
                },
              ),
            ),
            Visibility(
              visible: !(MediaQuery.of(context).viewInsets.bottom != 0),
              child: Row(
                children: [
                  Expanded(
                    child: btnLoader
                        ? const AppCenterLoader()
                        : buildButton(
                            context: context,
                            onPressed: () async {
                              if (selectedDietId != null || myProgram != null) {
                                dynamic result =
                                    await showAlertDialog(context: context);
                                if (result == true) {
                                  selectedDietId ??= dietList
                                      .firstWhereOrNull((element) =>
                                          element.dietName == myProgram)
                                      ?.id;
                                  bloc.add(EditDietPlanEvent(
                                      dietId: selectedDietId!));
                                }
                              }
                            },
                            textColor: Colors.white,
                            bgColor: AppColors.primaryBlue,
                            title: StringUtils.save,
                          ).paddingOnly(top: 10.h),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Future<dynamic> showAlertDialog({
    required BuildContext context,
  }) async {
    try {
      return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
            StringUtils.changeDietTitle,
            style: const TextStyle(
              color: AppColors.black,
              fontFamily: "Avenir",
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 15, 24, 15),
          actions: [
            ElevatedButton(
              child: const Text(
                StringUtils.cancel,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Avenir",
                  fontSize: 16,
                ),
              ),
              onPressed: () => Get.back(result: false),
            ),
            ElevatedButton(
              child: Text(
                StringUtils.continueTxt,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "Avenir",
                  fontSize: 16,
                ),
              ),
              onPressed: () => Get.back(result: true),
            ),
            5.width,
          ],
        ),
      );
    } catch (e) {
      log(e.toString());
    }
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
