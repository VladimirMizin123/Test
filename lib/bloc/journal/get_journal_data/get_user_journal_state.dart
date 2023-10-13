import 'package:gymeats_mobile/models/daily_recap_modal.dart';
import 'package:gymeats_mobile/models/get_all_exercise_modal.dart';
import 'package:gymeats_mobile/models/get_meallogby_date_model.dart';

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

class AllExerciseLogLoadingState extends GetUserJournalState {}

class AllExerciseLogSuccessState extends GetUserJournalState {
  ExerciseData? data;
  AllExerciseLogSuccessState({required this.data});
}

class AllExerciseLoadingState extends GetUserJournalState {}

class AllExerciseSuccessState extends GetUserJournalState {
  List<GetAllExerciseData> data;
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

class GetUserJournalDataLoading extends GetUserJournalState {}

class LoadingDoneState extends GetUserJournalState {}

class AddItemLoadingState extends GetUserJournalState {
  final String? title;
  final String? itemId;
  AddItemLoadingState({required this.title, required this.itemId});
}

class AddItemSuccessState extends GetUserJournalState {
  final String? title;
  final String? mealID;
  AddItemSuccessState({required this.title, this.mealID});
}

class AddItemErrorState extends GetUserJournalState {
  final String? title;
  final String? mealID;
  AddItemErrorState({required this.title, this.mealID});
}

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

class DailyRecapAnsLoadingData extends GetUserJournalState {}

class DailyRecapAnsSuccessState extends GetUserJournalState {
  final bool recapData;

  DailyRecapAnsSuccessState({required this.recapData});
}

class RemoveWaterLoadingData extends GetUserJournalState {}

class RemoveWaterErrorState extends GetUserJournalState {}

class RemoveWaterSuccessState extends GetUserJournalState {
  final bool removeWater;

  RemoveWaterSuccessState({required this.removeWater});
}

class JournalLoadDashboardDataState extends GetUserJournalState {
  List<MealDataByDate>? data;
  JournalLoadDashboardDataState({this.data});
}
