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
  final dynamic data;

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
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data,
      };
}
