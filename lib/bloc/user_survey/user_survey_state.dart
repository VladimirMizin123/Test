import '../../models/get_survey_model.dart';

abstract class UserSurveyState{}

class InitialState extends UserSurveyState{}

class LoadSurveyData extends UserSurveyState{
  SurveyDataQuestion surveyData;
  bool isAPIData;
  LoadSurveyData({required this.surveyData, this.isAPIData = false});
}
class ErrorStateData extends UserSurveyState{
  String errMessage;
  ErrorStateData({required this.errMessage});
}

class LoadingSurveyData extends UserSurveyState{}
class NextScreenState extends UserSurveyState{
  String dietId;
  NextScreenState({required this.dietId});
}
