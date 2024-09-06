import 'dart:convert';

SwapMealModel swapMealModelFromJson(String str) =>
    SwapMealModel.fromJson(json.decode(str));

String swapMealModelToJson(SwapMealModel data) => json.encode(data.toJson());

class SwapMealModel {
  bool success;
  dynamic message;
  dynamic errorMessage;
  Data data;

  SwapMealModel({
    required this.success,
    required this.message,
    required this.errorMessage,
    required this.data,
  });

  factory SwapMealModel.fromJson(Map<String, dynamic> json) => SwapMealModel(
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
  List<SimilarMealData>? similarCaloriesRecipes;

  Data({
    required this.similarCaloriesRecipes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        similarCaloriesRecipes: List<SimilarMealData>.from(
            json["similarCaloriesRecipes"]
                .map((x) => SimilarMealData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "similarCaloriesRecipes": List<dynamic>.from(
            similarCaloriesRecipes?.map((x) => x.toJson()) ?? []),
      };
}

class SimilarMealData {
  String? id;
  String? name;
  int? serving;
  int? numberOfServings;
  List<String>? instructions;
  String? databaseId;
  List<dynamic>? mealTags;
  String? mainImage;
  NutrientsPerServing? nutrientsPerServing;
  bool? isSelectedForSwap;

  SimilarMealData({
    this.id,
    this.name,
    this.serving,
    this.numberOfServings,
    this.instructions,
    this.databaseId,
    this.mealTags,
    this.mainImage,
    this.nutrientsPerServing,
    this.isSelectedForSwap = false,
  });

  factory SimilarMealData.fromJson(Map<String, dynamic> json) =>
      SimilarMealData(
        id: json["id"],
        name: json["name"],
        serving: json["serving"],
        numberOfServings: json["numberOfServings"],
        instructions: List<String>.from(json["instructions"].map((x) => x)),
        databaseId: json["databaseId"],
        mealTags: json["mealTags"],
        mainImage: json["mainImage"],
        nutrientsPerServing:
            NutrientsPerServing.fromJson(json["nutrientsPerServing"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "serving": serving,
        "numberOfServings": numberOfServings,
        "instructions": List<dynamic>.from(instructions?.map((x) => x) ?? []),
        "databaseId": databaseId,
        "mealTags": mealTags,
        "mainImage": mainImage,
        "nutrientsPerServing": nutrientsPerServing?.toJson(),
      };
}

class NutrientsPerServing {
  double calories;
  double carbs;
  double fat;
  double protein;

  NutrientsPerServing({
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
  });

  factory NutrientsPerServing.fromJson(Map<String, dynamic> json) =>
      NutrientsPerServing(
        calories: json["calories"].toDouble(),
        carbs: json["carbs"].toDouble(),
        fat: json["fat"].toDouble(),
        protein: json["protein"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "calories": calories,
        "carbs": carbs,
        "fat": fat,
        "protein": protein,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
