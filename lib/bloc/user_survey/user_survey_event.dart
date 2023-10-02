

abstract class UserSurveyEvent{}

class GetSurveyData extends UserSurveyEvent{}

class GetAllRestrictionEvent extends UserSurveyEvent{}

class CheckSurveyData extends UserSurveyEvent{
  int index;
  CheckSurveyData({required this.index});
}

class NextPrevSurveyClick extends UserSurveyEvent{
  int index;
  bool isNext;
  NextPrevSurveyClick({required this.index, required this.isNext});
}

class SearchData extends UserSurveyEvent{
  String text;
  SearchData({required this.text});
}