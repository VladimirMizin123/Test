// To parse this JSON data, do
//
//     final addItemsToShoppingListModal = addItemsToShoppingListModalFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AddRestaurantItemsToShoppingListModel addItemsToShoppingListModalFromJson(
        String str) =>
    AddRestaurantItemsToShoppingListModel.fromJson(json.decode(str));

String addItemsToShoppingListModalToJson(
        AddRestaurantItemsToShoppingListModel data) =>
    json.encode(data.toJson());

class AddRestaurantItemsToShoppingListModel {
  final String productId;
  final String productName;
  final int quantity;
  final int price;
  final int unitSize;
  final String unitOfMeasurement;
  final String recipeId;
  final bool isChecked;
  final String mealmeStoreId;

  AddRestaurantItemsToShoppingListModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.unitSize,
    required this.unitOfMeasurement,
    required this.recipeId,
    required this.isChecked,
    required this.mealmeStoreId,
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
      };
}
