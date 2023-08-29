import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
import 'package:gymeats_mobile/models/skip_meal_plan_model.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/fatch_meal_details_model.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/swap_meal_model.dart';

abstract class FetchMealPlanState {}

class InitialState extends FetchMealPlanState {}

// FETCH MEAL PLAN
class FetchMealPlanSuccessState extends FetchMealPlanState {
  final List<FetchMealPlanData> mealPlanList;

  FetchMealPlanSuccessState({required this.mealPlanList});
}

class FetchMealPlanLoadingState extends FetchMealPlanState {}

class FetchMealPlanErrorState extends FetchMealPlanState {}

// SKIP MEAL PLAN
class SkipMealPlanSuccessState extends FetchMealPlanState {
  final SkipMealPlanData skipMealPlanData;
  final String mealID;

  SkipMealPlanSuccessState({required this.skipMealPlanData, required this.mealID});
}

class SkipMealPlanLoadingState extends FetchMealPlanState {}

class SkipMealPlanErrorState extends FetchMealPlanState {}

class AddToGrocerySuccessState extends FetchMealPlanState {
  final bool isAdded;

  AddToGrocerySuccessState({required this.isAdded});
}

class AddToGroceryLoadingState extends FetchMealPlanState {}

class AddToGroceryErrorState extends FetchMealPlanState {}

class FetchSwapMealSuccessState extends FetchMealPlanState {
  final List<SimilarMealData>? similarMealData;

  FetchSwapMealSuccessState({this.similarMealData});
}

class FetchSwapMealLoadingState extends FetchMealPlanState {}

class FetchSwapMealErrorState extends FetchMealPlanState {}

class MealDetailsSuccessState extends FetchMealPlanState {
  final FetchModelData? fetchModelData;

  MealDetailsSuccessState({this.fetchModelData});
}

class MealDetailsLoadingState extends FetchMealPlanState {}

class MealDetailsErrorState extends FetchMealPlanState {}

class RestaurantSearchSuccessState extends FetchMealPlanState {
  final bool? isSuccess;

  RestaurantSearchSuccessState({this.isSuccess});
}

class RestaurantSearchLoadingState extends FetchMealPlanState {}

class RestaurantSearchErrorState extends FetchMealPlanState {}

class SwapMealDetailsState extends FetchMealPlanState {
  final SimilarMealData? similarMealData;
  final String? mealId;
  final int? day;

  SwapMealDetailsState({this.similarMealData, this.mealId, this.day});
}
