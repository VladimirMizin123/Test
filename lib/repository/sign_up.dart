import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/controller/home_screen_controller.dart';
import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
import 'package:gymeats_mobile/models/login_model.dart';
import 'package:gymeats_mobile/models/success_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../app/sharedPrefrence.dart';
import '../constant/string_utils.dart';
import '../models/check_email_exist_model.dart';
import '../models/error_model.dart';
import '../models/sign_up_data_navigate_model.dart';
import '../models/sign_up_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class SignUpRepository {
  final ApiServices apiServices = ApiServices();

  String userID = PreferenceUtils.getString(prefUserData);

  Future<Either<ErrorModel, SignUpModel>> signUp({
    required UserSignUpDataModel model,
  }) async {
    List<http.MultipartFile> profileImage = [];
    if (model.userProfileImage != null) {
      var stream = http.ByteStream(model.userProfileImage!.openRead());
      stream.cast();
      var length = await model.userProfileImage!.length();
      var multipartFileImage = http.MultipartFile(
          'profileImage', stream, length,
          filename: model.userProfileImage!.path,
          contentType: MediaType(
              'image',
              model.userProfileImage!.path.split('/').last.split('.').last ==
                      'png'
                  ? 'png'
                  : 'jpeg'));

      profileImage.add(multipartFileImage);
    }
    HomeScreenController homeScreenController =
        Get.find<HomeScreenController>();
    List<int?> goalList = dialGoalList
        .asMap()
        .map((i, e) {
          return MapEntry(i, homeScreenController.selectedItems[i] ? i : null);
        })
        .values
        .toList();

    log('model.phoneNumber---------->>>>>> ${model.phoneNumber}');
    Map<String, dynamic>? dietMap = model.surveyReq?["surveyDetails"]?["diet"];
    Map<String, dynamic>? allergyMap =
        model.surveyReq?["surveyDetails"]?["allergy"];
    Map<String, dynamic>? healthMap =
        model.surveyReq?["surveyDetails"]?["health"];
    Map<String, dynamic>? medicationMap =
        model.surveyReq?["surveyDetails"]?["medication"];
    log(model.surveyReq.toString());

    Map<String, String> data = {
      "FirstName": model.firstName ?? "",
      "LastName": model.lastName ?? "",
      "Email": model.email ?? "",
      "UserName": model.email ?? "",
      "PhoneNumber": model.phoneNumber ?? "",
      "ReferalCode": model.referralCode ?? "",
      "UserDetail.Age": model.age ?? "",
      "UserDetail.Height":
          model.height?.replaceAll("'", ".").replaceAll("’", ".") ?? "",
      "UserDetail.Weight": model.weight ?? "",
      "UserDetail.Gender": model.gender! == StringUtils.male
          ? 'Male'
          : model.gender! == StringUtils.female
              ? 'Female'
              : 'Non-binary',
      "UserDetail.SurveyId": model.surveyId ?? '',
      "UserDetail.DietId": model.dietId ?? "",
      // !
      "UserDetail.SurveyDetails.Diet.Id": dietMap?["id"] ?? "null",
      "UserDetail.SurveyDetails.Diet.Label": dietMap?["label"] ?? "null",

      "UserDetail.SurveyDetails.Allergy.Id": allergyMap?["id"] ?? "null",
      "UserDetail.SurveyDetails.Allergy.Label": allergyMap?["label"] ?? "null",

      "UserDetail.SurveyDetails.Health.Id": healthMap?["id"] ?? "null",
      "UserDetail.SurveyDetails.Health.Label": healthMap?["label"] ?? "null",

      "UserDetail.SurveyDetails.Medication.Id": medicationMap?["id"] ?? "null",
      "UserDetail.SurveyDetails.Medication.Label":
          medicationMap?["label"] ?? "null",
      // !
      "UserAddress.Latitude":
          model.latitude == "null" ? "0.0" : model.latitude ?? '0.0',
      "UserAddress.Longitude":
          model.longitude == "null" ? "0.0" : model.longitude ?? "0.0",
      "UserAddress.Street_Num": model.addAddressModel?.streetNum ?? "",
      "UserAddress.Street_Name": model.addAddressModel?.streetName ?? "",
      "UserAddress.City": model.addAddressModel?.city ?? "",
      "UserAddress.State": model.addAddressModel?.state ?? "",
      "UserAddress.Country": model.addAddressModel?.country ?? "",
      "UserAddress.Zipcode": model.addAddressModel?.zipcode ?? "",
      "UserAddress.addressType": model.addAddressModel?.addressType ?? "",
      "UserAddress.ExtendedAddress": model.addAddressModel?.floor ?? "",
      "DietGoal":
          "${goalList.firstWhereOrNull((element) => element != null) ?? 0}",
    };
    data.addIf(model.userId != null, "UserId", model.userId ?? '');
    List dietOption =
        dietMap?["options"] is List ? (dietMap?["options"] as List) : [];
    List allergyOption =
        allergyMap?["options"] is List ? (allergyMap?["options"] as List) : [];
    List healthOption =
        healthMap?["options"] is List ? (healthMap?["options"] as List) : [];
    List medicationOption = medicationMap?["options"] is List
        ? (medicationMap?["options"] as List)
        : [];
    if (dietOption.isNotEmpty) {
      for (var i = 0; i < dietOption.length; i++) {
        data.addAll(
            {"UserDetail.SurveyDetails.Diet.Options[$i]": dietOption[i]});
      }
    } else {
      data.addAll({"UserDetail.SurveyDetails.Diet.Options": ""});
    }

    if (allergyOption.isNotEmpty) {
      for (var i = 0; i < allergyOption.length; i++) {
        data.addAll(
            {"UserDetail.SurveyDetails.Allergy.Options[$i]": allergyOption[i]});
      }
    } else {
      data.addAll({"UserDetail.SurveyDetails.Allergy.Options": ""});
    }
    if (allergyOption.isNotEmpty) {
      for (var i = 0; i < healthOption.length; i++) {
        data.addAll(
            {"UserDetail.SurveyDetails.Health.Options[$i]": healthOption[i]});
      }
    } else {
      data.addAll({"UserDetail.SurveyDetails.Health.Options": ""});
    }

    if (medicationOption.isNotEmpty) {
      for (var i = 0; i < medicationOption.length; i++) {
        data.addAll({
          "UserDetail.SurveyDetails.Medication.Options[$i]": medicationOption[i]
        });
      }
    } else {
      data.addAll({"UserDetail.SurveyDetails.Medication.Options": ""});
    }

    log("---------->DATA:----------> ${jsonEncode(data)}---------->");
    log("----Api Url : ${ApiUrls.authUpdateProfileDetails}");

    final response = await apiServices.postMultipart(
        url: ApiUrls.authUpdateProfileDetails, body: data, files: profileImage);
    log("Response : ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SignUpModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, CheckEmailExist>> checkIsEmailExist(
      String email) async {
    final response = await apiServices.get(
      '${ApiUrls.checkEmail}/$email',
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(CheckEmailExist.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, FetchMealPlanModel>> fetchMealPlan(
      String userID) async {
    // int mealPlanScreenCountState = PreferenceUtils.getInt(userMealPlanCountState);
    String apiURL = '';
    // if (mealPlanScreenCountState == 0) {
    apiURL = '${ApiUrls.genMealPlan}/$userID';

    // } else {
    //   apiURL = '${ApiUrls.getMealPlan}/$userID';
    //   print('getMealPlan apiURL : $apiURL');
    // }
    final response = await apiServices.get(apiURL);
    if (response.statusCode == 200 || response.statusCode == 201) {
      await PreferenceUtils.setInt(userMealPlanCountState, 1);
      return Right(FetchMealPlanModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 401) {
      PreferenceUtils.clearPrefs();
      Get.offAllNamed('/LoginScreen');

      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, SuccessModel>> addUserRestriction(
      {List<String> restrictionList = const [], String? userid}) async {
    log("Api : ${'${ApiUrls.addRestrictionAndGetMealPlan}/$userid'}");
    log("Restriction List : $restrictionList");
    final response = await apiServices.post(
        '${ApiUrls.addRestrictionAndGetMealPlan}/$userid', restrictionList);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, LoginModel>> registerUser(
      Map<String, String> requestData) async {
    try {
      final response =
          await apiServices.post(ApiUrls.registerUser, requestData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(LoginModel.fromJson(jsonDecode(response.body)));
      } else {
        return Left(ErrorModel.fromJson(jsonDecode(response.body)));
      }
    } catch (e) {
      return Left(ErrorModel.fromJson({"message": e.toString()}));
    }
  }
}
