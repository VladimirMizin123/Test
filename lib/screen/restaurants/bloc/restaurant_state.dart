import 'package:gymeats_mobile/screen/restaurants/model/create_order_response_model.dart'
    as order;
import 'package:gymeats_mobile/screen/restaurants/model/create_product_response_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_cousines_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_order_details.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_shopping_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';

abstract class RestaurantState {}

class InitialState extends RestaurantState {}

class ErrorState extends RestaurantState {}

/// Fetch Customization State
class FetchCustomizationLoaderState extends RestaurantState {}

class FetchCustomizationSuccessState extends RestaurantState {}

/// Get User Address State ===============================================================

class GetUserAddressSuccessState extends RestaurantState {
  final List<UserAddress> userAddress;

  GetUserAddressSuccessState({required this.userAddress});
}

class GetUserAddressLoadingState extends RestaurantState {}

class DeliverableLoaderState extends RestaurantState {}

class DeliverableSuccessState extends RestaurantState {}

class GetUserAddressErrorState extends RestaurantState {}

///================================================================================================================

/// Get Restaurant List State

class GetRestaurantListSuccessState extends RestaurantState {
  final List<RestaurantList> restaurantList;

  GetRestaurantListSuccessState({required this.restaurantList});
}

class RestaurantVerificationLoader extends RestaurantState {
  final bool isLoading;

  RestaurantVerificationLoader({required this.isLoading});
}

class GetRestaurantListLoadingState extends RestaurantState {}

class GetRestaurantListErrorState extends RestaurantState {}

class VerifyRestaurantLoader extends RestaurantState {
  final String? id;
  VerifyRestaurantLoader({required this.id});
}

///================================================================================================================

/// Get Restaurant Menu List State

class GetRestaurantMenuListSuccessState extends RestaurantState {
  final RestaurantMenu restaurantMenuList;

  GetRestaurantMenuListSuccessState({required this.restaurantMenuList});
}

class GetRestaurantMenuListLoadingState extends RestaurantState {}

class MatchMealLoadingState extends RestaurantState {
  final bool isLoading;
  MatchMealLoadingState({required this.isLoading});
}

class MatchMealState extends RestaurantState {
  final String? subCategoryId;
  final String? categoryName;
  final List<MenuItemList> updatedList;
  MatchMealState({
    required this.subCategoryId,
    required this.updatedList,
    this.categoryName
  });
}

class GetRestaurantMenuListErrorState extends RestaurantState {}

///================================================================================================================

/// Get Cousines List State

class GetCousinesListSuccessState extends RestaurantState {
  final CousinesList cousinesList;

  GetCousinesListSuccessState({required this.cousinesList});
}

class GetCousinesListLoadingState extends RestaurantState {}

class GetCousinesListErrorState extends RestaurantState {}

///================================================================================================================

/// Add Restaurant cart State

class AddToRestaurantCartSuccessState extends RestaurantState {
  final bool isAdded;
  final dynamic data;
  AddToRestaurantCartSuccessState({required this.isAdded, required this.data});
}

class AddToRestaurantCartLoadingState extends RestaurantState {
  final String productId;

  AddToRestaurantCartLoadingState({required this.productId});
}

class AddToRestaurantCartErrorState extends RestaurantState {
  final String productId;

  AddToRestaurantCartErrorState({required this.productId});
}

///================================================================================================================

/// Get Restaurant cart State

class GetShoppingListSuccessState extends RestaurantState {
  final List<ShoppingListData>? shoppingListData;

  GetShoppingListSuccessState({this.shoppingListData});
}

class GetShoppingListLoadingState extends RestaurantState {}

class GetShoppingListErrorState extends RestaurantState {}

///================================================================================================================

/// update Restaurant cart State

class UpdateToRestaurantCartSuccessState extends RestaurantState {
  final bool isAdded;
  final dynamic data;

  UpdateToRestaurantCartSuccessState(
      {required this.isAdded, required this.data});
}

class UpdateToRestaurantCartLoadingState extends RestaurantState {
  final String productId;

  UpdateToRestaurantCartLoadingState({required this.productId});
}

class UpdateToRestaurantCartErrorState extends RestaurantState {
  final String productId;

  UpdateToRestaurantCartErrorState({required this.productId});
}

///================================================================================================================

/// Remove Restaurant cart State

class RemoveShoppingListItemSuccessState extends RestaurantState {
  final String productId;

  RemoveShoppingListItemSuccessState({required this.productId});
}

class RemoveShoppingListItemLoadingState extends RestaurantState {
  final String productId;

  RemoveShoppingListItemLoadingState({required this.productId});
}

class RemoveShoppingListItemErrorState extends RestaurantState {
  final String productId;

  RemoveShoppingListItemErrorState({required this.productId});
}

///================================================================================================================

/// Clear Restaurant cart State

class ClearShoppingListItemSuccessState extends RestaurantState {}

class ClearShoppingListItemLoadingState extends RestaurantState {}

class ClearShoppingListItemErrorState extends RestaurantState {}

///================================================================================================================

/// Create Order State

class CreateOrderLoadingState extends RestaurantState {}

class CreateOrderSuccessState extends RestaurantState {
  final order.CreateOrderData? orderData;

  CreateOrderSuccessState({this.orderData});
}

class CreateOrderErrorState extends RestaurantState {}

///================================================================================================================

/// Create Product State

class CreateProductLoadingState extends RestaurantState {}

class CreateProductSuccessState extends RestaurantState {
  final ProductData? productData;

  CreateProductSuccessState({this.productData});
}

class CreateProductErrorState extends RestaurantState {}

///================================================================================================================

/// Create Checkout State

class CreateCheckoutLoadingState extends RestaurantState {}

class CreateCheckoutSuccessState extends RestaurantState {
  final dynamic data;

  CreateCheckoutSuccessState({this.data});
}

class CreateCheckoutErrorState extends RestaurantState {}

///================================================================================================================

/// Get Order State

class GetOrderLoadingState extends RestaurantState {}

class GetOrderSuccessState extends RestaurantState {
  final OrderData data;

  GetOrderSuccessState({required this.data});
}

class GetOrderErrorState extends RestaurantState {}

///================================================================================================================

/// Get Delivery Status State

class GetDeliveryStatusLoadingState extends RestaurantState {}

class GetDeliveryStatusSuccessState extends RestaurantState {
  final Map<String, dynamic> data;

  GetDeliveryStatusSuccessState({required this.data});
}

class GetDeliveryStatusErrorState extends RestaurantState {}

///================================================================================================================

/// Update Delivery Status State

class UpdateDeliveryStatusLoadingState extends RestaurantState {}

class UpdateDeliveryStatusSuccessState extends RestaurantState {
  final Map<String, dynamic> data;

  UpdateDeliveryStatusSuccessState({required this.data});
}

class UpdateDeliveryStatusErrorState extends RestaurantState {}
