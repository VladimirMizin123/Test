abstract class GroceryEvent {}

class GroceryFetchEvent extends GroceryEvent {
  GroceryFetchEvent();
}

class GroceryAddToShoppingListEvent extends GroceryEvent {
  final String? databaseIdOfRecipes;

  GroceryAddToShoppingListEvent({this.databaseIdOfRecipes});
}
