import 'package:flutter/material.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';

class GetSurveyModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  SurveyDataQuestion? data;

  GetSurveyModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetSurveyModel.fromJson(Map<String, dynamic> json) => GetSurveyModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null ? null : SurveyDataQuestion.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class SurveyDataQuestion {
  String? id;
  String? label;
  bool? isPrimary;
  int? answerType;
  List<DataOption>? options;
  String? createdBy;

  SurveyDataQuestion({
    this.id,
    this.label,
    this.isPrimary,
    this.answerType,
    this.options,
    this.createdBy,
  });

  factory SurveyDataQuestion.fromJson(Map<String, dynamic> json) => SurveyDataQuestion(
        id: json["id"],
        label: json["label"],
        isPrimary: json["isPrimary"],
        answerType: json["answerType"],
        options: json["options"] == null ? [] : List<DataOption>.from(json["options"]!.map((x) => DataOption.fromJson(x))),
        createdBy: json["createdBy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "isPrimary": isPrimary,
        "answerType": answerType,
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
        "createdBy": createdBy,
      };
}

class DataOption {
  String? id;
  String? label;
  int? questionDiet;
  SurveyDataQuestion? question;
  Diet? diet;
  bool isSelect;
  Color? color;

  DataOption({this.id, this.label, this.questionDiet, this.question, this.diet, this.isSelect = false, this.color = ColorUtils.primaryBlue});

  factory DataOption.fromJson(Map<String, dynamic> json) => DataOption(
        id: json["id"],
        label: json["label"],
        questionDiet: json["question_Diet"],
        question: json["question"] == null ? null : SurveyDataQuestion.fromJson(json["question"]),
        diet: json["diet"] == null ? null : Diet.fromJson(json["diet"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "question_Diet": questionDiet,
        "question": question?.toJson(),
        "diet": diet?.toJson(),
      };
}

class Diet {
  String? id;
  String? dietName;
  double? proteinPercentage;
  double? carbsPercentage;
  double? fatPercentage;
  double? surplusPercentage;
  double? deficitPercentage;
  String? mealSchedule;
  bool? isDefault;

  Diet({
    this.id,
    this.dietName,
    this.proteinPercentage,
    this.carbsPercentage,
    this.fatPercentage,
    this.surplusPercentage,
    this.deficitPercentage,
    this.mealSchedule,
    this.isDefault,
  });

  factory Diet.fromJson(Map<String, dynamic> json) => Diet(
        id: json["id"],
        dietName: json["dietName"],
        proteinPercentage: json["proteinPercentage"]?.toDouble(),
        carbsPercentage: json["carbsPercentage"]?.toDouble(),
        fatPercentage: json["fatPercentage"]?.toDouble(),
        surplusPercentage: json["surplusPercentage"]?.toDouble(),
        deficitPercentage: json["deficitPercentage"]?.toDouble(),
        mealSchedule: json["mealSchedule"],
        isDefault: json["isDefault"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dietName": dietName,
        "proteinPercentage": proteinPercentage,
        "carbsPercentage": carbsPercentage,
        "fatPercentage": fatPercentage,
        "surplusPercentage": surplusPercentage,
        "deficitPercentage": deficitPercentage,
        "mealSchedule": mealSchedule,
        "isDefault": isDefault,
      };
}
