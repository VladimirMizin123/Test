abstract class MealPlanEvent {}

class MealPlanFetchEvent extends MealPlanEvent {
  final String userID;
  final int calorie;
  MealPlanFetchEvent({required this.userID, required this.calorie});
}
