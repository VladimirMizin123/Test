import 'package:gymeats_mobile/screen/grocery/modal/grocery_search_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/add_items_shopping_list_modal.dart';
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
  final String? recipeID;

  FetchMealDetailsEvent({this.recipeID});
}

class GrocerySearchEvent extends MealPlanEvent {
  final List<GrocerySearchModel>? grocerySearchModelList;

  GrocerySearchEvent({required this.grocerySearchModelList});
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
