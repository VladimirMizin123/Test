// To parse this JSON data, do
//
//     final getCustomMealListModel = getCustomMealListModelFromJson(jsonString);

import 'dart:convert';

GetCustomMealListModel getCustomMealListModelFromJson(String str) =>
    GetCustomMealListModel.fromJson(json.decode(str));

String getCustomMealListModelToJson(GetCustomMealListModel data) =>
    json.encode(data.toJson());

class GetCustomMealListModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  List<CustomMealDetails>? data;

  GetCustomMealListModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetCustomMealListModel.fromJson(Map<String, dynamic> json) =>
      GetCustomMealListModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null
            ? []
            : List<CustomMealDetails>.from(
                json["data"]!.map((x) => CustomMealDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CustomMealDetails {
  String? id;
  String? name;
  String? imageUrl;
  double? protein;
  double? fat;
  int? quantity;
  double? carbs;
  double? calorie;
  String? type;
  String? userId;
  bool isEaten;
  bool isSkipped;

  CustomMealDetails({
    this.id,
    this.name,
    this.imageUrl,
    this.protein,
    this.fat,
    this.quantity,
    this.carbs,
    this.calorie,
    this.type,
    this.userId,
    this.isEaten = false,
    this.isSkipped = false,
  });

  factory CustomMealDetails.fromJson(Map<String, dynamic> json) =>
      CustomMealDetails(
        id: json["id"],
        name: json["name"],
        imageUrl: json["imageUrl"],
        protein: json["protein"]?.toDouble(),
        fat: json["fat"]?.toDouble(),
        quantity: json["quantity"],
        carbs: json["carbs"]?.toDouble(),
        calorie: json["calorie"]?.toDouble(),
        type: json["type"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
        "protein": protein,
        "fat": fat,
        "quantity": quantity,
        "carbs": carbs,
        "calorie": calorie,
        "type": type,
        "userId": userId,
      };
}
