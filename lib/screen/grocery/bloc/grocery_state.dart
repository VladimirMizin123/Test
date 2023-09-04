import 'package:gymeats_mobile/screen/grocery/modal/grocery_shopping_modal.dart';

abstract class GroceryState {}

class InitialState extends GroceryState {}

/// Fetch Grocery-Shopping List

class GroceryFetchLoadingState extends GroceryState {}

class GroceryFetchSuccessState extends GroceryState {
  final List<Edge>? edgesList;

  GroceryFetchSuccessState({this.edgesList});
}

class GroceryErrorState extends GroceryState {}

/// Grocery Add To Shopping List

class GroceryAddToShoppingLoadingState extends GroceryState {
  final String? databaseIdOfRecipes;

  GroceryAddToShoppingLoadingState({this.databaseIdOfRecipes});
}

class GroceryAddToShoppingSuccessState extends GroceryState {
  final bool isAdded;
  final String? productID;

  GroceryAddToShoppingSuccessState({this.isAdded = false, this.productID});
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
