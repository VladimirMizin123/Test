import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_bloc.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/screen/journal/exercise/all_exercise_screen.dart';
import 'package:gymeats_mobile/screen/journal/exercise/history_exercise_screen.dart';

import '../../../widget/app_widget.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({Key? key}) : super(key: key);

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> with SingleTickerProviderStateMixin {
  final routeName = '/AddExerciseScreen';
  final searchExerciseController = TextEditingController();
  late TabController tabController;
  List<String> allExerciseList = [
    StringUtils.running,
    StringUtils.runningFast,
    StringUtils.workout,
    StringUtils.runningSlow,
  ];
  List<String> filteredExerciseList = [];
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.darkGray,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            StringUtils.addExercise,
            style: textTheme.displayMedium?.copyWith(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SizedBox(
            height: size.height.h,
            width: size.width.w,
            child: Column(
              children: [
                commonSearchTextField(
                  fontColor: AppColors.middleGray,
                  controller: searchExerciseController,
                  fontSize: 15.sp,
                  hintText: StringUtils.searchExercise,
                  textInputType: TextInputType.text,
                  context: context,
                  onChange: filterExercises,
                  onClear: () {
                    searchExerciseController.clear();
                    filterExercises('');
                  },
                ).paddingSymmetric(horizontal: 20.w, vertical: 15.h),
                SizedBox(
                  child: TabBar(
                    controller: tabController,
                    labelColor: AppColors.primaryBlue,
                    indicatorColor: AppColors.primaryBlue,
                    unselectedLabelColor: AppColors.gray,
                    labelStyle: textTheme.headlineSmall?.copyWith(color: AppColors.primaryBlue),
                    tabs: const [
                      Tab(text: StringUtils.history),
                      Tab(text: StringUtils.allExercises),
                    ],
                  ),
                ).paddingSymmetric(horizontal: 20.w),
                Expanded(
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 150,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        HistoryExerciseScreen(dateTime: addExerciseArguments.dateTime),
                        AllExerciseScreen(dateTime: addExerciseArguments.dateTime),
                      ],
                    ),
                  ).paddingOnly(left: 20.w, right: 10.w),
                ),
              ],
            ),
          ),
        ));
  }

  void filterExercises(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredExerciseList = allExerciseList;
      } else {
        filteredExerciseList = allExerciseList.where((exercise) => exercise.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }
}

class AddExerciseArguments {
  final DateTime? dateTime;

  AddExerciseArguments({required this.dateTime});
}
