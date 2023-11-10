import 'dart:convert';

import 'package:either_dart/either.dart';

import '../models/error_model.dart';
import '../models/get_dashboard_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class GetTotalCaloriesBurnedByExerciseRepository {
  final ApiServices apiServices = ApiServices();

  Future<Either<ErrorModel , GetDashboardModel>> getTotalCaloriesBurnedByExercise() async {
    final response = await apiServices.get(
      ApiUrls.getTotalCaloriesBurnedByExercise,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetDashboardModel.fromJson(jsonDecode(response.body)) );
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
