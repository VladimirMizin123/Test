import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/models/fetch_meal_plan_model.dart';
import 'package:gymeats_mobile/models/skip_meal_plan_model.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';

class MealPlanRepository {
  final ApiServices apiServices = ApiServices();

  int mealPlanScreenCountState = 1; // PreferenceUtils.getInt(userMealPlanCountState);

  Future<Either<ErrorModel, FetchMealPlanModel>> fetchMealPlan({required String userID}) async {
    String apiURL = '';
    if (mealPlanScreenCountState == 0) {
      apiURL = '${ApiUrls.genMealPlan}/$userID';
    } else {
      apiURL = '${ApiUrls.getMealPlan}/$userID';
    }
    final response = await apiServices.get(apiURL);
    if (response.statusCode == 200 || response.statusCode == 201) {
      await PreferenceUtils.setInt(userMealPlanCountState, 1);
      return Right(FetchMealPlanModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, SkipMealPlanModel>> skipMealPlan({required String userID, required String mealID}) async {
    final response = await apiServices.get('${ApiUrls.skipMeal}/$userID?mealId=$mealID');
    log('eitherv response --> $response');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SkipMealPlanModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
