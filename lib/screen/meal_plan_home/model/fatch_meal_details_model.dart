// To parse this JSON data, do
//
//     final fetchMealDetailsModel = fetchMealDetailsModelFromJson(jsonString);

import 'dart:convert';

FetchMealDetailsModel fetchMealDetailsModelFromJson(String str) =>
    FetchMealDetailsModel.fromJson(json.decode(str));

String fetchMealDetailsModelToJson(FetchMealDetailsModel data) =>
    json.encode(data.toJson());

class FetchMealDetailsModel {
  final bool? success;
  final dynamic message;
  final dynamic errorMessage;
  final FetchModelData? data;

  FetchMealDetailsModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory FetchMealDetailsModel.fromJson(Map<String, dynamic> json) =>
      FetchMealDetailsModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data:
            json["data"] == null ? null : FetchModelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class FetchModelData {
  final Recipe? recipe;

  FetchModelData({
    this.recipe,
  });

  factory FetchModelData.fromJson(Map<String, dynamic> json) => FetchModelData(
        recipe: json["recipe"] == null ? null : Recipe.fromJson(json["recipe"]),
      );

  Map<String, dynamic> toJson() => {
        "recipe": recipe?.toJson(),
      };
}

class Recipe {
  final String? id;
  final NutrientsPerServing? nutrientsPerServing;
  final List<ParsedIngredientLine>? parsedIngredientLines;
  final String? databaseId;
  final String? totalTime;
  final num? totalTimeInSeconds;
  final String? name;
  final num? serving;
  final List<String>? ingredientLines;
  final List<Ingredient>? ingredients;
  final dynamic language;
  final List<dynamic>? courses;
  final dynamic cuisines;
  final dynamic source;
  final String? mainImage;
  final num? ingredientsCount;
  final num? weightInGrams;
  final num? servingWeight;
  final List<String>? instructions;
  final Nutri? nutritionalInfo;

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
        nutrientsPerServing: json["nutrientsPerServing"] == null
            ? null
            : NutrientsPerServing.fromJson(json["nutrientsPerServing"]),
        parsedIngredientLines: json["parsedIngredientLines"] == null
            ? []
            : List<ParsedIngredientLine>.from(json["parsedIngredientLines"]!
                .map((x) => ParsedIngredientLine.fromJson(x))),
        databaseId: json["databaseId"],
        totalTime: json["totalTime"],
        totalTimeInSeconds: json["totalTimeInSeconds"],
        name: json["name"],
        serving: json["serving"],
        ingredientLines: json["ingredientLines"] == null
            ? []
            : List<String>.from(json["ingredientLines"]!.map((x) => x)),
        ingredients: json["ingredients"] == null
            ? []
            : List<Ingredient>.from(
                json["ingredients"]!.map((x) => Ingredient.fromJson(x))),
        language: json["language"],
        courses: json["courses"] == null
            ? []
            : List<dynamic>.from(json["courses"]!.map((x) => x)),
        cuisines: json["cuisines"],
        source: json["source"],
        mainImage: json["mainImage"],
        ingredientsCount: json["ingredientsCount"],
        weightInGrams: json["weightInGrams"],
        servingWeight: json["servingWeight"],
        instructions: json["instructions"] == null
            ? []
            : List<String>.from(json["instructions"]!.map((x) => x)),
        nutritionalInfo: json["nutritionalInfo"] == null
            ? null
            : Nutri.fromJson(json["nutritionalInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nutrientsPerServing": nutrientsPerServing?.toJson(),
        "parsedIngredientLines": parsedIngredientLines == null
            ? []
            : List<dynamic>.from(parsedIngredientLines!.map((x) => x.toJson())),
        "databaseId": databaseId,
        "totalTime": totalTime,
        "totalTimeInSeconds": totalTimeInSeconds,
        "name": name,
        "serving": serving,
        "ingredientLines": ingredientLines == null
            ? []
            : List<dynamic>.from(ingredientLines!.map((x) => x)),
        "ingredients": ingredients == null
            ? []
            : List<dynamic>.from(ingredients!.map((x) => x.toJson())),
        "language": language,
        "courses":
            courses == null ? [] : List<dynamic>.from(courses!.map((x) => x)),
        "cuisines": cuisines,
        "source": source,
        "mainImage": mainImage,
        "ingredientsCount": ingredientsCount,
        "weightInGrams": weightInGrams,
        "servingWeight": servingWeight,
        "instructions": instructions == null
            ? []
            : List<dynamic>.from(instructions!.map((x) => x)),
        "nutritionalInfo": nutritionalInfo?.toJson(),
      };
}

class Nutri {
  final num? calories;
  final num? fat;
  final num? protein;
  final num? carbs;
  final dynamic nfSaturatedFat;
  final num? nfCholesterol;
  final num? nfSodium;
  final num? nfDietaryFiber;
  final num? nfSugars;
  final num? nfPotassium;

  Nutri({
    this.calories,
    this.fat,
    this.protein,
    this.carbs,
    this.nfSaturatedFat,
    this.nfCholesterol,
    this.nfSodium,
    this.nfDietaryFiber,
    this.nfSugars,
    this.nfPotassium

  });

  factory Nutri.fromJson(Map<String, dynamic> json) => Nutri(
        calories: json["calories"],
        fat: json["fat"],
        protein: json["protein"],
        carbs: json["carbs"],
        nfSaturatedFat: json["nfSaturatedFat"],
        nfCholesterol: json["nfCholesterol"],
        nfSodium: json["nfSodium"],
        nfDietaryFiber: json["nfDietaryFiber"],
        nfSugars: json["nfSugars"],
        nfPotassium: json["nfPotassium"],
      );

  Map<String, dynamic> toJson() => {
        "calories": calories,
        "fat": fat,
        "protein": protein,
        "carbs": carbs,
        "nfSaturatedFat": nfSaturatedFat,
        "nfCholesterol": nfCholesterol,
        "nfSodium": nfSodium,
        "nfDietaryFiber": nfDietaryFiber,
        "nfSugars": nfSugars,
        "nfPotassium": nfPotassium,
      };
}

class Ingredient {
  final String? name;
  bool isSelected;

  Ingredient({
    this.name,
    this.isSelected = false,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class NutrientsPerServing {
  final num? calories;
  final num? fat;
  final num? protein;
  final num? carbs;

  NutrientsPerServing({
    this.calories,
    this.fat,
    this.protein,
    this.carbs,
  });

  factory NutrientsPerServing.fromJson(Map<String, dynamic> json) =>
      NutrientsPerServing(
        calories: json["calories"],
        fat: json["fat"],
        protein: json["protein"],
        carbs: json["carbs"],
      );

  Map<String, dynamic> toJson() => {
        "calories": calories,
        "fat": fat,
        "protein": protein,
        "carbs": carbs,
      };
}

class ParsedIngredientLine {
  final String? ingredientLine;
  final String? ingredient;
  final String? quantity;
  final String? unit;
  final String? other;
  bool isSelected;
  ParsedIngredientLine({
    this.ingredientLine,
    this.ingredient,
    this.quantity,
    this.unit,
    this.other,
    this.isSelected = false,
  });

  factory ParsedIngredientLine.fromJson(Map<String, dynamic> json) =>
      ParsedIngredientLine(
        ingredientLine: json["ingredientLine"],
        ingredient: json["ingredient"],
        quantity: json["quantity"],
        unit: json["unit"],
        other: json["other"],
      );

  Map<String, dynamic> toJson() => {
        "ingredientLine": ingredientLine,
        "ingredient": ingredient,
        "quantity": quantity,
        "unit": unit,
        "other": other,
      };
}
