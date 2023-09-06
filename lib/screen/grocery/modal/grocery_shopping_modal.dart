// To parse this JSON data, do
//
//     final getGroceryShoppingListModel = getGroceryShoppingListModelFromJson(jsonString);

import 'dart:convert';

GetGroceryShoppingListModel getGroceryShoppingListModelFromJson(String str) => GetGroceryShoppingListModel.fromJson(json.decode(str));

String getGroceryShoppingListModelToJson(GetGroceryShoppingListModel data) => json.encode(data.toJson());

class GetGroceryShoppingListModel {
  final bool? success;
  final dynamic message;
  final dynamic errorMessage;
  final Data? data;

  GetGroceryShoppingListModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetGroceryShoppingListModel.fromJson(Map<String, dynamic> json) => GetGroceryShoppingListModel(
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
  final ShoppingListAggregate? shoppingListAggregate;

  Data({
    this.shoppingListAggregate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        shoppingListAggregate: json["shoppingListAggregate"] == null ? null : ShoppingListAggregate.fromJson(json["shoppingListAggregate"]),
      );

  Map<String, dynamic> toJson() => {
        "shoppingListAggregate": shoppingListAggregate?.toJson(),
      };
}

class ShoppingListAggregate {
  final List<Edge>? edges;

  ShoppingListAggregate({
    this.edges,
  });

  factory ShoppingListAggregate.fromJson(Map<String, dynamic> json) => ShoppingListAggregate(
        edges: json["edges"] == null ? [] : List<Edge>.from(json["edges"]!.map((x) => Edge.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "edges": edges == null ? [] : List<dynamic>.from(edges!.map((x) => x.toJson())),
      };
}

class Edge {
  final Node? node;

  Edge({
    this.node,
  });

  factory Edge.fromJson(Map<String, dynamic> json) => Edge(
        node: json["node"] == null ? null : Node.fromJson(json["node"]),
      );

  Map<String, dynamic> toJson() => {
        "node": node?.toJson(),
      };
}

class Node {
  final String? databaseId;
  final String? ingredient;
  final String? aisleName;
  final int? quantity;
  final String? unit;
  final double? grams;
  final bool? isDone;
  bool isLoadingAddItem;

  Node({
    this.databaseId,
    this.ingredient,
    this.aisleName,
    this.quantity,
    this.unit,
    this.grams,
    this.isDone,
    this.isLoadingAddItem = false,
  });

  factory Node.fromJson(Map<String, dynamic> json) => Node(
        databaseId: json["databaseId"],
        ingredient: json["ingredient"],
        aisleName: json["aisleName"],
        quantity: json["quantity"],
        unit: json["unit"],
        grams: json["grams"]?.toDouble(),
        isDone: json["isDone"],
      );

  Map<String, dynamic> toJson() => {
        "databaseId": databaseId,
        "ingredient": ingredient,
        "aisleName": aisleName,
        "quantity": quantity,
        "unit": unit,
        "grams": grams,
        "isDone": isDone,
      };
}
