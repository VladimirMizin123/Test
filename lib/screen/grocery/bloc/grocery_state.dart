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
  final String? databaseIdOfRecipes;


  GroceryAddToShoppingSuccessState({this.isAdded = false,
    this.databaseIdOfRecipes});
}

class GroceryAddToShoppingErrorState extends GroceryState {}
