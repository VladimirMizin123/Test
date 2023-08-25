
abstract class GetDashboardEvent{}

class GetSurveyData extends GetDashboardEvent{}

class CheckSurveyData extends GetDashboardEvent{
  int index;
  CheckSurveyData({required this.index});
}

class NextPrevSurveyClick extends GetDashboardEvent{
  int index;
  bool isNext;
  NextPrevSurveyClick({required this.index, required this.isNext});
}

class SearchData extends GetDashboardEvent{
  String text;
  SearchData({required this.text});
}