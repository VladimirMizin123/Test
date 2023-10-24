import 'package:gymeats_mobile/screen/restaurants/model/get_cousines_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';

abstract class RestaurantState {}

class InitialState extends RestaurantState {}

class ErrorState extends RestaurantState {}

/// Get User Address State ===============================================================

class GetUserAddressSuccessState extends RestaurantState {
  final List<UserAddress> userAddress;

  GetUserAddressSuccessState({required this.userAddress});
}

class GetUserAddressLoadingState extends RestaurantState {}

class GetUserAddressErrorState extends RestaurantState {}

///================================================================================================================

/// Get Restaurant List State

class GetRestaurantListSuccessState extends RestaurantState {
  final List<RestaurantList> restaurantList;

  GetRestaurantListSuccessState({required this.restaurantList});
}

class GetRestaurantListLoadingState extends RestaurantState {}

class GetRestaurantListErrorState extends RestaurantState {}

///================================================================================================================

/// Get Restaurant Menu List State

class GetRestaurantMenuListSuccessState extends RestaurantState {
  final RestaurantMenu restaurantMenuList;

  GetRestaurantMenuListSuccessState({required this.restaurantMenuList});
}

class GetRestaurantMenuListLoadingState extends RestaurantState {}

class GetRestaurantMenuListErrorState extends RestaurantState {}

///================================================================================================================

/// Get Cousines List State

class GetCousinesListSuccessState extends RestaurantState {
  final CousinesList cousinesList;

  GetCousinesListSuccessState({required this.cousinesList});
}

class GetCousinesListLoadingState extends RestaurantState {}

class GetCousinesListErrorState extends RestaurantState {}
