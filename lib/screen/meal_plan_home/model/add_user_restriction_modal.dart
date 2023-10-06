// To parse this JSON data, do
//
//     final addUserRestrictionModal = addUserRestrictionModalFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AddUserRestrictionModal addUserRestrictionModalFromJson(String str) => AddUserRestrictionModal.fromJson(json.decode(str));

String addUserRestrictionModalToJson(AddUserRestrictionModal data) => json.encode(data.toJson());

class AddUserRestrictionModal {
  final bool success;
  final String message;
  final dynamic errorMessage;
  final List<AddUserRestrictionDataModal> data;

  AddUserRestrictionModal({
    required this.success,
    required this.message,
    required this.errorMessage,
    required this.data,
  });

  factory AddUserRestrictionModal.fromJson(Map<String, dynamic> json) => AddUserRestrictionModal(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: List<AddUserRestrictionDataModal>.from(json["data"].map((x) => AddUserRestrictionDataModal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class AddUserRestrictionDataModal {
  final int day;
  final DateTime date;
  final double calories;
  final List<Meal> meals;

  AddUserRestrictionDataModal({
    required this.day,
    required this.date,
    required this.calories,
    required this.meals,
  });

  factory AddUserRestrictionDataModal.fromJson(Map<String, dynamic> json) => AddUserRestrictionDataModal(
        day: json["day"],
        date: DateTime.parse(json["date"]),
        calories: json["calories"]?.toDouble(),
        meals: List<Meal>.from(json["meals"].map((x) => Meal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "calories": calories,
        "meals": List<dynamic>.from(meals.map((x) => x.toJson())),
      };
}

class Meal {
  final String id;
  final double calories;
  final String meal;
  final int numOfServings;
  final Recipe recipe;
  final bool isSkipped;

  Meal({
    required this.id,
    required this.calories,
    required this.meal,
    required this.numOfServings,
    required this.recipe,
    required this.isSkipped,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        id: json["id"],
        calories: json["calories"]?.toDouble(),
        meal: json["meal"],
        numOfServings: json["numOfServings"],
        recipe: Recipe.fromJson(json["recipe"]),
        isSkipped: json["isSkipped"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "calories": calories,
        "meal": meal,
        "numOfServings": numOfServings,
        "recipe": recipe.toJson(),
        "isSkipped": isSkipped,
      };
}

class Recipe {
  final String id;
  final NutrientsPerServing nutrientsPerServing;
  final dynamic parsedIngredientLines;
  final String databaseId;
  final dynamic totalTime;
  final int totalTimeInSeconds;
  final String name;
  final int serving;
  final dynamic ingredientLines;
  final dynamic ingredients;
  final dynamic language;
  final dynamic courses;
  final dynamic cuisines;
  final dynamic source;
  final String mainImage;
  final int ingredientsCount;
  final int weightInGrams;
  final int servingWeight;
  final dynamic instructions;
  final dynamic nutritionalInfo;

  Recipe({
    required this.id,
    required this.nutrientsPerServing,
    required this.parsedIngredientLines,
    required this.databaseId,
    required this.totalTime,
    required this.totalTimeInSeconds,
    required this.name,
    required this.serving,
    required this.ingredientLines,
    required this.ingredients,
    required this.language,
    required this.courses,
    required this.cuisines,
    required this.source,
    required this.mainImage,
    required this.ingredientsCount,
    required this.weightInGrams,
    required this.servingWeight,
    required this.instructions,
    required this.nutritionalInfo,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json["id"],
        nutrientsPerServing: NutrientsPerServing.fromJson(json["nutrientsPerServing"]),
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
        "nutrientsPerServing": nutrientsPerServing.toJson(),
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
  final double calories;
  final double fat;
  final double protein;
  final double carbs;

  NutrientsPerServing({
    required this.calories,
    required this.fat,
    required this.protein,
    required this.carbs,
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
