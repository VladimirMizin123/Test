// To parse this JSON data, do
//
//     final dailyRecapModal = dailyRecapModalFromJson(jsonString);

import 'dart:convert';

DailyRecapModal dailyRecapModalFromJson(String str) => DailyRecapModal.fromJson(json.decode(str));

String dailyRecapModalToJson(DailyRecapModal data) => json.encode(data.toJson());

class DailyRecapModal {
  final bool? success;
  final dynamic message;
  final dynamic errorMessage;
  final List<DailyRecapData>? data;

  DailyRecapModal({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory DailyRecapModal.fromJson(Map<String, dynamic> json) => DailyRecapModal(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null ? [] : List<DailyRecapData>.from(json["data"]!.map((x) => DailyRecapData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DailyRecapData {
  final String? label;
  final String? id;
  final dynamic createdBy;
  final DateTime? createdOn;
  final dynamic updatedBy;
  final DateTime? updatedOn;
  final bool? isActive;
  final bool? isDeleted;
  final dynamic userCreatedBy;
  final dynamic userUpdatedBy;

  DailyRecapData({
    this.label,
    this.id,
    this.createdBy,
    this.createdOn,
    this.updatedBy,
    this.updatedOn,
    this.isActive,
    this.isDeleted,
    this.userCreatedBy,
    this.userUpdatedBy,
  });

  factory DailyRecapData.fromJson(Map<String, dynamic> json) => DailyRecapData(
        label: json["label"],
        id: json["id"],
        createdBy: json["createdBy"],
        createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
        updatedBy: json["updatedBy"],
        updatedOn: json["updatedOn"] == null ? null : DateTime.parse(json["updatedOn"]),
        isActive: json["isActive"],
        isDeleted: json["isDeleted"],
        userCreatedBy: json["userCreatedBy"],
        userUpdatedBy: json["userUpdatedBy"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "id": id,
        "createdBy": createdBy,
        "createdOn": createdOn?.toIso8601String(),
        "updatedBy": updatedBy,
        "updatedOn": updatedOn?.toIso8601String(),
        "isActive": isActive,
        "isDeleted": isDeleted,
        "userCreatedBy": userCreatedBy,
        "userUpdatedBy": userUpdatedBy,
      };
}
