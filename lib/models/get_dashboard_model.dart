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
  double? totalCarbs;
  int? dailyWaterGoals;
  int? dailyExerciseGoals;
  double? totalIntakeWater;
  double? totalIntakeFood;
  double? totalBurnedByExercise;
  double? totalIntakeFat;
  double? totalIntakeProtein;
  double? totalIntakeCarbs;

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
    this.totalIntakeFat,
    this.totalIntakeProtein,
    this.totalIntakeCarbs,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalCalorie: json["toatalCalorie"]?.toDouble(),
    totalProtein: json["totalProtein"]?.toDouble(),
    totalFat: json["totalFat"]?.toDouble(),
    totalCarbs: json["totalCarbs"]?.toDouble(),
    dailyWaterGoals: json["dailyWaterGoals"]??0,
    dailyExerciseGoals: json["dailyExerciseGoals"]??0,
    totalIntakeWater: json["totalIntakeWater"]?.toDouble(),
    totalIntakeFood: json["totalIntakeFood"]?.toDouble(),
    totalBurnedByExercise: json["totalBurnedByExercise"]?.toDouble(),
    totalIntakeFat: json["totalIntakeFat"]?.toDouble(),
    totalIntakeProtein: json["totalIntakeProtein"]?.toDouble(),
    totalIntakeCarbs: json["totalIntakeCarbs"]?.toDouble(),
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
    "totalIntakeFat": totalIntakeFat,
    "totalIntakeProtein": totalIntakeProtein,
    "totalIntakeCarbs": totalIntakeCarbs,
  };
}
