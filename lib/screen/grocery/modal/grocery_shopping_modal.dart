// To parse this JSON data, do
//
//     final getGroceryShoppingListModel = getGroceryShoppingListModelFromJson(jsonString);

import 'dart:convert';

import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';

GetGroceryShoppingListModel getGroceryShoppingListModelFromJson(String str) => GetGroceryShoppingListModel.fromJson(json.decode(str));

String getGroceryShoppingListModelToJson(GetGroceryShoppingListModel data) => json.encode(data.toJson());

class GetGroceryShoppingListModel {
  final bool? success;
  final dynamic message;
  final dynamic errorMessage;
  final List<GroceryShoppingData>? data;

  GetGroceryShoppingListModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetGroceryShoppingListModel.fromJson(Map<String, dynamic> json) => GetGroceryShoppingListModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null ? [] : List<GroceryShoppingData>.from(json["data"]!.map((x) => GroceryShoppingData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class GroceryShoppingData {
  final String? userId;
  final String? productId;
  final String? productName;
  int? quantity;
  final int? price;
  final double? unitSize;
  final String? unitOfMeasurement;
  final String? recipeId;
  final String? mealmeStoreId;
  final bool? isChecked;
  final String? id;
  final dynamic createdBy;
  final DateTime? createdOn;
  final dynamic updatedBy;
  final dynamic updatedOn;
  bool? isActive;
  final bool? isDeleted;
  bool? isAddItem;
  bool? isRemoveItem;
  bool? isDeleteLoading;
  final dynamic userCreatedBy;
  final dynamic userUpdatedBy;
  Product? cartData;

  GroceryShoppingData({
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
    this.id,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.isActive = false,
    this.isDeleted,
    this.isAddItem = false,
    this.isRemoveItem = false,
    this.isDeleteLoading = false,
    this.userCreatedBy,
    this.userUpdatedBy,
    this.cartData,
  });

  factory GroceryShoppingData.fromJson(Map<String, dynamic> json) => GroceryShoppingData(
        userId: json["userId"],
        productId: json["productId"],
        productName: json["productName"],
        quantity: json["quantity"],
        price: json["price"],
        unitSize: json["unitSize"]?.toDouble(),
        unitOfMeasurement: json["unitOfMeasurement"],
        recipeId: json["recipeId"],
        mealmeStoreId: json["mealmeStoreId"],
        isChecked: json["isChecked"],
        id: json["id"],
        createdBy: json["createdBy"],
        createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
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
        "id": id,
        "createdBy": createdBy,
        "createdOn": createdOn?.toIso8601String(),
        "updatedBy": updatedBy,
        "updatedOn": updatedOn,
        "isActive": isActive,
        "isDeleted": isDeleted,
        "userCreatedBy": userCreatedBy,
        "userUpdatedBy": userUpdatedBy,
      };
}
