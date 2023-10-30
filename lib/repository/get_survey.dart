import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/get_all_diet_model.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/model/get_all_restriction_modal.dart';

import '../models/error_model.dart';
import '../models/get_survey_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class GetSurveyRepository {
  final ApiServices apiServices = ApiServices();

  Future<Either<ErrorModel, GetSurveyModel>> getSurvey() async {
    final response = await apiServices.get(
      ApiUrls.getSurvey,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // int count = getListCount(jsonDecode(response.body['data']));
      // debugPrint("count --> $count");
      return Right(GetSurveyModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, GetAllRestrictionModal>> getAllRestriction() async {
    final response = await apiServices.get(ApiUrls.getAllRestrictionList);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // int count = getListCount(jsonDecode(response.body['data']));
      // debugPrint("count --> $count");
      return Right(GetAllRestrictionModal.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, GetAllDietModel>> getDietPlan() async {
    final response = await apiServices.get(ApiUrls.getDietList);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // int count = getListCount(jsonDecode(response.body['data']));
      // debugPrint("count --> $count");
      return Right(GetAllDietModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
