import 'package:gymeats_mobile/screen/meal_plan_home/model/swap_meal_model.dart';

abstract class MealPlanEvent {}

class MealPlanFetchEvent extends MealPlanEvent {
  MealPlanFetchEvent();
}

class SkipMealPlanEvent extends MealPlanEvent {
  final String mealID;
  SkipMealPlanEvent({required this.mealID});
}

class AddToGroceryListEvent extends MealPlanEvent {
  final String databaseIdOfRecipes;
  AddToGroceryListEvent({required this.databaseIdOfRecipes});
}

class FetchSwapMealItemEvent extends MealPlanEvent {
  final String? recipeID;
  final int? serving;

  FetchSwapMealItemEvent({this.recipeID, this.serving});
}

class FetchMealDetailsEvent extends MealPlanEvent {
  final String? recipeID;

  FetchMealDetailsEvent({this.recipeID});
}

class SwapMealDetailsEvent extends MealPlanEvent {
  final SimilarMealData? similarMealData;
  final int? day;
  final String? mealId;

  SwapMealDetailsEvent({this.similarMealData,
    this.day,
    this.mealId});
}

class RestaurantSearchEvent extends MealPlanEvent {
  final String? name;
  final String? latitude;
  final String? longitude;
  final String? maximumMiles;
  final bool? pickup;

  RestaurantSearchEvent({this.name, this.latitude, this.longitude, this.maximumMiles, this.pickup});
}
