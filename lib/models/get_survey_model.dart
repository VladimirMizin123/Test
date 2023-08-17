import 'package:flutter/material.dart';
import 'package:gymeats_mobile/constant/app_colors.dart';

class GetSurveyModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  SurveyData? data;

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
    data: json["data"] == null ? null : SurveyData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "errorMessage": errorMessage,
    "data": data?.toJson(),
  };
}

class SurveyData {
  String? id;
  String? label;
  bool? isPrimary;
  int? answerType;
  List<DataOption>? options;
  String? createdBy;

  SurveyData({
    this.id,
    this.label,
    this.isPrimary,
    this.answerType,
    this.options,
    this.createdBy,
  });

  factory SurveyData.fromJson(Map<String, dynamic> json) => SurveyData(
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

/*class StickyQuestion {
  String? id;
  String? label;
  bool? isPrimary;
  int? answerType;
  List<DataOption>? options;

  StickyQuestion({
    this.id,
    this.label,
    this.isPrimary,
    this.answerType,
    this.options,
  });

  factory StickyQuestion.fromJson(Map<String, dynamic> json) => StickyQuestion(
    id: json["id"],
    label: json["label"],
    isPrimary: json["isPrimary"],
    answerType: json["answerType"],
    options: json["options"] == null ? [] : List<DataOption>.from(json["options"]!.map((x) => DataOption.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "isPrimary": isPrimary,
    "answerType": answerType,
    "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
  };
}

class TentacledOption {
  String? id;
  String? label;
  int? questionDiet;
  StickyQuestion? question;
  dynamic diet;

  TentacledOption({
    this.id,
    this.label,
    this.questionDiet,
    this.question,
    this.diet,
  });

  factory TentacledOption.fromJson(Map<String, dynamic> json) => TentacledOption(
    id: json["id"],
    label: json["label"],
    questionDiet: json["question_Diet"],
    question: json["question"] == null ? null : StickyQuestion.fromJson(json["question"]),
    diet: json["diet"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "question_Diet": questionDiet,
    "question": question?.toJson(),
    "diet": diet,
  };
}

class TentacledQuestion {
  String? id;
  String? label;
  bool? isPrimary;
  int? answerType;
  List<TentacledOption>? options;

  TentacledQuestion({
    this.id,
    this.label,
    this.isPrimary,
    this.answerType,
    this.options,
  });

  factory TentacledQuestion.fromJson(Map<String, dynamic> json) => TentacledQuestion(
    id: json["id"],
    label: json["label"],
    isPrimary: json["isPrimary"],
    answerType: json["answerType"],
    options: json["options"] == null ? [] : List<TentacledOption>.from(json["options"]!.map((x) => TentacledOption.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "isPrimary": isPrimary,
    "answerType": answerType,
    "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
  };
}

class FluffyOption {
  String? id;
  String? label;
  int? questionDiet;
  TentacledQuestion? question;
  dynamic diet;

  FluffyOption({
    this.id,
    this.label,
    this.questionDiet,
    this.question,
    this.diet,
  });

  factory FluffyOption.fromJson(Map<String, dynamic> json) => FluffyOption(
    id: json["id"],
    label: json["label"],
    questionDiet: json["question_Diet"],
    question: json["question"] == null ? null : TentacledQuestion.fromJson(json["question"]),
    diet: json["diet"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "question_Diet": questionDiet,
    "question": question?.toJson(),
    "diet": diet,
  };
}

class FluffyQuestion {
  String? id;
  String? label;
  bool? isPrimary;
  int? answerType;
  List<FluffyOption>? options;

  FluffyQuestion({
    this.id,
    this.label,
    this.isPrimary,
    this.answerType,
    this.options,
  });

  factory FluffyQuestion.fromJson(Map<String, dynamic> json) => FluffyQuestion(
    id: json["id"],
    label: json["label"],
    isPrimary: json["isPrimary"],
    answerType: json["answerType"],
    options: json["options"] == null ? [] : List<FluffyOption>.from(json["options"]!.map((x) => FluffyOption.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "isPrimary": isPrimary,
    "answerType": answerType,
    "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
  };
}*/

class Option {
  String? id;
  String? label;
  int? questionDiet;
  Question? question;
  dynamic diet;

  Option({
    this.id,
    this.label,
    this.questionDiet,
    this.question,
    this.diet,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    id: json["id"],
    label: json["label"],
    questionDiet: json["question_Diet"],
    question: json["question"] == null ? null : Question.fromJson(json["question"]),
    diet: json["diet"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "question_Diet": questionDiet,
    "question": question?.toJson(),
    "diet": diet,
  };
}

class Question {
  String? id;
  String? label;
  bool? isPrimary;
  int? answerType;
  List<Option>? options;

  Question({
    this.id,
    this.label,
    this.isPrimary,
    this.answerType,
    this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["id"],
    label: json["label"],
    isPrimary: json["isPrimary"],
    answerType: json["answerType"],
    options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "isPrimary": isPrimary,
    "answerType": answerType,
    "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
  };
}

class DataOption {
  String? id;
  String? label;
  int? questionDiet;
  Question? question;
  Diet? diet;
  bool isSelect;
  Color? color;

  DataOption({
    this.id,
    this.label,
    this.questionDiet,
    this.question,
    this.diet,
    this.isSelect = false,
    this.color = AppColors.primaryBlue
  });

  factory DataOption.fromJson(Map<String, dynamic> json) => DataOption(
    id: json["id"],
    label: json["label"],
    questionDiet: json["question_Diet"],
    question: json["question"] == null ? null : Question.fromJson(json["question"]),
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
