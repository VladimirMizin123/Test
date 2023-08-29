import 'dart:convert';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';

import '../app/functions.dart';
import '../models/error_model.dart';
import '../models/get_dashboard_model.dart';
import '../models/get_survey_model.dart';
import '../models/success_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class AddEatenMealRepository {
  final ApiServices apiServices = ApiServices();

  Future<Either<ErrorModel , SuccessModel>> addEatenMeal({required String mealId,required String userId,}) async {
    Map<String, dynamic> data= {
      'mealId' : mealId,
      'userId' : userId
    };
    final response = await apiServices.post(
      ApiUrls.addEatenMeal,
      data
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)) );
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
