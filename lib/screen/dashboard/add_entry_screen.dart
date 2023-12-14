import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_bloc.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_event.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/exercise_log_details_model.dart';
import 'package:gymeats_mobile/models/get_all_exercise_modal.dart';
import 'package:gymeats_mobile/screen/journal/exercise/all_exercise_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

import '../../app/sharedPrefrence.dart';
import '../../bloc/dashboard/add_exercise/add_exercise_bloc.dart';
import '../../bloc/dashboard/add_exercise/add_exercise_event.dart';
import '../../bloc/dashboard/add_exercise/add_exercise_state.dart';
import '../../repository/get_exercise_details.dart';
import '../../widget/app_center_loader.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final routeName = '/AddEntryScreen';
  TextEditingController entryController = TextEditingController();
  TextEditingController minutesController = TextEditingController();
  TextEditingController caloriesTextBurnedController = TextEditingController();

  var addEntryArguments = Get.arguments;

  AddExerciseBloc bloc = AddExerciseBloc();
  GetUserJournalBloc journalPlanBloc = GetUserJournalBloc();

  bool isButtonEnable = false;

  @override
  void initState() {
    super.initState();
    if (addEntryArguments.isFromHistory) {
      log("IF exerciseId:---> ${(jsonEncode(addEntryArguments.exerciseLogList))}");

      entryController.text =
          addEntryArguments.exerciseLogList!.exerciseName == null
              ? ''
              : addEntryArguments.exerciseLogList!.exerciseName ?? '';
      minutesController.text =
          addEntryArguments.exerciseLogList!.workoutTime == null
              ? '1'
              : addEntryArguments.exerciseLogList!.workoutTime.toString();
      caloriesTextBurnedController.text =
          addEntryArguments.exerciseLogList!.caloriesBurned == null
              ? ''
              : addEntryArguments.exerciseLogList!.caloriesBurned.toString();
      print(
          ":--------------> ${addEntryArguments.exerciseLogList!.caloriesBurned.toString()}");
    } else {
      entryController.text =
          addEntryArguments.allExerciseData?.exerciseName == null
              ? ''
              : addEntryArguments.allExerciseData!.exerciseName ?? '';
      caloriesTextBurnedController.text =
          addEntryArguments.allExerciseData?.calorieBurnedPerMinute == null
              ? ''
              : addEntryArguments.allExerciseData!.calorieBurnedPerMinute
                  .toString();
      minutesController.text = '1';
    }
    setState(() {
      isButtonEnable = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height.h,
        width: size.width.w,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 25.sp,
                    color: AppColors.darkGray,
                  ),
                ),
                Text(
                  addEntryArguments.isFromHistory
                      ? 'Exercise'
                      : StringUtils.addEntry,
                  style: textTheme.displayMedium?.copyWith(color: Colors.black),
                ).paddingOnly(right: 28.w),
                const SizedBox(),
              ],
            ).paddingOnly(top: 30.h),
            dashBoardCardView(
              width: 335.w,
              margin: EdgeInsets.symmetric(vertical: 20.h),
              child: Column(
                children: [
                  commonUserTypeTextField(
                    hintText: 'Exercise name',
                    controller: entryController,
                    context: context,
                    width: double.infinity.w,
                    fontSize: 16.sp,
                    isReadOnly: true,
                    borderColor: AppColors.primaryBlue,
                    fontWeight: FontWeight.w400,
                    isSuffix: false,
                    valueColor: AppColors.darkGray,
                    fontColor: AppColors.darkGray,
                    cursorColor: AppColors.darkGray,
                    textInputType: TextInputType.text,
                    onChange: (value) {},
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'minutes',
                        style: textTheme.bodyLarge
                            ?.copyWith(color: AppColors.darkGray),
                      ),
                      commonUserTypeTextField(
                        hintText: '00',
                        controller: minutesController,
                        context: context,
                        width: 80.w,
                        fontSize: 16.sp,
                        borderColor: AppColors.primaryBlue,
                        fontWeight: FontWeight.w400,
                        isSuffix: false,
                        valueColor: AppColors.darkGray,
                        fontColor: AppColors.darkGray,
                        cursorColor: AppColors.darkGray,
                        textInputType: TextInputType.number,
                        onChange: (value) {
                          if (value.isNotEmpty) {
                            isButtonEnable = true;
                            if (addEntryArguments.isFromHistory) {
                              double perMin = addEntryArguments
                                      .exerciseLogList!.caloriesBurned! /
                                  addEntryArguments
                                      .exerciseLogList!.workoutTime!;
                              caloriesTextBurnedController.text =
                                  (int.parse(minutesController.text) * perMin)
                                      .toStringAsFixed(0);
                            } else {
                              caloriesTextBurnedController.text =
                                  (int.parse(minutesController.text) *
                                          addEntryArguments.allExerciseData!
                                              .calorieBurnedPerMinute)
                                      .toString();
                            }
                          } else {
                            isButtonEnable = false;
                            caloriesTextBurnedController.text = '0';
                          }
                          setState(() {});
                        },
                      ),
                    ],
                  ).paddingOnly(top: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Calories Burned',
                        style: textTheme.bodyLarge
                            ?.copyWith(color: AppColors.darkGray),
                      ),
                      commonUserTypeTextField(
                        hintText: '00cal',
                        isReadOnly: true,
                        controller: caloriesTextBurnedController,
                        context: context,
                        width: 80.w,
                        fontSize: 16.sp,
                        borderColor: AppColors.primaryBlue,
                        fontWeight: FontWeight.w400,
                        isSuffix: false,
                        valueColor: AppColors.darkGray,
                        fontColor: AppColors.darkGray,
                        cursorColor: AppColors.darkGray,
                        textInputType: TextInputType.number,
                        onChange: (value) {},
                      ),
                    ],
                  ).paddingOnly(top: 8.h),
                ],
              ).paddingAll(16),
            ),
            const Spacer(),
            BlocBuilder(
                bloc: bloc,
                builder: (context, state) {
                  debugPrint('water state--> $state');
                  if (state is DeleteLoadingSuccessState) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      Get.back();
                    });
                  }
                  if (state is LoadingState) {
                    return const AppCenterLoader();
                  } else {
                    return addEntryArguments.isFromHistory
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: state is DeleteLoadingState
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : simpleTextBorderButton(
                                        height: 48.h,
                                        context: context,
                                        buttonLable: 'Delete',
                                        onTap: () {
                                          bloc.add(DeleteExerciseEvent(
                                              exerciseName:
                                                  entryController.text));
                                        },
                                        isDarkColor: true,
                                      ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 1,
                                child: simpleTextBorderButton(
                                  height: 48.h,
                                  context: context,
                                  buttonLable: 'Update',
                                  onTap: () async {
                                    log('UPDATE');
                                    if (allExerciseList.isEmpty) {
                                      final GetExerciseDetailsRepository
                                          getExerciseDetailsRepository =
                                          GetExerciseDetailsRepository();

                                      await getExerciseDetailsRepository
                                          .getAllExerciseDetails()
                                          .fold((left) {}, (right) {
                                        allExerciseList = right.data;
                                      });
                                    }

                                    /*int index = allExerciseList.indexWhere(
                                      (element) =>
                                          element.exerciseName ==
                                          addEntryArguments
                                              .exerciseLogList?.exerciseName,
                                    );
                                    if (index >= 0) {}
                                    String exeId = allExerciseList[index].id;*/
                                    String exeId = addEntryArguments
                                        .exerciseLogList!.exerciseId!;
                                    print(":-----> ${exeId}");
                                    print(":-----> ${userId}");
                                    bloc.add(
                                      UpdateExerciseEvent(
                                        id: exeId,
                                        workOutTime:
                                            int.parse(minutesController.text),
                                        calorieBurned: int.parse(
                                            caloriesTextBurnedController.text),
                                        userId: userId,
                                        exerciseName: entryController.text,
                                      ),
                                    );
                                    journalPlanBloc.add(GetExerciseDetails(
                                        date: addEntryArguments.dateTime!
                                            .toString()));

                                    ///call exercise history api
                                  },
                                  isDarkColor: true,
                                  isFillColor: true,
                                ),
                              ),
                            ],
                          )
                        : buildButton(
                            context: context,
                            title: StringUtils.save,
                            hasImage: false,
                            textColor: AppColors.skyBlue,
                            onPressed: () {
                              if (minutesController.text == '0' ||
                                  minutesController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: 'Minutes can\'t be 0');
                              } else if (caloriesTextBurnedController.text ==
                                      '0' ||
                                  caloriesTextBurnedController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: 'Calories can\'t be 0');
                              } else {
                                FocusScope.of(context).unfocus();
                                bloc.add(SaveClickEvent(
                                    userId: userId,
                                    workoutTime: minutesController.text,
                                    exerciseName: entryController.text,
                                    caloriesBurned:
                                        caloriesTextBurnedController.text,
                                    createdBy: ''));
                              }
                            },
                            bgColor: isButtonEnable
                                ? AppColors.primaryBlue
                                : AppColors.gray,
                          ).paddingOnly(bottom: 20.h);
                  }
                }).paddingOnly(bottom: 20.h),
          ],
        ).paddingSymmetric(horizontal: 20.w),
      ),
    );
  }

  Widget waterDetailsView(
      {String? waterIcon,
      String? waterQuantity,
      double? height,
      void Function()? onTap}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          waterIcon.toString(),
          height: height,
          width: 48.w,
        ),
        Text(
          '$waterQuantity ml',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.darkGray),
        ).paddingOnly(top: 3.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 25.h,
            width: 25.w,
            margin: EdgeInsets.only(top: 5.h),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.skyBlue,
            ),
            child: const Center(
              child: Icon(
                Icons.add,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class AddEntryArguments {
  final ExerciseLogList? exerciseLogList;
  final GetAllExerciseData? allExerciseData;
  final String? dateTime;
  final bool isFromHistory;

  AddEntryArguments(
      {this.exerciseLogList,
      this.allExerciseData,
      this.dateTime,
      this.isFromHistory = false});
}
