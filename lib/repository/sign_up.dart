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
