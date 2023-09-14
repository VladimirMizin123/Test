import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_search_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bottomsheet/receive_order_ask_bottomsheet.dart';

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

class RemoveGroceryEvent extends GroceryEvent {
  final String? productID;

  RemoveGroceryEvent({required this.productID});
}

class GrocerySearchEvent extends GroceryEvent {
  final List<GrocerySearchModel>? grocerySearchModelList;

  GrocerySearchEvent({required this.grocerySearchModelList});
}

class GroceryDetailsMealInfoEvent extends GroceryEvent {
  final String? groceryProductName;

  GroceryDetailsMealInfoEvent({required this.groceryProductName});
}

class GrocerySelectedStoreEvent extends GroceryEvent {
  final List<Cart>? productsList;

  GrocerySelectedStoreEvent({this.productsList});
}



class GroceryProductListEvent extends GroceryEvent {
  final List<Product>? productList;
  final String? productID;

  GroceryProductListEvent({required this.productList, this.productID});
}

class CleatGroceryEvent extends GroceryEvent {}
