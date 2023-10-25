// To parse this JSON data, do
//
//     final getCousinesListModel = getCousinesListModelFromJson(jsonString);

import 'dart:convert';

GetCousinesListModel getCousinesListModelFromJson(String str) =>
    GetCousinesListModel.fromJson(json.decode(str));

String getCousinesListModelToJson(GetCousinesListModel data) =>
    json.encode(data.toJson());

class GetCousinesListModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  CousinesList? data;

  GetCousinesListModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetCousinesListModel.fromJson(Map<String, dynamic> json) =>
      GetCousinesListModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null ? null : CousinesList.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class CousinesList {
  List<String>? cousines;

  CousinesList({
    this.cousines,
  });

  factory CousinesList.fromJson(Map<String, dynamic> json) => CousinesList(
        cousines: json["cousines"] == null
            ? []
            : List<String>.from(json["cousines"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "cousines":
            cousines == null ? [] : List<dynamic>.from(cousines!.map((x) => x)),
      };
}
