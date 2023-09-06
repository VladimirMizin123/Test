abstract class GroceryEvent {}

class AddGroceryToShoppingListFromSuggesticEvent extends GroceryEvent {
  final String? latitude;
  final String? longitude;

  AddGroceryToShoppingListFromSuggesticEvent({required this.latitude, required this.longitude});
}

class GroceryFetchEvent extends GroceryEvent {
  GroceryFetchEvent();
}

class GroceryAddToShoppingListEvent extends GroceryEvent {
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
  });
}

class RemoveGroceryEvent extends GroceryEvent {
  final String? productID;

  RemoveGroceryEvent({required this.productID});
}

class GrocerySearchEvent extends GroceryEvent {
  final String? searchValue;

  GrocerySearchEvent({required this.searchValue});
}

class GroceryDetailsMealInfoEvent extends GroceryEvent {
  final String? groceryProductName;

  GroceryDetailsMealInfoEvent({required this.groceryProductName});
}
