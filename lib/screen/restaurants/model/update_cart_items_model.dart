// To parse this JSON data, do
//
//     final addItemsToShoppingListModal = addItemsToShoppingListModalFromJson(jsonString);

import 'dart:convert';

UpdateRestaurantItemsToShoppingListModel updateItemsToShoppingListModalFromJson(
        String str) =>
    UpdateRestaurantItemsToShoppingListModel.fromJson(json.decode(str));

String updateItemsToShoppingListModalToJson(
        UpdateRestaurantItemsToShoppingListModel data) =>
    json.encode(data.toJson());

class UpdateRestaurantItemsToShoppingListModel {
  final String? userId;
  final String? oldProductId;
  final String? newProductId;
  final String? productName;
  final int? quantity;
  final dynamic price;
  final int? unitSize;
  final String? unitOfMeasurement;
  final String? recipeId;
  final bool? isChecked;
  final String? mealmeStoreId;
  final List<dynamic>? itemOptions;
  final String? productType;
  final String? brandName;

  UpdateRestaurantItemsToShoppingListModel({
    this.userId,
    this.oldProductId,
    this.newProductId,
    this.productName,
    this.quantity,
    this.price,
    this.unitSize,
    this.unitOfMeasurement,
    this.recipeId,
    this.isChecked,
    this.mealmeStoreId,
    this.itemOptions,
    this.productType,
    this.brandName,
  });

  factory UpdateRestaurantItemsToShoppingListModel.fromJson(
          Map<String, dynamic> json) =>
      UpdateRestaurantItemsToShoppingListModel(
        userId: json["userId"],
        oldProductId: json["oldProductId"],
        newProductId: json["newProductId"],
        productName: json["productName"],
        quantity: json["quantity"],
        price: json["price"],
        unitSize: json["unitSize"],
        unitOfMeasurement: json["unitOfMeasurement"],
        recipeId: json["recipeId"],
        isChecked: json["isChecked"],
        mealmeStoreId: json["mealmeStoreId"],
        itemOptions: json["itemOptions"],
        productType: json["productType"],
        brandName: json["brandName"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "oldProductId": oldProductId,
        "newProductId": newProductId,
        "productName": productName,
        "quantity": quantity,
        "price": price,
        "unitSize": unitSize,
        "unitOfMeasurement": unitOfMeasurement,
        "recipeId": recipeId,
        "isChecked": isChecked,
        "mealmeStoreId": mealmeStoreId,
        "itemOptions": itemOptions,
        "productType": productType,
        "brandName": brandName,
      };
}
