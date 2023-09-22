abstract class GetDashboardEvent {}

class GetDashboardData extends GetDashboardEvent {}

class GenMealTrackerData extends GetDashboardEvent {}

class AddEatenMealData extends GetDashboardEvent {
  String mealId;
  AddEatenMealData({required this.mealId});
}
