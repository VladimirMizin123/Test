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

  factory GetDashboardModel.fromJson(Map<String, dynamic> json) =>
      GetDashboardModel(
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
  num? totalCalorie;
  num? totalProtein;
  num? totalFat;
  num? totalCarbs;
  num? dailyWaterGoals;
  num? dailyExerciseGoals;
  num? totalIntakeWater;
  num? totalIntakeFood;
  num? totalBurnedByExercise;
  num? totalIntakeFat;
  num? totalIntakeProtein;
  num? totalIntakeCarbs;

  Data({
    this.totalCalorie = 0,
    this.totalProtein = 0,
    this.totalFat = 0,
    this.totalCarbs = 0,
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
        totalCalorie: json["toatalCalorie"],
        totalProtein: json["totalProtein"],
        totalFat: json["totalFat"],
        totalCarbs: json["totalCarbs"],
        dailyWaterGoals: json["dailyWaterGoals"] ?? 0,
        dailyExerciseGoals: json["dailyExerciseGoals"] ?? 0,
        totalIntakeWater: json["totalIntakeWater"],
        totalIntakeFood: json["totalIntakeFood"],
        totalBurnedByExercise: json["totalBurnedByExercise"],
        totalIntakeFat: json["totalIntakeFat"],
        totalIntakeProtein: json["totalIntakeProtein"],
        totalIntakeCarbs: json["totalIntakeCarbs"],
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
