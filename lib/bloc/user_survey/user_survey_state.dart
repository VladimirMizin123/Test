import 'package:gymeats_mobile/screen/meal_plan_home/model/get_all_restriction_modal.dart';

import '../../models/get_survey_model.dart';

abstract class UserSurveyState {}

class InitialState extends UserSurveyState {}

class LoadSurveyData extends UserSurveyState {
  SurveyDataQuestion surveyData;
  bool isAPIData;
  LoadSurveyData({required this.surveyData, this.isAPIData = false});
}

class ErrorStateData extends UserSurveyState {
  String errMessage;
  ErrorStateData({required this.errMessage});
}

class LoadingSurveyData extends UserSurveyState {}

class NextScreenState extends UserSurveyState {
  String dietId;
  NextScreenState({required this.dietId});
}

class GetAllRestrictionLoadingState extends UserSurveyState {}

class GetAllRestrictionSuccessState extends UserSurveyState {
  final List<Edge>? edgesRestrictionList;

  GetAllRestrictionSuccessState({ this.edgesRestrictionList});
}

class PreviousScreenState extends UserSurveyState {}
