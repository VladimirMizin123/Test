// To parse this JSON data, do
//
//     final getAllProgramsResponseModel = getAllProgramsResponseModelFromJson(jsonString);

import 'dart:convert';

GetAllProgramsResponseModel getAllProgramsResponseModelFromJson(String str) =>
    GetAllProgramsResponseModel.fromJson(json.decode(str));

String getAllProgramsResponseModelToJson(GetAllProgramsResponseModel data) =>
    json.encode(data.toJson());

class GetAllProgramsResponseModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  Data? data;

  GetAllProgramsResponseModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetAllProgramsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetAllProgramsResponseModel(
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
  List<ProgramModel>? edges;

  Data({
    this.edges,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        edges: json["edges"] == null
            ? []
            : List<ProgramModel>.from(
                json["edges"]!.map((x) => ProgramModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "edges": edges == null
            ? []
            : List<dynamic>.from(edges!.map((x) => x.toJson())),
      };
}

class ProgramModel {
  Node? node;

  ProgramModel({
    this.node,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) => ProgramModel(
        node: json["node"] == null ? null : Node.fromJson(json["node"]),
      );

  Map<String, dynamic> toJson() => {
        "node": node?.toJson(),
      };
}

class Node {
  String? id;
  String? databaseId;
  String? name;
  String? author;
  bool? isActive;
  bool? isPremium;
  String? programIcons;

  Node(
      {this.id,
      this.databaseId,
      this.name,
      this.author,
      this.isActive,
      this.isPremium,
      this.programIcons});

  factory Node.fromJson(Map<String, dynamic> json) => Node(
        id: json["id"],
        databaseId: json["databaseId"],
        name: json["name"],
        author: json["author"],
        isActive: json["isActive"],
        isPremium: json["isPremium"],
        programIcons: json["programIcons"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "databaseId": databaseId,
        "name": name,
        "author": author,
        "isActive": isActive,
        "isPremium": isPremium,
        "programIcons": programIcons,
      };
}
