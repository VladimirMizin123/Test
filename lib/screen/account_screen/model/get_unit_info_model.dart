import 'dart:convert';

GetUnitInfoResponseModel getUnitInfoResponseModelFromJson(String str) =>
    GetUnitInfoResponseModel.fromJson(json.decode(str));

String getUnitInfoResponseModelToJson(GetUnitInfoResponseModel data) =>
    json.encode(data.toJson());

class GetUnitInfoResponseModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  UnitData? data;

  GetUnitInfoResponseModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetUnitInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      GetUnitInfoResponseModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null ? null : UnitData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class UnitData {
  String? unitId;
  String? weightType;
  String? heightType;
  String? energyType;
  String? waterType;
  String? userId;

  UnitData({
    this.unitId,
    this.weightType,
    this.heightType,
    this.energyType,
    this.waterType,
    this.userId,
  });

  factory UnitData.fromJson(Map<String, dynamic> json) => UnitData(
        unitId: json["unitId"],
        weightType: json["weightType"],
        heightType: json["heightType"],
        energyType: json["energyType"],
        waterType: json["waterType"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "unitId": unitId,
        "weightType": weightType,
        "heightType": heightType,
        "energyType": energyType,
        "waterType": waterType,
        "userId": userId,
      };
}
