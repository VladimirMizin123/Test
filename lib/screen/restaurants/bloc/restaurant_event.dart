import 'package:flutter/material.dart';
import 'package:gymeats_mobile/screen/restaurants/model/add_items_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/create_checkout_request_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/create_order_request_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart'
    as user;
import 'package:gymeats_mobile/screen/restaurants/model/create_product_request_model.dart';
import 'package:gymeats_mobile/models/check_store_model.dart' as qu;

abstract class RestaurantEvent {}

/// Get User Address Event ===============================================================
class GetUserAddressEvent extends RestaurantEvent {}

class MealPlanMatchEvent extends RestaurantEvent {
  final String subcategoryId;
  final RestaurantMenu menu;
  final double? calories;
  final Function()? onSuccess;
  final Function()? onError;

  MealPlanMatchEvent({
    required this.menu,
    required this.subcategoryId,
    this.calories,
    this.onSuccess,
    this.onError,
  });
}

class RestaurantVerifyEvent extends RestaurantEvent {
  final dynamic latitude;
  final dynamic longitude;
  final bool pickup;
  final String? id;
  final String? mealType;
  final BuildContext context;
  final Function(RestaurantMenu?, qu.Quote?)? onVerify;
  final Function()? notVerify;

  RestaurantVerifyEvent({
    required this.latitude,
    required this.longitude,
    required this.pickup,
    required this.id,
    this.mealType,
    required this.context,
    required this.onVerify,
    this.notVerify,
  });
}

/// Get Restaurant List Event ===============================================================
class GetRestaurantListEvent extends RestaurantEvent {
  final double? latitude;
  final double? longitude;
  final bool pickup;
  final List categotyData;
  final String? mealName;
  final bool storeLocal;

  GetRestaurantListEvent(
    this.latitude,
    this.longitude,
    this.pickup,
    this.categotyData, {
    this.storeLocal = true,
    this.mealName,
  });
}

class RestaurantByNameEvent extends RestaurantEvent {
  final double? latitude;
  final double? longitude;
  final bool pickup;
  final String name;
  final List<String> cuisine;

  RestaurantByNameEvent(
    this.latitude,
    this.longitude,
    this.pickup,
    this.name,
    this.cuisine,
  );
}

/// Get Restaurant List Event ===============================================================
class GetRestaurantMenuListEvent extends RestaurantEvent {
  final String? restaurantId;
  final bool? pickUp;
  final String? mealType;
  final user.UserAddress? getUserAddress;
  final Function(RestaurantMenu? menu)? onDataGet;

  GetRestaurantMenuListEvent(
    this.restaurantId,
    this.pickUp,
    this.mealType,
    this.getUserAddress, {
    this.onDataGet,
  });
}

/// Get Cousines List Event ===============================================================
class GetCousinesEvent extends RestaurantEvent {
  final dynamic latitude;
  final dynamic longitude;
  final String userStreetNum;
  final String userStreetName;
  final String userCity;
  final String userState;
  final String userCountry;
  final String userZipcode;
  final bool pickup;
  final int maximumMiles;

  GetCousinesEvent(
    this.latitude,
    this.longitude,
    this.userStreetNum,
    this.userStreetName,
    this.userCity,
    this.userState,
    this.userCountry,
    this.userZipcode,
    this.pickup,
    this.maximumMiles,
  );
}

/// Add to Cart Event ===============================================================

class AddRestaurantCartEvent extends RestaurantEvent {
  final List<AddRestaurantItemsToShoppingListModel> addItemsList;
  AddRestaurantCartEvent({required this.addItemsList});
}

/// Update Cart Event ===============================================================

/// Get Cart Event ===============================================================

/// Remove Shopping List Item Event ===============================================================

/// Clear Shopping List Item Event ===============================================================

/// Create Order ==============================================================================

class CreateOrderEvent extends RestaurantEvent {
  final CreateOrderModel createOrderModel;
  final BuildContext context;

  CreateOrderEvent({
    required this.createOrderModel,
    required this.context,
  });
}

/// Create Product ==============================================================================

class CreateProductEvent extends RestaurantEvent {
  final CreateProductRequestModel createProductRequestModel;

  CreateProductEvent({required this.createProductRequestModel});
}

/// Create Checkout ==============================================================================

class CreateCheckoutEvent extends RestaurantEvent {
  final CreateCheckOutRequestModel createCheckOutRequestModel;

  CreateCheckoutEvent({required this.createCheckOutRequestModel});
}

/// Get Order ==============================================================================

class GetOrderDetailsEvent extends RestaurantEvent {
  final String mealMeOrderId;

  GetOrderDetailsEvent({required this.mealMeOrderId});
}

/// Get Delivery Status ==============================================================================

class GetDeliveryStatusEvent extends RestaurantEvent {}

/// Update Delivery Status ==============================================================================

class UpdateDeliveryStatusEvent extends RestaurantEvent {
  final bool pickUp;

  UpdateDeliveryStatusEvent({required this.pickUp});
}

class FetchCustomizationEvent extends RestaurantEvent {
  final String productId;
  final bool pickUp;
  final Function(MenuItemList) callback;

  FetchCustomizationEvent({
    required this.productId,
    required this.callback,
    this.pickUp = false,
  });
}

class ProductCustomizationEvent extends RestaurantEvent {
  final String productId;
  final Function(MenuItemList) callback;

  ProductCustomizationEvent({required this.productId, required this.callback});
}
