import 'dart:io';

import 'get_survey_model.dart';

class UserSignUpDataModel {
  String? confirmPassword;
  String? email;
  String? firstName;
  String? lastName;
  String? password;
  String? userName;
  String? age;
  String? gender;
  String? height;
  String? weight;
  String? surveyId;
  String? dietId;
  String? latitude;
  String? longitude;
  File? userProfileImage;
  List<String>? options;

  UserSignUpDataModel(
      {this.gender,
      this.height,
      this.email,
      this.confirmPassword,
      this.password,
      this.age,
      this.dietId,
      this.firstName,
      this.lastName,
      this.latitude,
      this.longitude,
      this.surveyId,
      this.userName,
      this.weight,
      this.userProfileImage,
      this.options});
}
