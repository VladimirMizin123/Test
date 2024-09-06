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
  String? phoneNumber;
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
    this.phoneNumber,
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
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        phoneNumber: json["phoneNumber"] ?? "",
        goal: json["goal"] is List
            ? (json["goal"] as List).isNotEmpty
                ? getData((json["goal"] as List).first)
                : 0
            : json["goal"],
        id: json["id"] ?? '',
        userId: json["userId"] ?? '',
        weightInLb: json["weightInLb"].round(),
        targetWeightInLb: json["targetWeightInLb"].round(),
        heightInCm: json["heightInCm"]?.toDouble(),
        birthDate: json["birthDate"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "goal": goal,
        "id": id,
        "userId": userId,
        "weightInLb": weightInLb,
        "targetWeightInLb": targetWeightInLb,
        "heightInCm": heightInCm,
        "birthDate": birthDate,
        "gender": gender,
      };

  static int? getData(String data) {
    if (int.tryParse(data) != null) {
      return int.parse(data);
    }
    switch (data) {
      case "LoseWeight":
        return 0;
      case "GainLeanMuscle":
        return 1;
      case "ToneUp":
        return 2;
      case "MaintainHealthyDiet":
        return 3;
      default:
        return null;
    }
  }
}
