// To parse this JSON data, do
//
//     final addItemsToShoppingListModal = addItemsToShoppingListModalFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AddItemsToShoppingListModal addItemsToShoppingListModalFromJson(String str) => AddItemsToShoppingListModal.fromJson(json.decode(str));

String addItemsToShoppingListModalToJson(AddItemsToShoppingListModal data) => json.encode(data.toJson());

class AddItemsToShoppingListModal {
  final String productId;
  final String productName;
  final int quantity;
  final int price;
  final int unitSize;
  final String unitOfMeasurement;
  final String recipeId;
  final bool isChecked;
  final String mealmeStoreId;

  AddItemsToShoppingListModal({
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

  factory AddItemsToShoppingListModal.fromJson(Map<String, dynamic> json) => AddItemsToShoppingListModal(
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
