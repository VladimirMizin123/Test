

class AddAddressModel {
  double? latitude;
  double? longitude;
  String? streetNum;
  String? streetName;
  String? city;
  String? state;
  String? country;
  String? addressType;
  String? zipcode;
  bool? isPrimary;
  String? userId;

  AddAddressModel({
    this.latitude,
    this.longitude,
    this.streetNum,
    this.streetName,
    this.city,
    this.state,
    this.country,
    this.addressType,
    this.zipcode,
    this.isPrimary,
    this.userId,
  });
}
