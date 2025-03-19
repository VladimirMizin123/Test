import 'dart:io';

import 'package:gymeats_mobile/models/add_address_data_navigate_model.dart';
import 'package:gymeats_mobile/screen/user_survey/user_survey_screen.dart';

class UserSignUpDataModel {
  String? confirmPassword;
  String? email;
  String? userId;
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
  Map<String, dynamic>? surveyReq;
  String? referralCode;

  UserSignUpDataModel({
    this.gender = "",
    this.height = "",
    this.email = "",
    this.userId,
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
    this.surveyReq,
    this.referralCode,
  });
}

class PurchaseDetails {
  bool pendingCompletePurchase;
  String productID;
  String purchaseID;
  String status;
  String email;
  String transactionDate;
  String localVerificationData;
  String serverVerificationData;
  String source;

  PurchaseDetails({
    required this.pendingCompletePurchase,
    required this.productID,
    required this.purchaseID,
    required this.status,
    required this.email,
    required this.transactionDate,
    required this.localVerificationData,
    required this.serverVerificationData,
    required this.source,
  });
}
