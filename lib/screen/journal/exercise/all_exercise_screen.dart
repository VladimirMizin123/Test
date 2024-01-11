import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_bloc.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_event.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_state.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/get_all_exercise_modal.dart';
import 'package:gymeats_mobile/screen/dashboard/add_entry_screen.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';

List<GetAllExerciseData> allExerciseList = [];

class AllExerciseScreen extends StatefulWidget {
  final DateTime? dateTime;

  const AllExerciseScreen({super.key, this.dateTime});

  @override
  State<AllExerciseScreen> createState() => _AllExerciseScreenState();
}

class _AllExerciseScreenState extends State<AllExerciseScreen> {
  GetUserJournalBloc journalPlanBloc = GetUserJournalBloc();

  @override
  void initState() {
    super.initState();
    journalPlanBloc.add(GetAllExerciseDetails());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocConsumer<GetUserJournalBloc, GetUserJournalState>(
        bloc: journalPlanBloc,
        listener: (BuildContext context, GetUserJournalState state) {
          if (state is AllExerciseSuccessState) {
            allExerciseList = state.data;
          }
        },
        builder: (BuildContext context, GetUserJournalState state) {
          return Column(
            children: [
              allExerciseList.isEmpty
                  ? state is AllExerciseLoadingState
                      ? const Expanded(child: AppCenterLoader())
                      : Center(
                          child: Text(
                            StringUtils.noExercise,
                            style: textTheme.bodySmall?.copyWith(
                                color: AppColors.middleGray,
                                fontWeight: FontWeight.w400,
                                fontSize: 13.sp),
                          ).paddingOnly(top: 10.h, bottom: 10.h),
                        )
                  : ListView.builder(
                      itemCount: allExerciseList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.toNamed("/AddEntryScreen",
                                    arguments: AddEntryArguments(
                                        allExerciseData: allExerciseList[index],
                                        isFromHistory: false));
                              },
                              child: ListTile(
                                title: Text(
                                  allExerciseList[index].exerciseName,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15.h,
                                  color: const Color(0xFF010101),
                                ),
                              ),
                            ),
                            Divider(height: 2.h, color: AppColors.disable),
                          ],
                        );
                      },
                    ),
            ],
          );
        });
  }
}
