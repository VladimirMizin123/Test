// To parse this JSON data, do
//
//     final productRestaurantSearchScreen = productRestaurantSearchScreenFromJson(jsonString);

import 'dart:convert';

ProductRestaurantSearchScreen productRestaurantSearchScreenFromJson(String str) => ProductRestaurantSearchScreen.fromJson(json.decode(str));

String productRestaurantSearchScreenToJson(ProductRestaurantSearchScreen data) => json.encode(data.toJson());

class ProductRestaurantSearchScreen {
  final bool? success;
  final dynamic message;
  final dynamic errorMessage;
  final Data? data;

  ProductRestaurantSearchScreen({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory ProductRestaurantSearchScreen.fromJson(Map<String, dynamic> json) => ProductRestaurantSearchScreen(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class Data {
  final List<dynamic>? products;

  Data({
    this.products,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        products: json["products"] == null ? [] : List<dynamic>.from(json["products"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x)),
      };
}
