import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/restaurants/model/add_items_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/create_checkout_request_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/create_order_request_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart'
    as user;
import 'package:gymeats_mobile/screen/restaurants/model/create_product_request_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/update_cart_items_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart'
    as user_add;

abstract class RestaurantEvent {}

/// Get User Address Event ===============================================================
class GetUserAddressEvent extends RestaurantEvent {}

class MealPlanMatchEvent extends RestaurantEvent {
  final String subcategoryId;

  MealPlanMatchEvent({required this.subcategoryId});
}

/// Get Restaurant List Event ===============================================================
class GetRestaurantListEvent extends RestaurantEvent {
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
  final List categotyData;

  GetRestaurantListEvent(
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
      this.categotyData);
}

/// Get Restaurant List Event ===============================================================
class GetRestaurantMenuListEvent extends RestaurantEvent {
  final String? restaurantId;
  final bool? pickUp;
  final String? mealType;

  final user.UserAddress? getUserAddress;

  GetRestaurantMenuListEvent(
      this.restaurantId, this.pickUp, this.mealType, this.getUserAddress);
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

class UpdateRestaurantCartEvent extends RestaurantEvent {
  final UpdateRestaurantItemsToShoppingListModel updateItemList;
  UpdateRestaurantCartEvent({required this.updateItemList});
}

/// Get Cart Event ===============================================================

class GetShoppingListEvent extends RestaurantEvent {}

/// Remove Shopping List Item Event ===============================================================

class RemoveShoppingListItemEvent extends RestaurantEvent {
  final String productID;

  RemoveShoppingListItemEvent({required this.productID});
}

/// Clear Shopping List Item Event ===============================================================

class ClearShoppingListItemEvent extends RestaurantEvent {}

/// Create Order ==============================================================================

class CreateOrderEvent extends RestaurantEvent {
  final CreateOrderModel createOrderModel;

  CreateOrderEvent({required this.createOrderModel});
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

class CheckDeliverableGroceryEvent extends RestaurantEvent {
  final List<Cart> cartList;
  final user_add.UserAddress? address;
  final Function(List<Cart>) callback;

  CheckDeliverableGroceryEvent({
    required this.cartList,
    required this.callback,
    required this.address,
  });
}
