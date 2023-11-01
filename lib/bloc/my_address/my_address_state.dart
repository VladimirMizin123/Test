import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';

abstract class MyAddressState {}

class InitialState extends MyAddressState {}

class GetUserAddressLoadingState extends MyAddressState {}

class GetUserAddressSuccessState extends MyAddressState {
  final List<UserAddress> userAddress;

  GetUserAddressSuccessState({required this.userAddress});
}

class ErrorState extends MyAddressState {}

class GetUserAddressErrorState extends MyAddressState {}

class SetAddressPrimarySuccessState extends MyAddressState {
  SetAddressPrimarySuccessState();
}
