import 'package:flutter/material.dart';
import 'package:gymeats_mobile/models/get_grocery_item_list_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/create_checkout_request_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/create_order_request_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/create_order_response_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/create_product_request_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_search_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bottomsheet/receive_order_ask_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/model/categorie_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart'
    as user_address;

abstract class GroceryEvent {}

// class AddGroceryToShoppingListFromSuggesticEvent extends GroceryEvent {
//   final String? latitude;
//   final String? longitude;
//   AddGroceryToShoppingListFromSuggesticEvent({required this.latitude, required this.longitude});
// }

class GroceryFetchEvent extends GroceryEvent {
  GroceryFetchEvent();
}

/// Get User Address Event ===============================================================
class GetUserAddressEvent extends GroceryEvent {}

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
  final user_address.UserAddress? getUserAddress;
  final AskReceiveOrder? askReceiveOrder;

  GrocerySearchEvent({
    required this.grocerySearchModelList,
    required this.getUserAddress,
    this.askReceiveOrder,
  });
}

class StoreNearByEvent extends GroceryEvent {
  final user_address.UserAddress? getUserAddress;
  final AskReceiveOrder? askReceiveOrder;

  StoreNearByEvent({
    required this.getUserAddress,
    this.askReceiveOrder,
  });
}

class StoreByNameEvent extends GroceryEvent {
  final user_address.UserAddress? getUserAddress;
  final AskReceiveOrder? askReceiveOrder;
  final String? name;

  StoreByNameEvent({
    required this.getUserAddress,
    this.askReceiveOrder,
    this.name,
  });
}

class StoreVerifyEvent extends GroceryEvent {
  final String? id;
  final user_address.UserAddress? getUserAddress;
  final AskReceiveOrder? askReceiveOrder;
  final Function(CategorieModel? categories)? onVerify;
  final Function()? notVerify;

  StoreVerifyEvent({
    this.id,
    required this.getUserAddress,
    this.askReceiveOrder,
    this.onVerify,
    this.notVerify,
  });
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
  final String? productId;

  GroceryProductListEvent({required this.productList, this.productId});
}

class CleatGroceryEvent extends GroceryEvent {}

class BarcodeScanEvent extends GroceryEvent {
  final String barcode;

  BarcodeScanEvent({required this.barcode});
}

class AddNewCustomMealEvent extends GroceryEvent {
  final String? name;
  final String? protein;
  final String? fat;
  final String? carbs;
  final String? calorie;
  final String? type;

  AddNewCustomMealEvent(
      {this.name, this.protein, this.fat, this.carbs, this.calorie, this.type});
}

/// Create Order ==============================================================================

class CreateOrderEvent extends GroceryEvent {
  final BuildContext? context;
  final CreateGroceryOrderModel createGroceryOrderModel;
  final List<GroceryDetails>? orderId;
  final Function(CreateOrderData?)? onSuccess;

  CreateOrderEvent({
    this.context,
    required this.createGroceryOrderModel,
    this.orderId,
    this.onSuccess,
  });
}

/// Multiple Order Create ============

class CreateMultipleOrderEvent extends GroceryEvent {
  final List<CreateOrderGroceryItems> data;
  final user_address.UserAddress? address;
  final int? askReceiveOrder;
  final List<Cart> selectedStoreProductList;
  List<GroceryDetails>? edgesList;

  CreateMultipleOrderEvent({
    required this.data,
    this.address,
    this.askReceiveOrder,
    required this.selectedStoreProductList,
    this.edgesList,
  });
}

/// Create Product ==============================================================================

class CreateProductEvent extends GroceryEvent {
  final CreateProductRequestModel createProductRequestModel;

  CreateProductEvent({required this.createProductRequestModel});
}

/// Create Checkout ==============================================================================

class CreateCheckoutEvent extends GroceryEvent {
  final CreateCheckOutRequestModel createCheckOutRequestModel;

  CreateCheckoutEvent({required this.createCheckOutRequestModel});
}

/// Get Delivery Status ==============================================================================

class GetDeliveryStatusEvent extends GroceryEvent {}

class StoreCategorieEvent extends GroceryEvent {
  final user_address.UserAddress? address;
  final String? storeId;
  final int? askReceiveOrder;

  StoreCategorieEvent({
    required this.address,
    required this.storeId,
    required this.askReceiveOrder,
  });
}

class StoreSubCategorieEvent extends GroceryEvent {
  final user_address.UserAddress? address;
  final String? storeId;
  final int? askReceiveOrder;
  final String? subcategoryId;

  StoreSubCategorieEvent({
    required this.address,
    required this.storeId,
    required this.askReceiveOrder,
    required this.subcategoryId,
  });
}
