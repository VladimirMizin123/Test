// To parse this JSON data, do
//
//     final getCurrentProgramResponseModel = getCurrentProgramResponseModelFromJson(jsonString);

import 'dart:convert';

GetCurrentProgramResponseModel getCurrentProgramResponseModelFromJson(
        String str) =>
    GetCurrentProgramResponseModel.fromJson(json.decode(str));

String getCurrentProgramResponseModelToJson(
        GetCurrentProgramResponseModel data) =>
    json.encode(data.toJson());

class GetCurrentProgramResponseModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  Data? data;

  GetCurrentProgramResponseModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetCurrentProgramResponseModel.fromJson(Map<String, dynamic> json) =>
      GetCurrentProgramResponseModel(
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
  MyProgram? myProfile;

  Data({
    this.myProfile,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        myProfile: json["myProfile"] == null
            ? null
            : MyProgram.fromJson(json["myProfile"]),
      );

  Map<String, dynamic> toJson() => {
        "myProfile": myProfile?.toJson(),
      };
}

class MyProgram {
  String? id;
  String? programName;
  String? language;
  Program? program;
  String? programIcon;

  MyProgram(
      {this.id,
      this.programName,
      this.language,
      this.program,
      this.programIcon});

  factory MyProgram.fromJson(Map<String, dynamic> json) => MyProgram(
        id: json["id"],
        programName: json["programName"],
        language: json["language"],
        programIcon: json["programIcon"],
        program:
            json["program"] == null ? null : Program.fromJson(json["program"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "programName": programName,
        "language": language,
        "programIcon": programIcon,
        "program": program?.toJson(),
      };
}

class Program {
  String? databaseId;
  String? backgroundImage;
  String? name;
  String? author;

  Program({
    this.databaseId,
    this.backgroundImage,
    this.name,
    this.author,
  });

  factory Program.fromJson(Map<String, dynamic> json) => Program(
        databaseId: json["databaseId"],
        backgroundImage: json["backgroundImage"],
        name: json["name"],
        author: json["author"],
      );

  Map<String, dynamic> toJson() => {
        "databaseId": databaseId,
        "backgroundImage": backgroundImage,
        "name": name,
        "author": author,
      };
}
