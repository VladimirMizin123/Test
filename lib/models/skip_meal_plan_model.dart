// To parse this JSON data, do
//
//     final skipMealPlanModel = skipMealPlanModelFromJson(jsonString);

import 'dart:convert';

SkipMealPlanModel skipMealPlanModelFromJson(String str) => SkipMealPlanModel.fromJson(json.decode(str));

String skipMealPlanModelToJson(SkipMealPlanModel data) => json.encode(data.toJson());

class SkipMealPlanModel {
  final bool? success;
  final dynamic message;
  final dynamic errorMessage;
  final SkipMealPlanData? data;

  SkipMealPlanModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory SkipMealPlanModel.fromJson(Map<String, dynamic> json) => SkipMealPlanModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null ? null : SkipMealPlanData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class SkipMealPlanData {
  final CreateMealEntry? createMealEntry;

  SkipMealPlanData({
    this.createMealEntry,
  });

  factory SkipMealPlanData.fromJson(Map<String, dynamic> json) => SkipMealPlanData(
        createMealEntry: json["createMealEntry"] == null ? null : CreateMealEntry.fromJson(json["createMealEntry"]),
      );

  Map<String, dynamic> toJson() => {
        "createMealEntry": createMealEntry?.toJson(),
      };
}

class CreateMealEntry {
  final bool? success;
  final String? message;

  CreateMealEntry({
    this.success,
    this.message,
  });

  factory CreateMealEntry.fromJson(Map<String, dynamic> json) => CreateMealEntry(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
