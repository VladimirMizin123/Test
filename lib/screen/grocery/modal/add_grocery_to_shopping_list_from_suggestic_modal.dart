// To parse this JSON data, do
//
//     final addGroceryToShoppingListFromSuggesticModal = addGroceryToShoppingListFromSuggesticModalFromJson(jsonString);

import 'dart:convert';

AddGroceryToShoppingListFromSuggesticModal addGroceryToShoppingListFromSuggesticModalFromJson(String str) => AddGroceryToShoppingListFromSuggesticModal.fromJson(json.decode(str));

String addGroceryToShoppingListFromSuggesticModalToJson(AddGroceryToShoppingListFromSuggesticModal data) => json.encode(data.toJson());

class AddGroceryToShoppingListFromSuggesticModal {
  final bool? success;
  final dynamic message;
  final dynamic errorMessage;
  final List<dynamic>? data;

  AddGroceryToShoppingListFromSuggesticModal({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory AddGroceryToShoppingListFromSuggesticModal.fromJson(Map<String, dynamic> json) => AddGroceryToShoppingListFromSuggesticModal(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null ? [] : List<dynamic>.from(json["data"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
      };
}
