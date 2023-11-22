// To parse this JSON data, do
//
//     final getUserAddressModel = getUserAddressModelFromJson(jsonString);

import 'dart:convert';

GetUserAddressModel getUserAddressModelFromJson(String str) =>
    GetUserAddressModel.fromJson(json.decode(str));

String getUserAddressModelToJson(GetUserAddressModel data) =>
    json.encode(data.toJson());

class GetUserAddressModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  List<UserAddress>? data;

  GetUserAddressModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetUserAddressModel.fromJson(Map<String, dynamic> json) =>
      GetUserAddressModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null
            ? []
            : List<UserAddress>.from(
                json["data"]!.map((x) => UserAddress.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class UserAddress {
  String? id;
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
  bool? isDeleted;
  String? userId;
  bool isSelected;

  UserAddress({
    this.id,
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
    this.isDeleted,
    this.userId,
    this.isSelected = false,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        id: json["id"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        streetNum: json["street_Num"],
        streetName: json["street_Name"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        addressType: json["addressType"],
        zipcode: json["zipcode"],
        isPrimary: json["isPrimary"],
        isDeleted: json["isDeleted"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "street_Num": streetNum,
        "street_Name": streetName,
        "city": city,
        "state": state,
        "country": country,
        "addressType": addressType,
        "zipcode": zipcode,
        "isPrimary": isPrimary,
        "isDeleted": isDeleted,
        "userId": userId,
      };
}
