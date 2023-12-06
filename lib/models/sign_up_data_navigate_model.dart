import 'dart:io';

import 'package:gymeats_mobile/models/add_address_data_navigate_model.dart';
import 'package:gymeats_mobile/screen/user_survey/user_survey_screen.dart';

class UserSignUpDataModel {
  String? confirmPassword;
  String? email;
  String? firstName;
  String? lastName;
  String? password;
  String? phoneNumber;
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
  List<CustomOptions>? options;
  List<String> restrictionID;
  AddAddressModel? addAddressModel;

  UserSignUpDataModel({
    this.gender = "",
    this.height = "",
    this.email = "",
    this.confirmPassword = "",
    this.password = "",
    this.phoneNumber = "",
    this.age = "",
    this.dietId = "",
    this.firstName = "",
    this.lastName = "",
    this.latitude = "",
    this.longitude = "",
    this.surveyId = "",
    this.userName = "",
    this.weight = "",
    this.userProfileImage,
    this.restrictionID = const [],
    this.options,
    this.addAddressModel,
  });
}
