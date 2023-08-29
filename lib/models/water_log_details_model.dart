class WaterLogDetailsModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  WaterData? data;

  WaterLogDetailsModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory WaterLogDetailsModel.fromJson(Map<String, dynamic> json) => WaterLogDetailsModel(
    success: json["success"],
    message: json["message"],
    errorMessage: json["errorMessage"],
    data: json["data"] == null ? null : WaterData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "errorMessage": errorMessage,
    "data": data?.toJson(),
  };
}

class WaterData {
  int? totalWaterIntake;
  List<dynamic>? waterLogDetails;

  WaterData({
    this.totalWaterIntake,
    this.waterLogDetails,
  });

  factory WaterData.fromJson(Map<String, dynamic> json) => WaterData(
    totalWaterIntake: json["totalWaterIntake"],
    waterLogDetails: json["waterLogDetails"] == null ? [] : List<dynamic>.from(json["waterLogDetails"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "totalWaterIntake": totalWaterIntake,
    "waterLogDetails": waterLogDetails == null ? [] : List<dynamic>.from(waterLogDetails!.map((x) => x)),
  };
}
