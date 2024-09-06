import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';

class MealPlanArguments {
  final MealData? mealData;
  final DateTime? currentSelectedData;
  final String? productName;
  final String? barcodeNumber;
  final bool? isFromScanner;
  final bool? isJournalMeal;

  MealPlanArguments(
      {this.isFromScanner = false,
      this.barcodeNumber = '',
      this.currentSelectedData,
      this.productName,
      this.mealData,
      this.isJournalMeal = false});
}
