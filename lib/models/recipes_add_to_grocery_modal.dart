// To parse this JSON data, do
//
//     final recipesAddToGroceryModel = recipesAddToGroceryModelFromJson(jsonString);

import 'dart:convert';

RecipesAddToGroceryModel recipesAddToGroceryModelFromJson(String str) => RecipesAddToGroceryModel.fromJson(json.decode(str));

String recipesAddToGroceryModelToJson(RecipesAddToGroceryModel data) => json.encode(data.toJson());

class RecipesAddToGroceryModel {
  final bool? success;
  final String? message;
  final dynamic errorMessage;
  final RecipesAddToGroceryData? data;

  RecipesAddToGroceryModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory RecipesAddToGroceryModel.fromJson(Map<String, dynamic> json) => RecipesAddToGroceryModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null ? null : RecipesAddToGroceryData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class RecipesAddToGroceryData {
  final String? userId;
  final String? productId;
  final String? productName;
  final int? quantity;
  final int? price;
  final int? unitSize;
  final String? unitOfMeasurement;
  final String? recipeId;
  final String? mealmeStoreId;
  final bool? isChecked;
  final String? id;
  final dynamic createdBy;
  final DateTime? createdOn;
  final dynamic updatedBy;
  final dynamic updatedOn;
  final bool? isActive;
  final bool? isDeleted;
  final dynamic userCreatedBy;
  final dynamic userUpdatedBy;

  RecipesAddToGroceryData({
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
    this.isActive,
    this.isDeleted,
    this.userCreatedBy,
    this.userUpdatedBy,
  });

  factory RecipesAddToGroceryData.fromJson(Map<String, dynamic> json) => RecipesAddToGroceryData(
        userId: json["userId"],
        productId: json["productId"],
        productName: json["productName"],
        quantity: json["quantity"],
        price: json["price"],
        unitSize: json["unitSize"],
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
