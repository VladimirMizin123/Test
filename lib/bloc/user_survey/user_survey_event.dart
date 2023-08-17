abstract class UserSurveyEvent{}

class GetSurveyData extends UserSurveyEvent{}

class CheckSurveyData extends UserSurveyEvent{
  int? mainIndex;
  int index;
  CheckSurveyData({required this.index, this.mainIndex});
}

class SearchData extends UserSurveyEvent{
  String text;
  int? mainIndex;
  SearchData({required this.text, this.mainIndex});
}