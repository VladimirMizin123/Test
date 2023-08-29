import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
import 'package:gymeats_mobile/models/skip_meal_plan_model.dart';

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
