import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/models/daily_recap_modal.dart';

import '../models/error_model.dart';
import '../models/success_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class AddEatenMealRepository {
  final ApiServices apiServices = ApiServices();

  String userID = PreferenceUtils.getString(prefUserData);
  // String userID = '2b85411b-3c0c-424b-98e0-6534a5216726';

  Future<Either<ErrorModel, SuccessModel>> addEatenMeal({
    required String mealId,
    required String userId,
    String? mealName,
    num? calorie,
    String? mealType,
    num? noOfServing,
    String? recipeId,
    num? protein,
    num? fat,
    num? carbs,
    num? value,
  }) async {
    /*
    {
  "mealName": "string",
  "suggesticMealId": "string",
  "calorie": 0,
  "mealType": "string",
  "noOfServing": 0,
  "recipeId": "string",
  "protein": 0,
  "fat": 0,
  "carbs": 0,
  "value": 0,
  "userId": "string"
}
     */

    Map<String, dynamic> data = {
      "suggesticMealId": mealId,
      "mealName": mealName??'',
      "calorie": calorie??0,
      "mealType": mealType??'',
      "noOfServing": noOfServing??0,
     // "recipeId": recipeId,
      "protein": protein??0,
      "fat": fat??0,
      "carbs": carbs??0,
      "value": value??0,
      "userId": userId,
    };
    final response = await apiServices.post(ApiUrls.addMealLog, data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, SuccessModel>> addNewItem({
    required String mealId,
    required String userId,
  }) async {
    Map<String, dynamic> data = {'mealId': mealId, 'userId': userId};
    final response = await apiServices.post(ApiUrls.addEatenMeal, data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, SuccessModel>> addNewDiet({
    required String dietName,
    required String proteinPercentage,
    required String carbsPercentage,
    required String fatPercentage,
    required String surplusPercentage,
    required String deficitPercentage,
    required String mealSchedule,
    required String colorCode,
    required bool isDefault,
  }) async {
    Map<String, dynamic> data = {
      "dietName": dietName,
      "proteinPercentage": proteinPercentage,
      "carbsPercentage": carbsPercentage,
      "fatPercentage": fatPercentage,
      "surplusPercentage": surplusPercentage,
      "deficitPercentage": deficitPercentage,
      "mealSchedule": mealSchedule,
      "colorCode": colorCode,
      "isDefault": isDefault,
      "createdBy": '',
    };
    final response = await apiServices.post(ApiUrls.addNewDiet, data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, DailyRecapModal>> dailyRecap() async {
    final response = await apiServices.get(ApiUrls.getRecapQuestionList);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(DailyRecapModal.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, SuccessModel>> dailyRecapAns(
      {String? queID, bool? recapAns}) async {
    final response = await apiServices.post(
      ApiUrls.addOrUpdateDailyRecap,
      {"userId": userID, "recapQuestionid": queID, "recapAnswer": recapAns},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, SuccessModel>> removeWater(
      {String? quantity, bool? recapAns}) async {
    final response = await apiServices.delete(
      '${ApiUrls.removeWater}?quantity=$quantity&userId=$userID',
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
