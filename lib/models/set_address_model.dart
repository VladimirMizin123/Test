// To parse this JSON data, do
//
//     final setAddressResponseModel = setAddressResponseModelFromJson(jsonString);

import 'dart:convert';

SetAddressResponseModel setAddressResponseModelFromJson(String str) =>
    SetAddressResponseModel.fromJson(json.decode(str));

String setAddressResponseModelToJson(SetAddressResponseModel data) =>
    json.encode(data.toJson());

class SetAddressResponseModel {
  bool? success;
  String? message;
  dynamic errorMessage;
  Data? data;

  SetAddressResponseModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory SetAddressResponseModel.fromJson(Map<String, dynamic> json) =>
      SetAddressResponseModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class Data {
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
  dynamic user;

  Data({
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
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        user: json["user"],
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
        "user": user,
      };
}
