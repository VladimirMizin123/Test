// To parse this JSON data, do
//
//     final createProductResponseModel = createProductResponseModelFromJson(jsonString);

import 'dart:convert';

CreateProductResponseModel createProductResponseModelFromJson(String str) =>
    CreateProductResponseModel.fromJson(json.decode(str));

String createProductResponseModelToJson(CreateProductResponseModel data) =>
    json.encode(data.toJson());

class CreateProductResponseModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  ProductData? data;

  CreateProductResponseModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory CreateProductResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateProductResponseModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null ? null : ProductData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class ProductData {
  PriceId? priceId;

  ProductData({
    this.priceId,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        priceId:
            json["priceId"] == null ? null : PriceId.fromJson(json["priceId"]),
      );

  Map<String, dynamic> toJson() => {
        "priceId": priceId?.toJson(),
      };
}

class PriceId {
  String? userId;
  List<MealmeItem>? mealmeItems;
  int? userPhone;
  String? mealmeOrderId;
  int? totalAmount;
  String? priceId;

  PriceId({
    this.userId,
    this.mealmeItems,
    this.userPhone,
    this.mealmeOrderId,
    this.totalAmount,
    this.priceId,
  });

  factory PriceId.fromJson(Map<String, dynamic> json) => PriceId(
        userId: json["userId"],
        mealmeItems: json["mealmeItems"] == null
            ? []
            : List<MealmeItem>.from(
                json["mealmeItems"]!.map((x) => MealmeItem.fromJson(x))),
        userPhone: json["user_phone"],
        mealmeOrderId: json["mealmeOrderId"],
        totalAmount: json["totalAmount"],
        priceId: json["priceId"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "mealmeItems": mealmeItems == null
            ? []
            : List<dynamic>.from(mealmeItems!.map((x) => x.toJson())),
        "user_phone": userPhone,
        "mealmeOrderId": mealmeOrderId,
        "totalAmount": totalAmount,
        "priceId": priceId,
      };
}

class MealmeItem {
  String? name;
  int? basePrice;
  int? quantity;
  String? image;
  int? markedPrice;
  String? productId;
  String? productType;

  MealmeItem({
    this.name,
    this.basePrice,
    this.quantity,
    this.image,
    this.markedPrice,
    this.productId,
    this.productType,
  });

  factory MealmeItem.fromJson(Map<String, dynamic> json) => MealmeItem(
        name: json["name"],
        basePrice: json["base_price"],
        quantity: json["quantity"],
        image: json["image"],
        markedPrice: json["marked_price"],
        productId: json["product_id"],
        productType: json["productType"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "base_price": basePrice,
        "quantity": quantity,
        "image": image,
        "marked_price": markedPrice,
        "product_id": productId,
        "productType": productType,
      };
}
