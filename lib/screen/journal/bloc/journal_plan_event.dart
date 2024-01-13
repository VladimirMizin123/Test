import 'package:gymeats_mobile/screen/grocery/modal/grocery_search_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/swap_meal_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';

abstract class JournalPlanEvent {}

class JournalPlanFetchEvent extends JournalPlanEvent {
  JournalPlanFetchEvent();
}

class GetMealLogByDateEvent extends JournalPlanEvent {
  final String? date;
  GetMealLogByDateEvent({this.date});
}

class JournalSkipMealPlanEvent extends JournalPlanEvent {
  final String mealID;
  JournalSkipMealPlanEvent({required this.mealID});
}

class JournalAddToGroceryListEvent extends JournalPlanEvent {
  final String databaseIdOfRecipes;
  JournalAddToGroceryListEvent({required this.databaseIdOfRecipes});
}

class JournalFetchSwapMealItemEvent extends JournalPlanEvent {
  final String? recipeID;
  final int? serving;

  JournalFetchSwapMealItemEvent({this.recipeID, this.serving});
}

class JournalFetchMealDetailsEvent extends JournalPlanEvent {
  final String? recipeID;

  JournalFetchMealDetailsEvent({this.recipeID});
}

class JournalSwapMealDetailsEvent extends JournalPlanEvent {
  final SimilarMealData? similarMealData;
  final int? day;
  final String? mealId;

  JournalSwapMealDetailsEvent({this.similarMealData, this.day, this.mealId});
}

class JournalRestaurantSearchEvent extends JournalPlanEvent {
  final String? name;
  final String? latitude;
  final String? longitude;
  final String? maximumMiles;
  final bool? pickup;

  JournalRestaurantSearchEvent(
      {this.name,
      this.latitude,
      this.longitude,
      this.maximumMiles,
      this.pickup});
}

class JournalAddExerciseEvent extends JournalPlanEvent {
  final DateTime dateTime;

  JournalAddExerciseEvent({required this.dateTime});
}

class JournalScanBarcodeEvent extends JournalPlanEvent {
  final String barcode;

  JournalScanBarcodeEvent({required this.barcode});
}

class JournalSearchEvent extends JournalPlanEvent {
  final List<GrocerySearchModel>? journalSearchModelList;
  final UserAddress? getUserAddress;

  JournalSearchEvent(
      {required this.journalSearchModelList, required this.getUserAddress});
}

class JournalAddToShoppingListEvent extends JournalPlanEvent {
  final String productID;
  final String productName;
  final String quantity;
  final String price;
  final String unitSize;
  final String unitOfMeasurement;
  final String recipeId;
  final String mealmeStoreId;
  final bool isAdd;
  final bool isRemove;
  final bool isChecked;

  JournalAddToShoppingListEvent({
    required this.productID,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.unitSize,
    required this.unitOfMeasurement,
    required this.recipeId,
    required this.mealmeStoreId,
    this.isAdd = false,
    this.isRemove = false,
    this.isChecked = false,
  });
}

class JournalAddToEatenEvent extends JournalPlanEvent {
  final String? mealId;
  final String? mealName;
  final num? calorie;
  final String? mealType;
  final num? noOfServing;
  final String? recipeId;
  final num? protein;
  final num? fat;
  final num? carbs;

  JournalAddToEatenEvent(
      {required this.mealId,
      required this.mealName,
      required this.calorie,
      required this.mealType,
      required this.noOfServing,
      required this.recipeId,
      required this.protein,
      required this.fat,
      required this.carbs});
}
