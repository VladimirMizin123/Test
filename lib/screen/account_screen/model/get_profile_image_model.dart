import 'dart:convert';

GetProfileImageResponseModel getProfileImageResponseModelFromJson(String str) =>
    GetProfileImageResponseModel.fromJson(json.decode(str));

String getProfileImageResponseModelToJson(GetProfileImageResponseModel data) =>
    json.encode(data.toJson());

class GetProfileImageResponseModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  ImageData? data;

  GetProfileImageResponseModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetProfileImageResponseModel.fromJson(Map<String, dynamic> json) =>
      GetProfileImageResponseModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null ? null : ImageData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class ImageData {
  String? imageUrl;

  ImageData({
    this.imageUrl,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "imageUrl": imageUrl,
      };
}
