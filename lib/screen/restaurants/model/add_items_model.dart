// To parse this JSON data, do
//
//     final addItemsToShoppingListModal = addItemsToShoppingListModalFromJson(jsonString);

import 'dart:convert';

AddRestaurantItemsToShoppingListModel addItemsToShoppingListModalFromJson(
        String str) =>
    AddRestaurantItemsToShoppingListModel.fromJson(json.decode(str));

String addItemsToShoppingListModalToJson(
        AddRestaurantItemsToShoppingListModel data) =>
    json.encode(data.toJson());

class AddRestaurantItemsToShoppingListModel {
  final String? productId;
  final String? productName;
  final int? quantity;
  final dynamic price;
  final int? unitSize;
  final String? unitOfMeasurement;
  final String? recipeId;
  final bool? isChecked;
  final String? mealmeStoreId;
  final List<Map<String, dynamic>>? options;
  final String? productType;
  final String? brandName;

  AddRestaurantItemsToShoppingListModel({
    this.productId,
    this.productName,
    this.quantity,
    this.price,
    this.unitSize,
    this.unitOfMeasurement,
    this.recipeId,
    this.isChecked,
    this.mealmeStoreId,
    this.options,
    this.productType,
    this.brandName,
  });

  factory AddRestaurantItemsToShoppingListModel.fromJson(
          Map<String, dynamic> json) =>
      AddRestaurantItemsToShoppingListModel(
        productId: json["productId"],
        productName: json["productName"],
        quantity: json["quantity"],
        price: json["price"],
        unitSize: json["unitSize"],
        unitOfMeasurement: json["unitOfMeasurement"],
        recipeId: json["recipeId"],
        isChecked: json["isChecked"],
        mealmeStoreId: json["mealmeStoreId"],
        options: json["options"],
        productType: json["productType"],
        brandName: json["brandName"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "quantity": quantity,
        "price": price,
        "unitSize": unitSize,
        "unitOfMeasurement": unitOfMeasurement,
        "recipeId": recipeId,
        "isChecked": isChecked,
        "mealmeStoreId": mealmeStoreId,
        "options": options,
        "productType": productType,
        "brandName": brandName,
      };
}
