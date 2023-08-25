abstract class MealPlanEvent {}

class MealPlanFetchEvent extends MealPlanEvent {
  final String userID;

  MealPlanFetchEvent({required this.userID});
}

class SkipMealPlanEvent extends MealPlanEvent {
  final String userID;
  final String mealID;
  SkipMealPlanEvent({required this.userID, required this.mealID});
}
