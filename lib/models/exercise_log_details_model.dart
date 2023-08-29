class ExerciseLogDetailsModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  ExerciseData? data;

  ExerciseLogDetailsModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory ExerciseLogDetailsModel.fromJson(Map<String, dynamic> json) => ExerciseLogDetailsModel(
    success: json["success"],
    message: json["message"],
    errorMessage: json["errorMessage"],
    data: json["data"] == null ? null : ExerciseData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "errorMessage": errorMessage,
    "data": data?.toJson(),
  };
}

class ExerciseData {
  int? totalCaloriesBurned;
  List<dynamic>? exerciseLogList;

  ExerciseData({
    this.totalCaloriesBurned,
    this.exerciseLogList,
  });

  factory ExerciseData.fromJson(Map<String, dynamic> json) => ExerciseData(
    totalCaloriesBurned: json["totalCaloriesBurned"],
    exerciseLogList: json["exerciseLogList"] == null ? [] : List<dynamic>.from(json["exerciseLogList"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "totalWaterIntake": totalCaloriesBurned,
    "waterLogDetails": exerciseLogList == null ? [] : List<dynamic>.from(exerciseLogList!.map((x) => x)),
  };
}
