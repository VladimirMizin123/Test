import '../../models/get_survey_model.dart';

abstract class UserSurveyState{}

class InitialState extends UserSurveyState{}

class LoadSurveyData extends UserSurveyState{
  List<GetSurveyModel> list;
  LoadSurveyData({required this.list});
}

class LoadingSurveyData extends UserSurveyState{}
