// To parse this JSON data, do
//
//     final swapMealModel = swapMealModelFromJson(jsonString);

import 'dart:convert';

SwapMealModel swapMealModelFromJson(String str) => SwapMealModel.fromJson(json.decode(str));

String swapMealModelToJson(SwapMealModel data) => json.encode(data.toJson());

class SwapMealModel {
  final bool? success;
  final dynamic message;
  final dynamic errorMessage;
  final Data? data;

  SwapMealModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory SwapMealModel.fromJson(Map<String, dynamic> json) => SwapMealModel(
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
  final RecipeSwapOptions? recipeSwapOptions;

  Data({
    this.recipeSwapOptions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        recipeSwapOptions: json["recipeSwapOptions"] == null ? null : RecipeSwapOptions.fromJson(json["recipeSwapOptions"]),
      );

  Map<String, dynamic> toJson() => {
        "recipeSwapOptions": recipeSwapOptions?.toJson(),
      };
}

class RecipeSwapOptions {
  final List<SimilarMealData>? similar;

  RecipeSwapOptions({
    this.similar,
  });

  factory RecipeSwapOptions.fromJson(Map<String, dynamic> json) => RecipeSwapOptions(
        similar: json["similar"] == null ? [] : List<SimilarMealData>.from(json["similar"]!.map((x) => SimilarMealData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "similar": similar == null ? [] : List<dynamic>.from(similar!.map((x) => x.toJson())),
      };
}

class SimilarMealData {
  final String? id;
  final String? databaseId;
  final String? name;
  final List<String>? mealTags;
  final int? serving;
  final int? numberOfServings;
  final String? mainImage;
  final NutrientsPerServing? nutrientsPerServing;
  final List<String>? instructions;
  bool isSelectedForSwap;

  SimilarMealData({
    this.id,
    this.databaseId,
    this.name,
    this.mealTags,
    this.serving,
    this.numberOfServings,
    this.mainImage,
    this.nutrientsPerServing,
    this.instructions,
    this.isSelectedForSwap = false,
  });

  factory SimilarMealData.fromJson(Map<String, dynamic> json) => SimilarMealData(
        id: json["id"],
        databaseId: json["databaseId"],
        name: json["name"],
        mealTags: json["mealTags"] == null ? [] : List<String>.from(json["mealTags"]!.map((x) => x)),
        serving: json["serving"],
        numberOfServings: json["numberOfServings"],
        mainImage: json["mainImage"],
        nutrientsPerServing: json["nutrientsPerServing"] == null ? null : NutrientsPerServing.fromJson(json["nutrientsPerServing"]),
        instructions: json["instructions"] == null ? [] : List<String>.from(json["instructions"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "databaseId": databaseId,
        "name": name,
        "mealTags": mealTags == null ? [] : List<dynamic>.from(mealTags!.map((x) => x)),
        "serving": serving,
        "numberOfServings": numberOfServings,
        "mainImage": mainImage,
        "nutrientsPerServing": nutrientsPerServing?.toJson(),
        "instructions": instructions == null ? [] : List<dynamic>.from(instructions!.map((x) => x)),
      };
}

class NutrientsPerServing {
  final double? calories;
  final double? fat;
  final double? protein;
  final double? carbs;

  NutrientsPerServing({
    this.calories,
    this.fat,
    this.protein,
    this.carbs,
  });

  factory NutrientsPerServing.fromJson(Map<String, dynamic> json) => NutrientsPerServing(
        calories: json["calories"]?.toDouble(),
        fat: json["fat"]?.toDouble(),
        protein: json["protein"]?.toDouble(),
        carbs: json["carbs"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "calories": calories,
        "fat": fat,
        "protein": protein,
        "carbs": carbs,
      };
}
