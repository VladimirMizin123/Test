// To parse this JSON data, do
//
//     final getUserGroceryListModel = getUserGroceryListModelFromJson(jsonString);

import 'dart:convert';

import '../screen/grocery/modal/grocery_multi_search_modal.dart';

GetUserGroceryListModel getUserGroceryListModelFromJson(String str) =>
    GetUserGroceryListModel.fromJson(json.decode(str));

String getUserGroceryListModelToJson(GetUserGroceryListModel data) =>
    json.encode(data.toJson());

class GetUserGroceryListModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  List<GroceryDetails>? data;

  GetUserGroceryListModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetUserGroceryListModel.fromJson(Map<String, dynamic> json) =>
      GetUserGroceryListModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null
            ? []
            : List<GroceryDetails>.from(
                json["data"]!.map((x) => GroceryDetails.fromJson(x))),
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

class GroceryDetails {
  String? id;
  String? itemName;
  dynamic quantity;
  String? measurementType;
  dynamic measurementValue;
  String? userId;
  Product? product;

  GroceryDetails(
      {this.id,
      this.itemName,
      this.quantity,
      this.measurementType,
      this.measurementValue,
      this.userId,
      this.product});

  factory GroceryDetails.fromJson(Map<String, dynamic> json) => GroceryDetails(
        id: json["id"],
        itemName: json["itemName"],
        quantity: json["quantity"],
        measurementType: json["measurementType"],
        measurementValue: json["measurementValue"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemName": itemName,
        "quantity": quantity,
        "measurementType": measurementType,
        "measurementValue": measurementValue,
        "userId": userId,
      };
}
