abstract class UserSurveyEvent{}

class GetSurveyData extends UserSurveyEvent{}

class CheckSurveyData extends UserSurveyEvent{
  int mainIndex;
  int index;
  CheckSurveyData({required this.index, required this.mainIndex});
}

class SearchData extends UserSurveyEvent{
  String text;
  SearchData({required this.text});
}