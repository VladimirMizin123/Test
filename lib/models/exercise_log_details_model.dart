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

  factory ExerciseLogDetailsModel.fromJson(Map<String, dynamic> json) =>
      ExerciseLogDetailsModel(
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
  List<ExerciseLogList>? exerciseLogList;

  ExerciseData({
    this.totalCaloriesBurned,
    this.exerciseLogList,
  });

  ExerciseData.fromJson(Map<String, dynamic> json) {
    totalCaloriesBurned = json['totalCaloriesBurned'];
    if (json['exerciseLogList'] != null) {
      exerciseLogList = <ExerciseLogList>[];
      json['exerciseLogList'].forEach((v) {
        exerciseLogList!.add(new ExerciseLogList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCaloriesBurned'] = this.totalCaloriesBurned;
    if (this.exerciseLogList != null) {
      data['exerciseLogList'] =
          this.exerciseLogList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExerciseLogList {
  String? exerciseName;
  int? workoutTime;
  int? caloriesBurned;
  String? exerciseLogDate;

  ExerciseLogList(
      {this.exerciseName,
      this.workoutTime,
      this.caloriesBurned,
      this.exerciseLogDate});

  ExerciseLogList.fromJson(Map<String, dynamic> json) {
    exerciseName = json['exerciseName'];
    workoutTime = json['workoutTime'];
    caloriesBurned = json['caloriesBurned'];
    exerciseLogDate = json['exerciseLogDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exerciseName'] = this.exerciseName;
    data['workoutTime'] = this.workoutTime;
    data['caloriesBurned'] = this.caloriesBurned;
    data['exerciseLogDate'] = this.exerciseLogDate;
    return data;
  }
}
