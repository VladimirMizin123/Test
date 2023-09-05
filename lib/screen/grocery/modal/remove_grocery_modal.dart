// To parse this JSON data, do
//
//     final deleteGroceryShoppingItemModel = deleteGroceryShoppingItemModelFromJson(jsonString);

import 'dart:convert';

DeleteGroceryShoppingItemModel deleteGroceryShoppingItemModelFromJson(String str) => DeleteGroceryShoppingItemModel.fromJson(json.decode(str));

String deleteGroceryShoppingItemModelToJson(DeleteGroceryShoppingItemModel data) => json.encode(data.toJson());

class DeleteGroceryShoppingItemModel {
  final bool? success;
  final dynamic message;
  final String? errorMessage;
  final dynamic data;

  DeleteGroceryShoppingItemModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory DeleteGroceryShoppingItemModel.fromJson(Map<String, dynamic> json) => DeleteGroceryShoppingItemModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data,
      };
}
