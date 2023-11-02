abstract class MyAddressEvent {}

class MyAddressLoadEvent extends MyAddressEvent {
  final String? firstOption;
  MyAddressLoadEvent({this.firstOption});
}

class GetUserAddressEvent extends MyAddressEvent {}

class SetPrimaryAddressEvent extends MyAddressEvent {
  final String? addressId;
  SetPrimaryAddressEvent({this.addressId});
}
