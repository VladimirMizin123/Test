// To parse this JSON data, do
//
//     final getAllExerciseModal = getAllExerciseModalFromJson(jsonString);

import 'dart:convert';

GetAllExerciseModal getAllExerciseModalFromJson(String str) => GetAllExerciseModal.fromJson(json.decode(str));

String getAllExerciseModalToJson(GetAllExerciseModal data) => json.encode(data.toJson());

class GetAllExerciseModal {
  final bool success;
  final dynamic message;
  final dynamic errorMessage;
  final List<GetAllExerciseData> data;

  GetAllExerciseModal({
    required this.success,
    required this.message,
    required this.errorMessage,
    required this.data,
  });

  factory GetAllExerciseModal.fromJson(Map<String, dynamic> json) => GetAllExerciseModal(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: List<GetAllExerciseData>.from(json["data"].map((x) => GetAllExerciseData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class GetAllExerciseData {
  final String exerciseName;
  final int calorieBurnedPerMinute;
  final String id;
  final dynamic createdBy;
  final DateTime createdOn;
  final dynamic updatedBy;
  final dynamic updatedOn;
  final bool isActive;
  final bool isDeleted;
  final dynamic userCreatedBy;
  final dynamic userUpdatedBy;

  GetAllExerciseData({
    required this.exerciseName,
    required this.calorieBurnedPerMinute,
    required this.id,
    required this.createdBy,
    required this.createdOn,
    required this.updatedBy,
    required this.updatedOn,
    required this.isActive,
    required this.isDeleted,
    required this.userCreatedBy,
    required this.userUpdatedBy,
  });

  factory GetAllExerciseData.fromJson(Map<String, dynamic> json) => GetAllExerciseData(
        exerciseName: json["exerciseName"],
        calorieBurnedPerMinute: json["calorieBurnedPerMinute"],
        id: json["id"],
        createdBy: json["createdBy"],
        createdOn: DateTime.parse(json["createdOn"]),
        updatedBy: json["updatedBy"],
        updatedOn: json["updatedOn"],
        isActive: json["isActive"],
        isDeleted: json["isDeleted"],
        userCreatedBy: json["userCreatedBy"],
        userUpdatedBy: json["userUpdatedBy"],
      );

  Map<String, dynamic> toJson() => {
        "exerciseName": exerciseName,
        "calorieBurnedPerMinute": calorieBurnedPerMinute,
        "id": id,
        "createdBy": createdBy,
        "createdOn": createdOn.toIso8601String(),
        "updatedBy": updatedBy,
        "updatedOn": updatedOn,
        "isActive": isActive,
        "isDeleted": isDeleted,
        "userCreatedBy": userCreatedBy,
        "userUpdatedBy": userUpdatedBy,
      };
}
