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
