// To parse this JSON data, do
//
//     final grocerySearchModel = grocerySearchModelFromJson(jsonString);

import 'dart:convert';

GrocerySearchModel grocerySearchModelFromJson(String str) => GrocerySearchModel.fromJson(json.decode(str));

String grocerySearchModelToJson(GrocerySearchModel data) => json.encode(data.toJson());

class GrocerySearchModel {
  final String? groceryName;
  final int? quantity;

  GrocerySearchModel({
    this.groceryName,
    this.quantity,
  });

  factory GrocerySearchModel.fromJson(Map<String, dynamic> json) => GrocerySearchModel(
        groceryName: json["groceryName"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "groceryName": groceryName,
        "quantity": quantity,
      };
}
