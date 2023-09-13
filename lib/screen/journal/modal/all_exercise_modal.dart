// To parse this JSON data, do
//
//     final allExerciseModel = allExerciseModelFromJson(jsonString);

import 'dart:convert';

AllExerciseModel allExerciseModelFromJson(String str) => AllExerciseModel.fromJson(json.decode(str));

String allExerciseModelToJson(AllExerciseModel data) => json.encode(data.toJson());

class AllExerciseModel {
  final bool? success;
  final dynamic message;
  final dynamic errorMessage;
  final AllExerciseModelData? data;

  AllExerciseModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory AllExerciseModel.fromJson(Map<String, dynamic> json) => AllExerciseModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null ? null : AllExerciseModelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class AllExerciseModelData {
  final int? totalCaloriesBurned;
  final List<ExerciseLogList>? exerciseLogList;

  AllExerciseModelData({
    this.totalCaloriesBurned,
    this.exerciseLogList,
  });

  factory AllExerciseModelData.fromJson(Map<String, dynamic> json) => AllExerciseModelData(
        totalCaloriesBurned: json["totalCaloriesBurned"],
        exerciseLogList: json["exerciseLogList"] == null ? [] : List<ExerciseLogList>.from(json["exerciseLogList"]!.map((x) => ExerciseLogList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalCaloriesBurned": totalCaloriesBurned,
        "exerciseLogList": exerciseLogList == null ? [] : List<dynamic>.from(exerciseLogList!.map((x) => x.toJson())),
      };
}

class ExerciseLogList {
  final String? exerciseName;
  final int? workoutTime;
  final int? caloriesBurned;
  final DateTime? exerciseLogDate;

  ExerciseLogList({
    this.exerciseName,
    this.workoutTime,
    this.caloriesBurned,
    this.exerciseLogDate,
  });

  factory ExerciseLogList.fromJson(Map<String, dynamic> json) => ExerciseLogList(
        exerciseName: json["exerciseName"],
        workoutTime: json["workoutTime"],
        caloriesBurned: json["caloriesBurned"],
        exerciseLogDate: json["exerciseLogDate"] == null ? null : DateTime.parse(json["exerciseLogDate"]),
      );

  Map<String, dynamic> toJson() => {
        "exerciseName": exerciseName,
        "workoutTime": workoutTime,
        "caloriesBurned": caloriesBurned,
        "exerciseLogDate": exerciseLogDate?.toIso8601String(),
      };
}
