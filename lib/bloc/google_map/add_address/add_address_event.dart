abstract class AddressEvent {}

class SaveClickEvent extends AddressEvent {
  final double latitude;
  final double longitude;
  final String streetNum;
  final String streetName;
  final String city;
  final String state;
  final String country;
  final String addressType;
  final String zipcode;
  final bool isPrimary;
  final String userId;
  final String isFrom;
  final String? floor;

  SaveClickEvent({
    required this.latitude,
    required this.longitude,
    required this.streetNum,
    required this.streetName,
    required this.city,
    required this.state,
    required this.country,
    required this.addressType,
    required this.zipcode,
    required this.isPrimary,
    required this.userId,
    required this.isFrom,
    this.floor,
  });
}

class UpdateClickEvent extends AddressEvent {
  final double latitude;
  final double longitude;
  final String streetNum;
  final String streetName;
  final String city;
  final String state;
  final String country;
  final String addressType;
  final String zipcode;
  final bool isPrimary;
  final String userId;
  final String isFrom;
  final String addressId;
  final String? floor;

  UpdateClickEvent({
    required this.latitude,
    required this.longitude,
    required this.streetNum,
    required this.streetName,
    required this.city,
    required this.state,
    required this.country,
    required this.addressType,
    required this.zipcode,
    required this.isPrimary,
    required this.userId,
    required this.isFrom,
    required this.addressId,
    this.floor,
  });
}

class DeleteClickEvent extends AddressEvent {
  final String isFrom;
  final String addressId;

  DeleteClickEvent({
    required this.isFrom,
    required this.addressId,
  });
}
