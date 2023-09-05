import 'package:gymeats_mobile/screen/grocery/modal/grocery_shopping_modal.dart';

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
  final bool isAdded;
  final String? productID;
  final bool? isAdd;
  final bool? isRemove;

  GroceryAddToShoppingSuccessState({this.isAdded = false, this.productID, this.isAdd, this.isRemove});
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
