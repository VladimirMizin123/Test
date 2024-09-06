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
  List<SampleMeal>? sampleMeal;
  bool? isPremium;
  CpcsIngredientGroups? cpcsIngredientGroups;
  String? programIcon;

  ProgramInfo(
      {this.id,
      this.databaseId,
      this.name,
      this.author,
      this.comment,
      this.descriptionShort,
      this.descriptionLong,
      this.backgroundImage,
      this.sampleMeal,
      this.isPremium,
      this.cpcsIngredientGroups,
      this.programIcon});

  factory ProgramInfo.fromJson(Map<String, dynamic> json) => ProgramInfo(
        id: json["id"],
        databaseId: json["databaseId"],
        name: json["name"],
        author: json["author"],
        comment: json["comment"],
        descriptionShort: json["descriptionShort"],
        descriptionLong: json["descriptionLong"],
        backgroundImage: json["backgroundImage"],
        sampleMeal: json["sampleMeal"] == null
            ? []
            : List<SampleMeal>.from(
                json["sampleMeal"]!.map((x) => SampleMeal.fromJson(x))),
        isPremium: json["isPremium"],
        programIcon: json["programIcon"],
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
        "programIcon": programIcon,
        "sampleMeal": sampleMeal == null
            ? []
            : List<dynamic>.from(sampleMeal!.map((x) => x.toJson())),
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
        increase: json["increase"] == null
            ? []
            : List<Crease>.from(
                json["increase"]!.map((x) => Crease.fromJson(x))),
        decrease: json["decrease"] == null
            ? []
            : List<Crease>.from(
                json["decrease"]!.map((x) => Crease.fromJson(x))),
        avoid: json["avoid"] == null
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

class SampleMeal {
  String? id;
  String? name;
  dynamic mainImage;
  NutrientsPerServing? nutrientsPerServing;

  SampleMeal({
    this.id,
    this.name,
    this.mainImage,
    this.nutrientsPerServing,
  });

  factory SampleMeal.fromJson(Map<String, dynamic> json) => SampleMeal(
        id: json["id"],
        name: json["name"],
        mainImage: json["mainImage"],
        nutrientsPerServing: json["nutrientsPerServing"] == null
            ? null
            : NutrientsPerServing.fromJson(json["nutrientsPerServing"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mainImage": mainImage,
        "nutrientsPerServing": nutrientsPerServing?.toJson(),
      };
}

class NutrientsPerServing {
  double? calories;
  double? protein;
  double? fat;
  double? carbs;
  int? omega3;

  NutrientsPerServing({
    this.calories,
    this.protein,
    this.fat,
    this.carbs,
    this.omega3,
  });

  factory NutrientsPerServing.fromJson(Map<String, dynamic> json) =>
      NutrientsPerServing(
        calories: json["calories"]?.toDouble(),
        protein: json["protein"]?.toDouble(),
        fat: json["fat"]?.toDouble(),
        carbs: json["carbs"]?.toDouble(),
        omega3: json["omega3"],
      );

  Map<String, dynamic> toJson() => {
        "calories": calories,
        "protein": protein,
        "fat": fat,
        "carbs": carbs,
        "omega3": omega3,
      };
}
