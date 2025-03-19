import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_bloc.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/exercise_log_details_model.dart';
import 'package:gymeats_mobile/models/get_all_exercise_modal.dart';
import 'package:gymeats_mobile/screen/journal/exercise/all_exercise_screen.dart';
import 'package:gymeats_mobile/screen/journal/exercise/history_exercise_screen.dart';
import 'package:gymeats_mobile/widget/custom_header.dart';

import '../../../widget/app_widget.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({Key? key}) : super(key: key);

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen>
    with SingleTickerProviderStateMixin {
  final routeName = '/AddExerciseScreen';
  final searchExerciseController = TextEditingController();
  late TabController tabController;
  // List<String> allExerciseList = [
  //   StringUtils.running,
  //   StringUtils.runningFast,
  //   StringUtils.workout,
  //   StringUtils.runningSlow,
  // ];
  List<GetAllExerciseData> filteredExerciseList = [];
  List<ExerciseLogList> filteredExerciseLogList = [];
  AddExerciseArguments addExerciseArguments = Get.arguments;
  GetUserJournalBloc getUserJournalBloc = GetUserJournalBloc();

  @override
  void initState() {
    super.initState();
    filteredExerciseList = allExerciseList;
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SizedBox(
            height: size.height.h,
            width: size.width.w,
            child: Column(
              children: [
                const CustomTopHeader(title: StringUtils.addExercise),
                commonSearchTextField(
                  fontColor: AppColors.middleGray,
                  controller: searchExerciseController,
                  fontSize: 15.sp,
                  hintText: StringUtils.searchExercise,
                  textInputType: TextInputType.text,
                  context: context,
                  onChange: (value) {
                    filterSearchExercises(value);
                  },
                  onClear: () {
                    searchExerciseController.clear();
                    filterSearchExercises('');
                    filteredExerciseLogList.clear();
                  },
                ).paddingSymmetric(horizontal: 20.w, vertical: 15.h),
                SizedBox(
                  child: TabBar(
                    controller: tabController,
                    labelColor: AppColors.primaryBlue,
                    indicatorColor: AppColors.primaryBlue,
                    unselectedLabelColor: AppColors.gray,
                    labelStyle: textTheme.headlineSmall
                        ?.copyWith(color: AppColors.primaryBlue),
                    tabs: const [
                      Tab(text: StringUtils.history),
                      Tab(text: StringUtils.allExercises),
                    ],
                  ),
                ).paddingSymmetric(horizontal: 20.w),
                Expanded(
                  child: SizedBox(
                    width: double.maxFinite,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        HistoryExerciseScreen(
                          filterExerciseLogList: filteredExerciseLogList,
                          dateTime: addExerciseArguments.dateTime,
                          searchController: searchExerciseController,
                        ),
                        AllExerciseScreen(
                          dateTime: addExerciseArguments.dateTime,
                          filteredExerciseList: filteredExerciseList,
                          searchController: searchExerciseController,
                        ),
                      ],
                    ),
                  ).paddingOnly(left: 20.w, right: 10.w),
                ),
              ],
            ),
          ),
        ));
  }

  void filterSearchExercises(String query) {
    if (tabController.index == 0) {
      if (query.isEmpty) {
        filteredExerciseLogList.clear();
      } else {
        filteredExerciseLogList = exerciseLogList
            .where((exercise) => exercise.exerciseName!
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
        filteredExerciseLogList.sort(
          (a, b) => a.exerciseName!.compareTo(b.exerciseName!),
        );
      }
    } else {
      if (query.isEmpty) {
        filteredExerciseList = allExerciseList;
      } else {
        filteredExerciseList = allExerciseList
            .where((exercise) => exercise.exerciseName
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
        filteredExerciseList.sort(
          (a, b) => a.exerciseName.compareTo(b.exerciseName),
        );
      }
    }
    setState(() {});
  }
}

class AddExerciseArguments {
  final DateTime? dateTime;

  AddExerciseArguments({required this.dateTime});
}
