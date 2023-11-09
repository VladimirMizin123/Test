import 'dart:convert';

UpdateUnitInfoResponseModel updateUnitInfoResponseModelFromJson(String str) =>
    UpdateUnitInfoResponseModel.fromJson(json.decode(str));

String updateUnitInfoResponseModelToJson(UpdateUnitInfoResponseModel data) =>
    json.encode(data.toJson());

class UpdateUnitInfoResponseModel {
  bool? success;
  String? message;
  dynamic errorMessage;
  bool? data;

  UpdateUnitInfoResponseModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory UpdateUnitInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      UpdateUnitInfoResponseModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data,
      };
}
