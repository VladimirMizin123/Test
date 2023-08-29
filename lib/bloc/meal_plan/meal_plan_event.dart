abstract class MealPlanEvent {}

class MealPlanFetchEvent extends MealPlanEvent {

  MealPlanFetchEvent();
}

class SkipMealPlanEvent extends MealPlanEvent {
  final String mealID;
  SkipMealPlanEvent({required this.mealID});
}
