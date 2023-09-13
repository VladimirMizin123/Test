import 'dart:convert';
import 'package:either_dart/either.dart';
import '../models/error_model.dart';
import '../models/success_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class AddExerciseRepository {
  final ApiServices apiServices = ApiServices();

  Future<Either<ErrorModel, SuccessModel>> addExercise({
    required String caloriesBurned,
    required String exerciseName,
    required String userId,
    required String workoutTime,
    required String createdBy,
  }) async {
    Map<String, dynamic> data = {
      "caloriesBurned": caloriesBurned,
      "exerciseName":exerciseName,
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
    required String caloriesBurned,
    required String exerciseName,
    required String userId,
    required String workoutTime,
    required String createdBy,
  }) async {
    Map<String, dynamic> data = {"caloriesBurned": caloriesBurned, "exerciseName": exerciseName, "userId": userId, "workoutTime": workoutTime, "createdBy": createdBy};
    final response = await apiServices.post(ApiUrls.addExercise, data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
