// To parse this JSON data, do
//
//     final getUserRestrictionModal = getUserRestrictionModalFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetUserRestrictionModal getUserRestrictionModalFromJson(String str) => GetUserRestrictionModal.fromJson(json.decode(str));

String getUserRestrictionModalToJson(GetUserRestrictionModal data) => json.encode(data.toJson());

class GetUserRestrictionModal {
  final bool success;
  final dynamic message;
  final dynamic errorMessage;
  final List<UserRestrictionData> data;

  GetUserRestrictionModal({
    required this.success,
    required this.message,
    required this.errorMessage,
    required this.data,
  });

  factory GetUserRestrictionModal.fromJson(Map<String, dynamic> json) => GetUserRestrictionModal(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: List<UserRestrictionData>.from(json["data"].map((x) => UserRestrictionData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class UserRestrictionData {
  final String id;
  final String name;
  final bool isOnProgram;
  final String subcategory;
  final String slugname;

  UserRestrictionData({
    required this.id,
    required this.name,
    required this.isOnProgram,
    required this.subcategory,
    required this.slugname,
  });

  factory UserRestrictionData.fromJson(Map<String, dynamic> json) => UserRestrictionData(
        id: json["id"],
        name: json["name"],
        isOnProgram: json["isOnProgram"],
        subcategory: json["subcategory"],
        slugname: json["slugname"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isOnProgram": isOnProgram,
        "subcategory": subcategory,
        "slugname": slugname,
      };
}
