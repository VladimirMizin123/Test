import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';

abstract class FetchMealPlanState {}

class InitialState extends FetchMealPlanState {}

class FetchMealPlanSuccessState extends FetchMealPlanState {
  final List<FetchMealPlanData> mealPlanList;

  FetchMealPlanSuccessState({required this.mealPlanList});
}

class FetchMealPlanLoadingState extends FetchMealPlanState {}

class FetchMealPlanErrorState extends FetchMealPlanState {}
