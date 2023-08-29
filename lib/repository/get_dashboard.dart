import 'dart:convert';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';

import '../app/functions.dart';
import '../models/error_model.dart';
import '../models/get_dashboard_model.dart';
import '../models/get_survey_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class GetDashboardDataRepository {
  final ApiServices apiServices = ApiServices();

  Future<Either<ErrorModel , GetDashboardModel>> getDashboardData() async {
    final response = await apiServices.get(
      '${ApiUrls.getDashboardData}/$userId',
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetDashboardModel.fromJson(jsonDecode(response.body)) );
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
