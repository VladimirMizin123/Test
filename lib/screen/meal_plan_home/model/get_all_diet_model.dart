// To parse this JSON data, do
//
//     final getAllDietModel = getAllDietModelFromJson(jsonString);

import 'dart:convert';

GetAllDietModel getAllDietModelFromJson(String str) =>
    GetAllDietModel.fromJson(json.decode(str));

String getAllDietModelToJson(GetAllDietModel data) =>
    json.encode(data.toJson());

class GetAllDietModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  List<DietDetails>? data;

  GetAllDietModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetAllDietModel.fromJson(Map<String, dynamic> json) =>
      GetAllDietModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null
            ? []
            : List<DietDetails>.from(
                json["data"]!.map((x) => DietDetails.fromJson(x))),
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

class DietDetails {
  String? id;
  String? dietName;
  double? proteinPercentage;
  double? carbsPercentage;
  double? fatPercentage;
  String? colorCode;
  String? createdBy;
  String? createdOn;
  String? updatedBy;
  String? updatedOn;
  bool? isActive;
  bool? isDeleted;
  bool? isDefault;
  double? surplusPercentage;
  double? deficitPercentage;
  String? mealSchedule;
  String? author;
  bool select = false;

  DietDetails({
    this.id,
    this.dietName,
    this.proteinPercentage,
    this.carbsPercentage,
    this.fatPercentage,
    this.colorCode,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.isActive,
    this.isDeleted,
    this.isDefault,
    this.surplusPercentage,
    this.deficitPercentage,
    this.mealSchedule,
    this.author,
  });

  factory DietDetails.fromJson(Map<String, dynamic> json) => DietDetails(
        id: json["id"],
        dietName: json["dietName"],
        proteinPercentage: json["proteinPercentage"]?.toDouble(),
        carbsPercentage: json["carbsPercentage"]?.toDouble(),
        fatPercentage: json["fatPercentage"]?.toDouble(),
        colorCode: json["colorCode"],
        createdBy: json["createdBy"],
        createdOn: json["createdOn"],
        updatedBy: json["updatedBy"],
        updatedOn: json["updatedOn"],
        isActive: json["isActive"],
        isDeleted: json["isDeleted"],
        isDefault: json["isDefault"],
        surplusPercentage: json["surplusPercentage"]?.toDouble(),
        deficitPercentage: json["deficitPercentage"]?.toDouble(),
        mealSchedule: json["mealSchedule"],
        author: json["author"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dietName": dietName,
        "proteinPercentage": proteinPercentage,
        "carbsPercentage": carbsPercentage,
        "fatPercentage": fatPercentage,
        "colorCode": colorCode,
        "createdBy": createdBy,
        "createdOn": createdOn,
        "updatedBy": updatedBy,
        "updatedOn": updatedOn,
        "isActive": isActive,
        "isDeleted": isDeleted,
        "isDefault": isDefault,
        "surplusPercentage": surplusPercentage,
        "deficitPercentage": deficitPercentage,
        "mealSchedule": mealSchedule,
        "author": author,
      };
}
