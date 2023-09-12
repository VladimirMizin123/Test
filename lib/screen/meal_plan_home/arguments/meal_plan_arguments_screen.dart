import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';

class MealPlanArguments {
  final MealData? mealData;
  final DateTime? currentSelectedData;

  MealPlanArguments({this.currentSelectedData, this.mealData});
}
