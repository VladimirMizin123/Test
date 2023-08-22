import '../../models/get_survey_model.dart';

abstract class UserSurveyState{}

class InitialState extends UserSurveyState{}

class LoadSurveyData extends UserSurveyState{
  SurveyDataQuestion surveyData;
  LoadSurveyData({required this.surveyData});
}
class ErrorStateData extends UserSurveyState{
  String errMessage;
  ErrorStateData({required this.errMessage});
}

class LoadingSurveyData extends UserSurveyState{}
