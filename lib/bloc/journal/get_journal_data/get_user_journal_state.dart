import 'package:gymeats_mobile/models/daily_recap_modal.dart';

import '../../../models/exercise_log_details_model.dart';
import '../../../models/fetch_meal_plan_model.dart';
import '../../../models/get_dashboard_model.dart';
import '../../../models/get_meal_tracker_data_model.dart';
import '../../../models/water_log_details_model.dart';

abstract class GetUserJournalState {}

class InitialState extends GetUserJournalState {}

class LoadUserJournalData extends GetUserJournalState {
  GetDashboardModel model;
  LoadUserJournalData({required this.model});
}

class LoadGenMealData extends GetUserJournalState {
  List<MealData> genMealDataList;
  LoadGenMealData({required this.genMealDataList});
}

class LoadMealTrackData extends GetUserJournalState {
  List<TrackerData> mealTrackDataList;
  LoadMealTrackData({required this.mealTrackDataList});
}

class AllExerciseLoadingState extends GetUserJournalState {}

class AllExerciseSuccessState extends GetUserJournalState {
  ExerciseData? data;
  AllExerciseSuccessState({required this.data});
}

class LoadWaterData extends GetUserJournalState {
  WaterData data;
  LoadWaterData({required this.data});
}

class ErrorJournalState extends GetUserJournalState {
  // String errMessage;
  // ErrorJournalState({required this.errMessage});
}

class ErrorGenTrackState extends GetUserJournalState {
  // String errMessage;
  // ErrorGenTrackState({required this.errMessage});
}

class ErrorWaterDataState extends GetUserJournalState {
  // String errMessage;
  // ErrorJournalState({required this.errMessage});
}

class ErrorExerciseState extends GetUserJournalState {
  // String errMessage;
  // ErrorJournalState({required this.errMessage});
}

class LoadingData extends GetUserJournalState {}

class LoadingDoneState extends GetUserJournalState {}

class SelectedImagePathState extends GetUserJournalState {
  final String? imgPath;

  SelectedImagePathState({required this.imgPath});
}

class AddNewItemLoadingData extends GetUserJournalState {}

class AddNewItemSuccessState extends GetUserJournalState {
  final String? imgPath;

  AddNewItemSuccessState({required this.imgPath});
}

class AddNewDietLoadingData extends GetUserJournalState {}

class AddNewDietSuccessState extends GetUserJournalState {
  final String? imgPath;

  AddNewDietSuccessState({required this.imgPath});
}

class DailyRecapLoadingData extends GetUserJournalState {}

class DailyRecapSuccessState extends GetUserJournalState {
  final List<DailyRecapData>? recapData;

  DailyRecapSuccessState({required this.recapData});
}
