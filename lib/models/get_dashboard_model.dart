class GetDashboardModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  Data? data;

  GetDashboardModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetDashboardModel.fromJson(Map<String, dynamic> json) => GetDashboardModel(
    success: json["success"],
    message: json["message"],
    errorMessage: json["errorMessage"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "errorMessage": errorMessage,
    "data": data?.toJson(),
  };
}

class Data {
  double? totalCalorie;
  double? totalProtein;
  double? totalFat;
  int? totalCarbs;
  int? dailyWaterGoals;
  int? dailyExerciseGoals;
  int? totalIntakeWater;
  int? totalIntakeFood;
  int? totalBurnedByExercise;

  Data({
    this.totalCalorie,
    this.totalProtein,
    this.totalFat,
    this.totalCarbs,
    this.dailyWaterGoals,
    this.dailyExerciseGoals,
    this.totalIntakeWater,
    this.totalIntakeFood,
    this.totalBurnedByExercise,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalCalorie: json["toatalCalorie"]?.toDouble(),
    totalProtein: json["totalProtein"]?.toDouble(),
    totalFat: json["totalFat"]?.toDouble(),
    totalCarbs: json["totalCarbs"],
    dailyWaterGoals: json["dailyWaterGoals"],
    dailyExerciseGoals: json["dailyExerciseGoals"],
    totalIntakeWater: json["totalIntakeWater"],
    totalIntakeFood: json["totalIntakeFood"],
    totalBurnedByExercise: json["totalBurnedByExercise"],
  );

  Map<String, dynamic> toJson() => {
    "toatalCalorie": totalCalorie,
    "totalProtein": totalProtein,
    "totalFat": totalFat,
    "totalCarbs": totalCarbs,
    "dailyWaterGoals": dailyWaterGoals,
    "dailyExerciseGoals": dailyExerciseGoals,
    "totalIntakeWater": totalIntakeWater,
    "totalIntakeFood": totalIntakeFood,
    "totalBurnedByExercise": totalBurnedByExercise,
  };
}
