abstract class MyAddressEvent {}

class MyAddressLoadEvent extends MyAddressEvent {
  final String? firstOption;
  MyAddressLoadEvent({this.firstOption});
}

class GetUserAddressEvent extends MyAddressEvent {}

class SetPrimaryAddressEvent extends MyAddressEvent {
  final String? addressId;
  final double? lat;
  final double? lng;
  SetPrimaryAddressEvent({this.lat, this.lng, this.addressId});
}
