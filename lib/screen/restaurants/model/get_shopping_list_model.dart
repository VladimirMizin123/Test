// To parse this JSON data, do
//
//     final getShoppingListData = getShoppingListDataFromJson(jsonString);

import 'dart:convert';

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
  String? userId;
  String? productId;
  String? productName;
  int? quantity;
  double? price;
  dynamic unitSize;
  String? unitOfMeasurement;
  String? recipeId;
  String? mealmeStoreId;
  bool? isChecked;
  dynamic brandName;
  String? productType;
  dynamic options;
  String? id;
  dynamic createdBy;
  String? createdOn;
  dynamic updatedBy;
  dynamic updatedOn;
  bool? isActive;
  bool? isDeleted;
  dynamic userCreatedBy;
  dynamic userUpdatedBy;

  ShoppingListData({
    this.userId,
    this.productId,
    this.productName,
    this.quantity,
    this.price,
    this.unitSize,
    this.unitOfMeasurement,
    this.recipeId,
    this.mealmeStoreId,
    this.isChecked,
    this.brandName,
    this.productType,
    this.options,
    this.id,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.isActive,
    this.isDeleted,
    this.userCreatedBy,
    this.userUpdatedBy,
  });

  factory ShoppingListData.fromJson(Map<String, dynamic> json) =>
      ShoppingListData(
        userId: json["userId"],
        productId: json["productId"],
        productName: json["productName"],
        quantity: json["quantity"],
        price: json["price"]?.toDouble(),
        unitSize: json["unitSize"],
        unitOfMeasurement: json["unitOfMeasurement"],
        recipeId: json["recipeId"],
        mealmeStoreId: json["mealmeStoreId"],
        isChecked: json["isChecked"],
        brandName: json["brandName"],
        productType: json["productType"],
        options: json["options"],
        id: json["id"],
        createdBy: json["createdBy"],
        createdOn: json["createdOn"],
        updatedBy: json["updatedBy"],
        updatedOn: json["updatedOn"],
        isActive: json["isActive"],
        isDeleted: json["isDeleted"],
        userCreatedBy: json["userCreatedBy"],
        userUpdatedBy: json["userUpdatedBy"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "productId": productId,
        "productName": productName,
        "quantity": quantity,
        "price": price,
        "unitSize": unitSize,
        "unitOfMeasurement": unitOfMeasurement,
        "recipeId": recipeId,
        "mealmeStoreId": mealmeStoreId,
        "isChecked": isChecked,
        "brandName": brandName,
        "productType": productType,
        "options": options,
        "id": id,
        "createdBy": createdBy,
        "createdOn": createdOn,
        "updatedBy": updatedBy,
        "updatedOn": updatedOn,
        "isActive": isActive,
        "isDeleted": isDeleted,
        "userCreatedBy": userCreatedBy,
        "userUpdatedBy": userUpdatedBy,
      };
}
