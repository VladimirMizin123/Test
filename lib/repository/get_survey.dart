import 'dart:convert';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';

import '../app/functions.dart';
import '../models/error_model.dart';
import '../models/get_survey_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class GetSurveyRepository {
  final ApiServices apiServices = ApiServices();

  Future<Either<ErrorModel , GetSurveyModel>> getSurvey() async {
    final response = await apiServices.get(
      ApiUrls.getSurvey,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // int count = getListCount(jsonDecode(response.body['data']));
      // debugPrint("count --> $count");
      return Right(GetSurveyModel.fromJson(jsonDecode(response.body)) );
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
