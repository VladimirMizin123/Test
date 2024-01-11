import 'dart:convert';

import 'package:either_dart/either.dart';

import '../models/error_model.dart';
import '../models/success_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class AddWaterRepository {
  final ApiServices apiServices = ApiServices();

  Future<Either<ErrorModel, SuccessModel>> addWater(
      {required String waterML,
      required String userId,
      required String createdDate}) async {
    Map<String, dynamic> data = {
      "quantity": waterML,
      "userId": userId,
      "createdBy": createdDate
    };

    final response = await apiServices.post(ApiUrls.addWater, data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, SuccessModel>> updateWater(
      {required String waterML,
      required String userId,
      required String createdDate}) async {
    Map<String, dynamic> data = {
      "quantity": waterML,
      "userId": userId,
      "createdBy": createdDate
    };

    final response = await apiServices.put(ApiUrls.updateWater, data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
