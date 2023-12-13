import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_bloc.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_event.dart';
import 'package:gymeats_mobile/bloc/journal/get_journal_data/get_user_journal_state.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/exercise_log_details_model.dart';
import 'package:gymeats_mobile/screen/dashboard/add_entry_screen.dart';
import 'package:gymeats_mobile/widget/app_center_loader.dart';

class HistoryExerciseScreen extends StatefulWidget {
  final DateTime? dateTime;

  const HistoryExerciseScreen({super.key, this.dateTime});

  @override
  State<HistoryExerciseScreen> createState() => _HistoryExerciseScreenState();
}

class _HistoryExerciseScreenState extends State<HistoryExerciseScreen> {
  GetUserJournalBloc journalPlanBloc = GetUserJournalBloc();
  List<ExerciseLogList> exerciseLogList = [];

  @override
  void initState() {
    super.initState();
    journalPlanBloc.add(GetExerciseDetails(date: widget.dateTime!.toString()));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<GetUserJournalBloc, GetUserJournalState>(
      bloc: journalPlanBloc,
      listener: (BuildContext context, GetUserJournalState state) {
        if (state is AllExerciseLogSuccessState) {
          exerciseLogList = state.data!.exerciseLogList!;
        }
      },
      builder: (BuildContext context, GetUserJournalState state) {
        return Column(
          children: [
            exerciseLogList.isEmpty
                ? state is AllExerciseLogLoadingState
                    ? const Expanded(child: AppCenterLoader())
                    : Center(
                        child: Text(
                          StringUtils.historyExercisesText,
                          style: textTheme.bodySmall?.copyWith(
                              color: AppColors.middleGray,
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp),
                        ).paddingOnly(top: 10.h, bottom: 10.h),
                      )
                : ListView.builder(
                    itemCount: exerciseLogList.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.toNamed("/AddEntryScreen",
                                  arguments: AddEntryArguments(
                                      exerciseLogList: exerciseLogList[index],
                                      isFromHistory: true));
                            },
                            child: ListTile(
                              title: Text(
                                  exerciseLogList[index].exerciseName ?? ''),
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
      },
    );
  }
}
