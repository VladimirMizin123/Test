import 'dart:convert';

GetProfileDetailsResponseModel getProfileDetailsResponseModelFromJson(
        String str) =>
    GetProfileDetailsResponseModel.fromJson(json.decode(str));

String getProfileDetailsResponseModelToJson(
        GetProfileDetailsResponseModel data) =>
    json.encode(data.toJson());

class GetProfileDetailsResponseModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  ProfileDetails? data;

  GetProfileDetailsResponseModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetProfileDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetProfileDetailsResponseModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data:
            json["data"] == null ? null : ProfileDetails.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class ProfileDetails {
  String? firstName;
  String? lastName;
  int? goal;
  String? id;
  String? userId;
  int? weightInLb;
  int? targetWeightInLb;
  double? heightInCm;
  String? birthDate;
  String? gender;

  ProfileDetails({
    this.firstName,
    this.lastName,
    this.goal,
    this.id,
    this.userId,
    this.weightInLb,
    this.targetWeightInLb,
    this.heightInCm,
    this.birthDate,
    this.gender,
  });

  factory ProfileDetails.fromJson(Map<String, dynamic> json) => ProfileDetails(
        firstName: json["firstName"],
        lastName: json["lastName"],
        goal: json["goal"],
        id: json["id"],
        userId: json["userId"],
        weightInLb: json["weightInLb"],
        targetWeightInLb: json["targetWeightInLb"],
        heightInCm: json["heightInCm"]?.toDouble(),
        birthDate: json["birthDate"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "goal": goal,
        "id": id,
        "userId": userId,
        "weightInLb": weightInLb,
        "targetWeightInLb": targetWeightInLb,
        "heightInCm": heightInCm,
        "birthDate": birthDate,
        "gender": gender,
      };
}
