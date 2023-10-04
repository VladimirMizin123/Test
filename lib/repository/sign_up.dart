import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
import 'package:gymeats_mobile/models/success_model.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/get_all_restriction_modal.dart';
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
      var multipartFileImage = http.MultipartFile('profileImage', stream, length, filename: model.userProfileImage!.path, contentType: MediaType('image', model.userProfileImage!.path.split('/').last.split('.').last == 'png' ? 'png' : 'jpeg'));

      profileImage.add(multipartFileImage);
    }

    Map<String, String> data = {
      "FirstName": model.firstName!,
      "LastName": model.lastName!,
      "Email": model.email!,
      "UserName": model.email!,
      "Password": model.password!,
      "ConfirmPassword": model.confirmPassword!,
      "UserDetail.Age": model.age!,
      "UserDetail.Height": model.height!,
      "UserDetail.Weight": model.weight!,
      "UserDetail.Gender": model.gender! == StringUtils.male
          ? 'Male'
          : model.gender! == StringUtils.female
              ? 'Female'
              : 'Non-binary',
      "UserDetail.SurveyId": model.surveyId!,
      "UserDetail.DietId": model.dietId!,
      "UserAddress.Latitude": model.latitude!,
      "UserAddress.Longitude": model.longitude!,
    };
    final response = await apiServices.postMultipart(url: ApiUrls.register, body: data, files: profileImage);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SignUpModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, CheckEmailExist>> checkIsEmailExist(String email) async {
    final response = await apiServices.get(
      '${ApiUrls.checkEmail}/$email',
    );
    print("responseCheckEmail : ${response.body}");
    print("responseCheckEmail statusCode: ${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(CheckEmailExist.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, FetchMealPlanModel>> fetchMealPlan(String userID) async {
    // int mealPlanScreenCountState = PreferenceUtils.getInt(userMealPlanCountState);
    String apiURL = '';
    // if (mealPlanScreenCountState == 0) {
    apiURL = '${ApiUrls.genMealPlan}/$userID';
    print('genMealPlan apiURL : $apiURL');
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

  Future<Either<ErrorModel, SuccessModel>> addUserRestriction({List<String> restrictionList = const []}) async {
    final response = await apiServices.post('${ApiUrls.addRestrictionAndGetMealPlan}/$userID', restrictionList);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
