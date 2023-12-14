import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';

import '../models/error_model.dart';
import '../models/success_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class AddExerciseRepository {
  final ApiServices apiServices = ApiServices();

  String userID = PreferenceUtils.getString(prefUserData);

  Future<Either<ErrorModel, SuccessModel>> addExercise({
    required String caloriesBurned,
    required String exerciseName,
    required String userId,
    required String workoutTime,
    required String createdBy,
  }) async {
    Map<String, dynamic> data = {
      "caloriesBurned": caloriesBurned,
      "exerciseName": exerciseName,
      "userId": userId,
      "workoutTime": workoutTime,
      "createdBy": createdBy
    };
    final response = await apiServices.post(ApiUrls.addExercise, data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, SuccessModel>> updateExercise({
    required String exerciseId,
    required String exerciseName,
    required int workoutTime,
    required int caloriesBurned,
    required String userId,
  }) async {
    Map<String, dynamic> data = {
      "exerciseName": exerciseName,
      "exerciseId": exerciseId,
      "workoutTime": workoutTime,
      "caloriesBurned": caloriesBurned,
      "userId": userId,
    };

    final response = await apiServices.put(ApiUrls.updateExercise, data);
    log(data.toString(), name: "data");
    log(response.body.toString(), name: "response");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, SuccessModel>> deleteExercise({
    required String exerciseName,
  }) async {
    final response = await apiServices.delete(
        '${ApiUrls.removeExercise}?exerciseName=$exerciseName&userId=$userID');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
