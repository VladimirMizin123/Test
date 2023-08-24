/*
import 'dart:convert';
import 'dart:io';

import '../models/error_model.dart';
import '../models/sign_up_model.dart';
import '../service/api_responses.dart';
import '../service/apis.dart';

class AuthRepository {
  final ApiServices apiServices = ApiServices();

  Future<ApiResponse<SignUpModel, ErrorModel>> signup(
      {required String phoneNumber,
      required String password,
      required String password1,
      required String password2,
      required String password3,
      required String password4}) async {
    final response = await apiServices.post(
      '/auth/create-account',
      {
        'firstName': phoneNumber,
        'lastName': password,
        'password': password,
        'userName': password,
        'email': password,
        'confirmPassword': password,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse<SignUpModel, ErrorModel>.completed(
          SignUpModel.fromJson(jsonDecode(response.body)));
    } else {
      return ApiResponse<SignUpModel, ErrorModel>.error(
          ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
*/

import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/constant/app_string.dart';

import '../app/sharedPrefrence.dart';
import '../models/error_model.dart';
import '../models/sign_up_data_navigate_model.dart';
import '../models/sign_up_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class SignUpRepository {
  final ApiServices apiServices = ApiServices();

  Future<Either<ErrorModel, SignUpModel>> signUp({
    required UserSignUpDataModel model,
  }) async {
    List<http.MultipartFile> profileImage = [];
    if(model.userProfileImage!=null){
      var stream = http.ByteStream(model.userProfileImage!.openRead());
      stream.cast();
      var length = await model.userProfileImage!.length();
      var multipartFileImage = http.MultipartFile('profileImage', stream, length,
          filename: model.userProfileImage!.path,contentType: MediaType('image', model.userProfileImage!.path.split('/').last.split('.').last == 'png' ? 'png' :'jpeg'));

      profileImage.add(multipartFileImage);
    }

    Map<String, String> data = {
      "FirstName": model.firstName!,
      "LastName": model.lastName!,
      "Email": model.email!,
      "Password": model.password!,
      "ConfirmPassword": model.confirmPassword!,

        "UserDetail.Age": model.age!,
        "UserDetail.Calories": '0',
        "UserDetail.Height": model.height!,
        "UserDetail.Weight": model.weight!,
        "UserDetail.Gender": model.gender! == AppStrings.male ? 'Male' : model.gender! == AppStrings.female ? 'Female' : 'Non-binary',
        "UserDetail.SurveyId": model.surveyId!,
        "UserDetail.DietId": model.dietId!,

        "UserAddress.Latitude": model.latitude!,
        "UserAddress.Longitude": model.longitude!,

    };
    /*    Map<String, String> data = {
      "firstName": model.firstName!,
      "lastName": model.lastName!,
      "userName": model.userName!,
      "email": model.email!,
      "password": model.password!,
      "confirmPassword": model.confirmPassword!,
      "userDetail": json.encode({
        "age": model.age!,
        "height": model.height!,
        "weight": model.weight!,
        "gender": model.gender! == AppStrings.male ? 'Male' : model.gender! == AppStrings.female ? 'Female' : 'Non-binary',
        "surveyId": model.surveyId!,
        "dietId": model.dietId!,
      }),
      "userAddress":  json.encode( {
        "latitude": model.latitude!,
        "longitude": model.longitude!,
      })
    };*/
    final response = await apiServices.postMultipart(url: ApiUrls.register, body: data,files: profileImage);
    if (response.statusCode == 200 || response.statusCode == 201) {
      await PreferenceUtils.setBool(prefIsLogin, true);
      return Right(SignUpModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
