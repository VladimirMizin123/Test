abstract class GetDashboardEvent {}

class GetDashboardData extends GetDashboardEvent {}

class GenMealTrackerData extends GetDashboardEvent {}

class AddEatenMealData extends GetDashboardEvent {
  String mealId;
  String? mealName;
  String? mealType;
  num? calorie;
  num? noOfServing;
  String? recipeId;
  num? protein;
  num? fat;
  num? carbs;
  num? value;
  String userId;

  AddEatenMealData(
      {required this.mealId,
      required this.userId,
      this.mealName,
      this.mealType,
      this.calorie,
      this.noOfServing,
      this.recipeId,
      this.protein,
      this.fat,
      this.carbs,
      this.value});
}

class GetOrderInvoiceList extends GetDashboardEvent {}
