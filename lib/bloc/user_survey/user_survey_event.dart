import 'package:gymeats_mobile/screen/meal_plan_home/model/get_all_restriction_modal.dart';

abstract class UserSurveyEvent {}

class GetSurveyData extends UserSurveyEvent {}

class GetAllRestrictionEvent extends UserSurveyEvent {}

class GetDietPlanEvent extends UserSurveyEvent {}

class EditDietPlanEvent extends UserSurveyEvent {
  String dietId;
  EditDietPlanEvent({required this.dietId});
}

class CheckSurveyData extends UserSurveyEvent {
  int index;
  CheckSurveyData({required this.index});
}

class NextPrevSurveyClick extends UserSurveyEvent {
  int index;
  bool isNext;
  List<Edge>? searchEdgesRestrictionList;
  int pageIndex;
  NextPrevSurveyClick({
    required this.index,
    required this.isNext,
    this.searchEdgesRestrictionList,
    required this.pageIndex,
  });
}

class SearchData extends UserSurveyEvent {
  String text;
  SearchData({required this.text});
}
