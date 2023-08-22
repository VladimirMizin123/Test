import 'dart:convert';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';

import '../app/functions.dart';
import '../app/sharedPrefrence.dart';
import '../models/error_model.dart';
import '../models/get_survey_model.dart';
import '../models/login_model.dart';
import '../models/success_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class ResetPasswordRepository {
  final ApiServices apiServices = ApiServices();

  Future<Either<ErrorModel, SuccessModel>> resetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    final data = {
      'confirmPassword': confirmPassword,
      'password': newPassword,
      'passwordResetToken': PreferenceUtils.getString(passwordResetToken),
    };
    final response = await apiServices.post(ApiUrls.resetPass, data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
