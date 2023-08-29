// To parse this JSON data, do
//
//     final fetchMealPlanModel = fetchMealPlanModelFromJson(jsonString);

import 'dart:convert';

FetchMealPlanModel fetchMealPlanModelFromJson(String str) => FetchMealPlanModel.fromJson(json.decode(str));

String fetchMealPlanModelToJson(FetchMealPlanModel data) => json.encode(data.toJson());

class FetchMealPlanModel {
  final bool? success;
  final dynamic message;
  final dynamic errorMessage;
  final List<FetchMealPlanData>? data;

  FetchMealPlanModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory FetchMealPlanModel.fromJson(Map<String, dynamic> json) => FetchMealPlanModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null ? [] : List<FetchMealPlanData>.from(json["data"]!.map((x) => FetchMealPlanData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class FetchMealPlanData {
  final int? day;
  final DateTime? date;
  final double? calories;
  final List<MealData>? meals;

  FetchMealPlanData({
    this.day,
    this.date,
    this.calories,
    this.meals,
  });

  factory FetchMealPlanData.fromJson(Map<String, dynamic> json) => FetchMealPlanData(
        day: json["day"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        calories: json["calories"]?.toDouble(),
        meals: json["meals"] == null ? [] : List<MealData>.from(json["meals"]!.map((x) => MealData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "calories": calories,
        "meals": meals == null ? [] : List<dynamic>.from(meals!.map((x) => x.toJson())),
      };
}

class MealData {
  final String? id;
  final double? calories;
  final String? meal;
  final int? numOfServings;
  final Recipe? recipe;
  bool? isSkipped;

  MealData({
    this.id,
    this.calories,
    this.meal,
    this.numOfServings,
    this.recipe,
    this.isSkipped,
  });

  factory MealData.fromJson(Map<String, dynamic> json) => MealData(
        id: json["id"],
        calories: json["calories"]?.toDouble(),
        meal: json["meal"],
        numOfServings: json["numOfServings"],
        recipe: json["recipe"] == null ? null : Recipe.fromJson(json["recipe"]),
        isSkipped: json["isSkipped"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "calories": calories,
        "meal": meal,
        "numOfServings": numOfServings,
        "recipe": recipe?.toJson(),
        "isSkipped": isSkipped,
      };
}

class Recipe {
  final String? id;
  final NutrientsPerServing? nutrientsPerServing;
  final dynamic parsedIngredientLines;
  final String? databaseId;
  final dynamic totalTime;
  final int? totalTimeInSeconds;
  final String? name;
  final int? serving;
  final dynamic ingredientLines;
  final dynamic ingredients;
  final dynamic language;
  final dynamic courses;
  final dynamic cuisines;
  final dynamic source;
  final String? mainImage;
  final int? ingredientsCount;
  final int? weightInGrams;
  final int? servingWeight;
  final dynamic instructions;
  final dynamic nutritionalInfo;

  Recipe({
    this.id,
    this.nutrientsPerServing,
    this.parsedIngredientLines,
    this.databaseId,
    this.totalTime,
    this.totalTimeInSeconds,
    this.name,
    this.serving,
    this.ingredientLines,
    this.ingredients,
    this.language,
    this.courses,
    this.cuisines,
    this.source,
    this.mainImage,
    this.ingredientsCount,
    this.weightInGrams,
    this.servingWeight,
    this.instructions,
    this.nutritionalInfo,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json["id"],
        nutrientsPerServing: json["nutrientsPerServing"] == null ? null : NutrientsPerServing.fromJson(json["nutrientsPerServing"]),
        parsedIngredientLines: json["parsedIngredientLines"],
        databaseId: json["databaseId"],
        totalTime: json["totalTime"],
        totalTimeInSeconds: json["totalTimeInSeconds"],
        name: json["name"],
        serving: json["serving"],
        ingredientLines: json["ingredientLines"],
        ingredients: json["ingredients"],
        language: json["language"],
        courses: json["courses"],
        cuisines: json["cuisines"],
        source: json["source"],
        mainImage: json["mainImage"],
        ingredientsCount: json["ingredientsCount"],
        weightInGrams: json["weightInGrams"],
        servingWeight: json["servingWeight"],
        instructions: json["instructions"],
        nutritionalInfo: json["nutritionalInfo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nutrientsPerServing": nutrientsPerServing?.toJson(),
        "parsedIngredientLines": parsedIngredientLines,
        "databaseId": databaseId,
        "totalTime": totalTime,
        "totalTimeInSeconds": totalTimeInSeconds,
        "name": name,
        "serving": serving,
        "ingredientLines": ingredientLines,
        "ingredients": ingredients,
        "language": language,
        "courses": courses,
        "cuisines": cuisines,
        "source": source,
        "mainImage": mainImage,
        "ingredientsCount": ingredientsCount,
        "weightInGrams": weightInGrams,
        "servingWeight": servingWeight,
        "instructions": instructions,
        "nutritionalInfo": nutritionalInfo,
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
