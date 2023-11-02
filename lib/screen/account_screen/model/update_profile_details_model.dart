import 'dart:convert';

UpdateProfileDetailsResponseModel updateProfileDetailsResponseModelFromJson(
        String str) =>
    UpdateProfileDetailsResponseModel.fromJson(json.decode(str));

String updateProfileDetailsResponseModelToJson(
        UpdateProfileDetailsResponseModel data) =>
    json.encode(data.toJson());

class UpdateProfileDetailsResponseModel {
  bool? success;
  String? message;
  dynamic errorMessage;
  UpdatedProfileDetails? data;

  UpdateProfileDetailsResponseModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory UpdateProfileDetailsResponseModel.fromJson(
          Map<String, dynamic> json) =>
      UpdateProfileDetailsResponseModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null
            ? null
            : UpdatedProfileDetails.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class UpdatedProfileDetails {
  String? firstName;
  String? lastName;
  int? goal;
  int? weight;
  int? targetWeight;
  double? heightInCm;
  String? birthDate;
  String? gender;

  UpdatedProfileDetails({
    this.firstName,
    this.lastName,
    this.goal,
    this.weight,
    this.targetWeight,
    this.heightInCm,
    this.birthDate,
    this.gender,
  });

  factory UpdatedProfileDetails.fromJson(Map<String, dynamic> json) =>
      UpdatedProfileDetails(
        firstName: json["firstName"],
        lastName: json["lastName"],
        goal: json["goal"],
        weight: json["weight"],
        targetWeight: json["targetWeight"],
        heightInCm: json["heightInCm"]?.toDouble(),
        birthDate: json["birthDate"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "goal": goal,
        "weight": weight,
        "targetWeight": targetWeight,
        "heightInCm": heightInCm,
        "birthDate": birthDate,
        "gender": gender,
      };
}
