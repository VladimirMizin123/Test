import 'dart:convert';

ChangePasswordResponseModel changePasswordResponseModelFromJson(String str) =>
    ChangePasswordResponseModel.fromJson(json.decode(str));

String changePasswordResponseModelToJson(ChangePasswordResponseModel data) =>
    json.encode(data.toJson());

class ChangePasswordResponseModel {
  bool? success;
  String? message;
  String? errorMessage;
  String? data;

  ChangePasswordResponseModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      ChangePasswordResponseModel(
        success: json["success"],
        message: json["message"] ?? "",
        errorMessage: json["errorMessage"] ?? "",
        data: json["data"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data,
      };
}
