import 'fetch_meal_plan_model.dart';

class GetMealTrackerDataModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  List<TrackerData>? data;

  GetMealTrackerDataModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetMealTrackerDataModel.fromJson(Map<String, dynamic> json) => GetMealTrackerDataModel(
    success: json["success"],
    message: json["message"],
    errorMessage: json["errorMessage"],
    data: json["data"] == null ? [] : List<TrackerData>.from(json["data"]!.map((x) => TrackerData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "errorMessage": errorMessage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class TrackerData {
  String? mealId;
  MealData? meal;
  String? value;
  DateTime? date;

  TrackerData({
    this.mealId,
    this.meal,
    this.value,
    this.date,
  });

  factory TrackerData.fromJson(Map<String, dynamic> json) => TrackerData(
    mealId: json["mealId"],
    meal: json["meal"] == null ? null : MealData.fromJson(json["meal"]),
    value: json["value"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "mealId": mealId,
    "meal": meal?.toJson(),
    "value": value,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
  };
}