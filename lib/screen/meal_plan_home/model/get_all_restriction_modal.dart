// To parse this JSON data, do
//
//     final getAllRestrictionModal = getAllRestrictionModalFromJson(jsonString);
import 'dart:convert';

GetAllRestrictionModal getAllRestrictionModalFromJson(String str) => GetAllRestrictionModal.fromJson(json.decode(str));

String getAllRestrictionModalToJson(GetAllRestrictionModal data) => json.encode(data.toJson());

class GetAllRestrictionModal {
  final bool success;
  final dynamic message;
  final dynamic errorMessage;
  final Data data;

  GetAllRestrictionModal({
    required this.success,
    required this.message,
    required this.errorMessage,
    required this.data,
  });

  factory GetAllRestrictionModal.fromJson(Map<String, dynamic> json) => GetAllRestrictionModal(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data.toJson(),
      };
}

class Data {
  final Restrictions restrictions;

  Data({
    required this.restrictions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        restrictions: Restrictions.fromJson(json["restrictions"]),
      );

  Map<String, dynamic> toJson() => {
        "restrictions": restrictions.toJson(),
      };
}

class Restrictions {
  final List<Edge> edgesRestrictionList;

  Restrictions({
    required this.edgesRestrictionList,
  });

  factory Restrictions.fromJson(Map<String, dynamic> json) => Restrictions(
        edgesRestrictionList: List<Edge>.from(json["edges"].map((x) => Edge.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "edges": List<dynamic>.from(edgesRestrictionList.map((x) => x.toJson())),
      };
}

class Edge {
  final Node node;

  Edge({
    required this.node,
  });

  factory Edge.fromJson(Map<String, dynamic> json) => Edge(
        node: Node.fromJson(json["node"]),
      );

  Map<String, dynamic> toJson() => {
        "node": node.toJson(),
      };
}

class Node {
  final String id;
  final String name;
  final String subcategory;
  final String slugname;
  final bool isOnProgram;
  bool? isRestricted;

  Node({
    required this.id,
    required this.name,
    required this.subcategory,
    required this.slugname,
    required this.isOnProgram,
    this.isRestricted = false,
  });

  factory Node.fromJson(Map<String, dynamic> json) => Node(
        id: json["id"],
        name: json["name"],
        subcategory: json["subcategory"],
        slugname: json["slugname"],
        isOnProgram: json["isOnProgram"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "subcategory": subcategory,
        "slugname": slugname,
        "isOnProgram": isOnProgram,
      };
}
