import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
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

    log('model.phoneNumber---------->>>>>> ${model.phoneNumber}');

    Map<String, String> data = {
      "FirstName": model.firstName!,
      "LastName": model.lastName!,
      "Email": model.email!,
      "UserName": model.email!,
      "Password": model.password!,
      "ConfirmPassword": model.confirmPassword!,
      "PhoneNumber": model.phoneNumber!,
      "UserDetail.Age": model.age!,
      "UserDetail.Height": model.height!,
      "UserDetail.Weight": model.weight!,
      "UserDetail.Gender": model.gender! == StringUtils.male
          ? 'Male'
          : model.gender! == StringUtils.female
              ? 'Female'
              : 'Non-binary',
      "UserDetail.SurveyId": model.surveyId ?? '',
      "UserDetail.DietId": model.dietId ?? "",
      "UserAddress.Latitude":
          model.addAddressModel?.latitude?.toStringAsFixed(6).toString() ??
              model.latitude ??
              '0.0',
      "UserAddress.Longitude":
          model.addAddressModel?.longitude?.toStringAsFixed(6).toString() ??
              model.longitude ??
              "0.0",
      "UserAddress.Street_Num": model.addAddressModel?.streetNum ?? "",
      "UserAddress.Street_Name": model.addAddressModel?.streetName ?? "",
      "UserAddress.City": model.addAddressModel?.city ?? "",
      "UserAddress.State": model.addAddressModel?.state ?? "",
      "UserAddress.Country": model.addAddressModel?.country ?? "",
      "UserAddress.Zipcode": model.addAddressModel?.zipcode ?? "",
    };
    log("DATA:----------> ${jsonEncode(data)}");
    final response = await apiServices.postMultipart(
        url: ApiUrls.register, body: data, files: profileImage);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('SIGNUP RESPOSNE :::::::::  ${jsonDecode(response.body)}');
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
    final response = await apiServices.post(
        '${ApiUrls.addRestrictionAndGetMealPlan}/$userid', restrictionList);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
