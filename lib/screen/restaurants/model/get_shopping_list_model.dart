// To parse this JSON data, do
//
//     final getShoppingListData = getShoppingListDataFromJson(jsonString);

import 'dart:convert';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_list_model.dart';

GetShoppingListData getShoppingListDataFromJson(String str) =>
    GetShoppingListData.fromJson(json.decode(str));

String getShoppingListDataToJson(GetShoppingListData data) =>
    json.encode(data.toJson());

class GetShoppingListData {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  List<ShoppingListData>? data;

  GetShoppingListData({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetShoppingListData.fromJson(Map<String, dynamic> json) =>
      GetShoppingListData(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null
            ? []
            : List<ShoppingListData>.from(
                json["data"]!.map((x) => ShoppingListData.fromJson(x))),
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

class ShoppingListData {
  String? id;
  String? userId;
  String? productId;
  String? productName;
  Address? resAddress;
  int? quantity;
  int? price;
  int? originalPrice;
  dynamic unitSize;
  String? unitOfMeasurement;
  String? recipeId;
  String? mealmeStoreId;
  bool? isChecked;
  dynamic brandName;
  String? productType;
  List<Option>? options;
  bool isRemoveUpdated;
  bool isAddUpdated;
  num? orderMin;
  num? orderMax;

  ShoppingListData({
    this.id,
    this.userId,
    this.productId,
    this.productName,
    this.resAddress,
    this.quantity,
    this.price,
    this.originalPrice,
    this.unitSize,
    this.unitOfMeasurement,
    this.recipeId,
    this.mealmeStoreId,
    this.isChecked,
    this.brandName,
    this.productType,
    this.options,
    this.isAddUpdated = false,
    this.isRemoveUpdated = false,
    this.orderMin,
    this.orderMax,
  });

  factory ShoppingListData.fromJson(Map<String, dynamic> json) =>
      ShoppingListData(
        id: json["id"],
        userId: json["userId"],
        productId: json["productId"],
        productName: json["productName"],
        quantity: json["quantity"],
        price: json["price"],
        originalPrice: json["originalPrice"],
        resAddress: json["resAddress"] != null
            ? Address.fromJson(json["resAddress"] ?? {})
            : null,
        unitSize: json["unitSize"],
        unitOfMeasurement: json["unitOfMeasurement"],
        recipeId: json["recipeId"],
        mealmeStoreId: json["mealmeStoreId"],
        isChecked: json["isChecked"],
        brandName: json["brandName"],
        productType: json["productType"],
        options: json["options"] == null
            ? []
            : List<Option>.from(json["options"]!.map(
                (x) => Option.fromJson(x),
              )),
        orderMax: json["orderMax"],
        orderMin: json["orderMin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "productId": productId,
        "productName": productName,
        "quantity": quantity,
        "price": price,
        "originalPrice": originalPrice,
        "resAddress": resAddress?.toJson(),
        "unitSize": unitSize,
        "unitOfMeasurement": unitOfMeasurement,
        "recipeId": recipeId,
        "mealmeStoreId": mealmeStoreId,
        "isChecked": isChecked,
        "brandName": brandName,
        "productType": productType,
        "orderMax": orderMax,
        "orderMin": orderMin,
        "options": options == null
            ? []
            : List<dynamic>.from(options!.map((x) => x.toJson())),
      };
}

class Option {
  String? id;
  String? optionId;
  int? quantity;
  int? markedPrice;
  String? productId;

  Option({
    this.id,
    this.optionId,
    this.quantity,
    this.markedPrice,
    this.productId,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json["id"],
        optionId: json["optionId"],
        quantity: json["quantity"],
        markedPrice: json["marked_price"],
        productId: json["productId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "optionId": optionId,
        "quantity": quantity,
        "marked_price": markedPrice,
        "productId": productId,
      };
}
