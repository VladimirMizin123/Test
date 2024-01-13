import 'package:gymeats_mobile/screen/grocery/modal/grocery_search_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/add_items_shopping_list_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/swap_meal_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart'
    as userAddress;

abstract class MealPlanEvent {}

class MealPlanFetchEvent extends MealPlanEvent {
  MealPlanFetchEvent();
}

class GetMealLogByDateEvent extends MealPlanEvent {
  final String? date;
  GetMealLogByDateEvent({this.date});
}

class SkipMealPlanEvent extends MealPlanEvent {
  final String mealID;
  final String? mealName;
  final num? calorie;
  final String? mealType;
  final num? noOfServing;
  final String? recipeId;
  final num? protein;
  final num? fat;
  final num? carbs;

  SkipMealPlanEvent(
      {required this.mealID,
      this.mealName,
      this.calorie,
      this.mealType,
      this.noOfServing,
      this.recipeId,
      this.protein,
      this.fat,
      this.carbs});
}

class AddToGroceryListEvent extends MealPlanEvent {
  final List<AddItemsToShoppingListModal> addItemsList;
  AddToGroceryListEvent({required this.addItemsList});
}

class GroceryAddToShoppingListEvent extends MealPlanEvent {
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

  GroceryAddToShoppingListEvent({
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

class FetchSwapMealItemEvent extends MealPlanEvent {
  final String? recipeID;
  final int? serving;

  FetchSwapMealItemEvent({this.recipeID, this.serving});
}

class FetchMealDetailsEvent extends MealPlanEvent {
  final String? recipeID, recipeName;

  FetchMealDetailsEvent({this.recipeID, this.recipeName});
}

class FetchMealDetailsByNameEvent extends MealPlanEvent {
  final String? recipeName;

  FetchMealDetailsByNameEvent({this.recipeName});
}

class GrocerySearchEvent extends MealPlanEvent {
  final List<GrocerySearchModel>? grocerySearchModelList;
  final userAddress.UserAddress? getUserAddress;

  GrocerySearchEvent(
      {required this.grocerySearchModelList, required this.getUserAddress});
}

class SwapMealDetailsEvent extends MealPlanEvent {
  final SimilarMealData? similarMealData;
  final int? day;
  final DateTime? dateTime;
  final String? mealId;

  SwapMealDetailsEvent(
      {this.similarMealData, this.dateTime, this.day, this.mealId});
}

class AddSwapMealEvent extends MealPlanEvent {
  final SimilarMealData? similarMealData;
  final int? day;
  final DateTime? dateTime;
  final String? mealId;
  final String? recipeId;

  AddSwapMealEvent(
      {required this.similarMealData,
      required this.day,
      required this.dateTime,
      required this.mealId,
      required this.recipeId});
}

class RestaurantSearchEvent extends MealPlanEvent {
  final String? name;
  final String? latitude;
  final String? longitude;
  final String? maximumMiles;
  final bool? pickup;

  RestaurantSearchEvent(
      {this.name,
      this.latitude,
      this.longitude,
      this.maximumMiles,
      this.pickup});
}

class GetAllRestrictionEvent extends MealPlanEvent {}

class GetUserRestrictionEvent extends MealPlanEvent {}

class AddUserRestrictionEvent extends MealPlanEvent {
  final List<String>? edgeRestrictionList;

  AddUserRestrictionEvent({this.edgeRestrictionList});
}

class BarcodeScanEvent extends MealPlanEvent {
  final String barcode;

  BarcodeScanEvent({required this.barcode});
}

class ClearUserGroceryMealPlanEvent extends MealPlanEvent {}
