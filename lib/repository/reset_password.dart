import 'dart:convert';

import 'package:either_dart/either.dart';

import '../models/error_model.dart';
import '../models/success_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class ResetPasswordRepository {
  final ApiServices apiServices = ApiServices();

  Future<Either<ErrorModel, SuccessModel>> resetPassword({
    required String newPassword,
    required String confirmPassword,
    required String passwordResetToken,
  }) async {
    final data = {
      'confirmPassword': confirmPassword,
      'password': newPassword,
      'passwordResetToken': passwordResetToken,
    };
    final response = await apiServices.post(ApiUrls.resetPass, data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
