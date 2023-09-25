import 'dart:convert';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app/functions.dart';
import '../app/sharedPrefrence.dart';
import '../models/error_model.dart';
import '../models/get_survey_model.dart';
import '../models/login_model.dart';
import '../models/success_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class ForgotPasswordRepository {
  final ApiServices apiServices = ApiServices();

  Future<Either<ErrorModel, SuccessModel>> forgotPassword(
      {required String email}) async {
    final data = {
      'email': email.trim(),
    };
    final response = await apiServices.post(ApiUrls.requestPass, data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // create dynamic link
      PreferenceUtils.setString(
          forgetPassToken, jsonDecode(response.body)['data']);
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
//366a2edc-445e-4ef2-ae71-90b236588302
