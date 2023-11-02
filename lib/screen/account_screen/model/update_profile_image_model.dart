import 'dart:convert';

UpdateProfileImageResponseModel updateProfileImageResponseModelFromJson(
        String str) =>
    UpdateProfileImageResponseModel.fromJson(json.decode(str));

String updateProfileImageResponseModelToJson(
        UpdateProfileImageResponseModel data) =>
    json.encode(data.toJson());

class UpdateProfileImageResponseModel {
  bool? success;
  String? message;
  dynamic errorMessage;
  dynamic data;

  UpdateProfileImageResponseModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory UpdateProfileImageResponseModel.fromJson(Map<String, dynamic> json) =>
      UpdateProfileImageResponseModel(
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
