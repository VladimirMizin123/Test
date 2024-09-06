import 'dart:convert';

UpdateDietProgramResponseModel updateDietProgramResponseModelFromJson(
        String str) =>
    UpdateDietProgramResponseModel.fromJson(json.decode(str));

String updateDietProgramResponseModelToJson(
        UpdateDietProgramResponseModel data) =>
    json.encode(data.toJson());

class UpdateDietProgramResponseModel {
  bool? success;
  String? message;
  dynamic errorMessage;
  List<Datum>? data;

  UpdateDietProgramResponseModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory UpdateDietProgramResponseModel.fromJson(Map<String, dynamic> json) =>
      UpdateDietProgramResponseModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? day;
  DateTime? date;
  double? calories;
  List<Meal>? meals;

  Datum({
    this.day,
    this.date,
    this.calories,
    this.meals,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        day: json["day"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        calories: json["calories"]?.toDouble(),
        meals: json["meals"] == null
            ? []
            : List<Meal>.from(json["meals"]!.map((x) => Meal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "calories": calories,
        "meals": meals == null
            ? []
            : List<dynamic>.from(meals!.map((x) => x.toJson())),
      };
}

class Meal {
  String? id;
  double? calories;
  String? meal;
  int? numOfServings;
  Recipe? recipe;
  bool? isSkipped;

  Meal({
    this.id,
    this.calories,
    this.meal,
    this.numOfServings,
    this.recipe,
    this.isSkipped,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
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
  String? id;
  NutrientsPerServing? nutrientsPerServing;
  dynamic parsedIngredientLines;
  String? databaseId;
  dynamic totalTime;
  int? totalTimeInSeconds;
  String? name;
  int? serving;
  dynamic ingredientLines;
  dynamic ingredients;
  dynamic language;
  dynamic courses;
  dynamic cuisines;
  dynamic source;
  String? mainImage;
  int? ingredientsCount;
  int? weightInGrams;
  num? servingWeight;
  dynamic instructions;
  dynamic nutritionalInfo;

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
  double? calories;
  double? fat;
  double? protein;
  double? carbs;

  NutrientsPerServing({
    this.calories,
    this.fat,
    this.protein,
    this.carbs,
  });

  factory NutrientsPerServing.fromJson(Map<String, dynamic> json) =>
      NutrientsPerServing(
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
