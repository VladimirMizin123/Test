abstract class AddAddressEvent {}

class SaveClickEvent extends AddAddressEvent {
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
  });
}
