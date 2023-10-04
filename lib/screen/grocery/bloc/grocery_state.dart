import 'package:gymeats_mobile/models/recipes_add_to_grocery_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_shopping_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/nutritionix_get_nx_meal_info_by_name_modal.dart';
import 'package:gymeats_mobile/screen/journal/modal/barcode_scanner_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bottomsheet/receive_order_ask_bottomsheet.dart';

abstract class GroceryState {}

class InitialState extends GroceryState {}

/// Fetch Grocery-Shopping List

class GroceryFetchLoadingState extends GroceryState {}

class GroceryFetchSuccessState extends GroceryState {
  final List<GroceryShoppingData>? edgesList;

  GroceryFetchSuccessState({this.edgesList});
}

class GroceryErrorState extends GroceryState {}

/// Grocery Add To Shopping List

class GroceryAddToShoppingLoadingState extends GroceryState {
  final String? productId;
  final bool isAdd;
  final bool isRemove;

  GroceryAddToShoppingLoadingState({
    this.productId,
    this.isAdd = false,
    this.isRemove = false,
  });
}

class GroceryAddToShoppingSuccessState extends GroceryState {
  final RecipesAddToGroceryData? recipesAddToGroceryData;
  final bool? isAdded;
  final bool? isAdd;
  final bool? isRemove;

  GroceryAddToShoppingSuccessState({required this.recipesAddToGroceryData, required this.isAdd, required this.isAdded, required this.isRemove});
}

class GroceryAddToShoppingErrorState extends GroceryState {}

/// Add Grocery To Shopping List From Suggestic

class AddGroceryToShoppingListFromSuggesticLoadingState extends GroceryState {
  AddGroceryToShoppingListFromSuggesticLoadingState();
}

class AddGroceryToShoppingListFromSuggesticSuccessState extends GroceryState {
  final bool isAdded;

  AddGroceryToShoppingListFromSuggesticSuccessState({this.isAdded = false});
}

class AddGroceryToShoppingListFromSuggesticErrorState extends GroceryState {}

/// Remove Grocery Item

class RemoveGroceryLoadingState extends GroceryState {
  final String? productId;

  RemoveGroceryLoadingState({
    this.productId,
  });
}

class RemoveGrocerySuccessState extends GroceryState {
  final String? productID;
  final bool? isDelete;

  RemoveGrocerySuccessState({required this.productID, required this.isDelete});
}

class RemoveGroceryErrorState extends GroceryState {
  final String? productID;

  RemoveGroceryErrorState({required this.productID});
}

/// Grocery Search Item

class GrocerySearchLoadingState extends GroceryState {
  GrocerySearchLoadingState();
}

class GrocerySearchSuccessState extends GroceryState {
  final List<Cart>? groceryMultiSearchProductList;

  GrocerySearchSuccessState({required this.groceryMultiSearchProductList});
}

class GrocerySearchErrorState extends GroceryState {
  GrocerySearchErrorState();
}

/// Grocery Details Meal Info Search Item

class GroceryDetailsMealInfoLoadingState extends GroceryState {
  GroceryDetailsMealInfoLoadingState();
}

class GroceryDetailsMealInfoSuccessState extends GroceryState {
  final List<Product>? groceryMultiSearchProductList;

  GroceryDetailsMealInfoSuccessState({required this.groceryMultiSearchProductList});
}

class GroceryDetailsMealInfoErrorState extends GroceryState {
  GroceryDetailsMealInfoErrorState();
}

/// Grocery Details Meal Info Details Item

class GroceryNutritionixGetNxMealInfoByNameLoadingState extends GroceryState {
  GroceryNutritionixGetNxMealInfoByNameLoadingState();
}

class GroceryNutritionixGetNxMealInfoByNameSuccessState extends GroceryState {
  final NutritionixGetNxMealInfoByNameModelData nutritionixGetNxMealInfoByNameModelData;

  GroceryNutritionixGetNxMealInfoByNameSuccessState({required this.nutritionixGetNxMealInfoByNameModelData});
}

class GroceryNutritionixGetNxMealInfoByNameErrorState extends GroceryState {
  GroceryNutritionixGetNxMealInfoByNameErrorState();
}

/// Grocery Details Meal Info Details Item

class GroceryAskReceiveOrderEventState extends GroceryState {
  final AskReceiveOrder? askReceiveOrder;

  GroceryAskReceiveOrderEventState({required this.askReceiveOrder});
}

/// Grocery Details Meal Info Details Item

class GrocerySelectedStoreEventState extends GroceryState {
  final List<Cart> productsList;

  GrocerySelectedStoreEventState({this.productsList = const []});
}

class GroceryAddToGrocerySuccessState extends GroceryState {
  final bool isAdded;

  GroceryAddToGrocerySuccessState({required this.isAdded});
}

class GroceryAddToGroceryLoadingState extends GroceryState {}

class GroceryAddToGroceryErrorState extends GroceryState {}

class GroceryProductListState extends GroceryState {
  final List<Product>? productList;
  final String? productID;

  GroceryProductListState({required this.productList,
    this.productID});
}


class ClearShoppingListLoadingState extends GroceryState {}

class ClearShoppingListErrorState extends GroceryState {}

class ClearShoppingListSuccessState extends GroceryState {
  final bool isClear;

  ClearShoppingListSuccessState({required this.isClear});
}


class BarcodeScannerLoadingState extends GroceryState {}

class BarcodeScannerSuccessState extends GroceryState {
  final BarcodeScannerData? barcodeScannerData;

  BarcodeScannerSuccessState({this.barcodeScannerData});
}

class BarcodeScannerErrorState extends GroceryState {}


class AddNewCustomMealLoadingState extends GroceryState {}

class AddNewCustomMealSuccessState extends GroceryState {
  final bool? isAdded;

  AddNewCustomMealSuccessState({this.isAdded});
}

class AddNewCustomMealErrorState extends GroceryState {}
