// To parse this JSON data, do
//
//     final getProgramInfoResponseModel = getProgramInfoResponseModelFromJson(jsonString);

import 'dart:convert';

GetProgramInfoResponseModel getProgramInfoResponseModelFromJson(String str) =>
    GetProgramInfoResponseModel.fromJson(json.decode(str));

String getProgramInfoResponseModelToJson(GetProgramInfoResponseModel data) =>
    json.encode(data.toJson());

class GetProgramInfoResponseModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  Data? data;

  GetProgramInfoResponseModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetProgramInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      GetProgramInfoResponseModel(
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
  ProgramInfo? program;

  Data({
    this.program,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        program: json["program"] == null
            ? null
            : ProgramInfo.fromJson(json["program"]),
      );

  Map<String, dynamic> toJson() => {
        "program": program?.toJson(),
      };
}

class ProgramInfo {
  String? id;
  String? databaseId;
  String? name;
  String? author;
  String? comment;
  String? descriptionShort;
  String? descriptionLong;
  String? backgroundImage;
  bool? isPremium;
  CpcsIngredientGroups? cpcsIngredientGroups;

  ProgramInfo({
    this.id,
    this.databaseId,
    this.name,
    this.author,
    this.comment,
    this.descriptionShort,
    this.descriptionLong,
    this.backgroundImage,
    this.isPremium,
    this.cpcsIngredientGroups,
  });

  factory ProgramInfo.fromJson(Map<String, dynamic> json) => ProgramInfo(
        id: json["id"],
        databaseId: json["databaseId"],
        name: json["name"],
        author: json["author"],
        comment: json["comment"],
        descriptionShort: json["descriptionShort"],
        descriptionLong: json["descriptionLong"],
        backgroundImage: json["backgroundImage"],
        isPremium: json["isPremium"],
        cpcsIngredientGroups: json["cpcsIngredientGroups"] == null
            ? null
            : CpcsIngredientGroups.fromJson(json["cpcsIngredientGroups"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "databaseId": databaseId,
        "name": name,
        "author": author,
        "comment": comment,
        "descriptionShort": descriptionShort,
        "descriptionLong": descriptionLong,
        "backgroundImage": backgroundImage,
        "isPremium": isPremium,
        "cpcsIngredientGroups": cpcsIngredientGroups?.toJson(),
      };
}

class CpcsIngredientGroups {
  List<Crease>? increase;
  List<Crease>? decrease;
  List<Crease>? avoid;

  CpcsIngredientGroups({
    this.increase,
    this.decrease,
    this.avoid,
  });

  factory CpcsIngredientGroups.fromJson(Map<String, dynamic> json) =>
      CpcsIngredientGroups(
        increase: json["increase"] == null || json["increase"] == []
            ? []
            : List<Crease>.from(
                json["increase"]!.map((x) => Crease.fromJson(x))),
        decrease: json["decrease"] == null || json["decrease"] == []
            ? []
            : List<Crease>.from(
                json["decrease"]!.map((x) => Crease.fromJson(x))),
        avoid: json["avoid"] == null || json["avoid"] == []
            ? []
            : List<Crease>.from(json["avoid"]!.map((x) => Crease.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "increase": increase == null
            ? []
            : List<dynamic>.from(increase!.map((x) => x.toJson())),
        "decrease": decrease == null
            ? []
            : List<dynamic>.from(decrease!.map((x) => x.toJson())),
        "avoid": avoid == null
            ? []
            : List<dynamic>.from(avoid!.map((x) => x.toJson())),
      };
}

class Crease {
  String? name;
  String? benefits;
  String? description;

  Crease({
    this.name,
    this.benefits,
    this.description,
  });

  factory Crease.fromJson(Map<String, dynamic> json) => Crease(
        name: json["name"],
        benefits: json["benefits"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "benefits": benefits,
        "description": description,
      };
}
