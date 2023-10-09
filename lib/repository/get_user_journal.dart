import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/models/get_meallogby_date_model.dart';

import '../models/error_model.dart';
import '../models/get_dashboard_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class GetUserJournalDataRepository {
  final ApiServices apiServices = ApiServices();

  Future<Either<ErrorModel, GetDashboardModel>> getUserJournalData(
      {required String date}) async {
    final response = await apiServices.get(
      '${ApiUrls.getUserJournalData}/$userId?date=$date',
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetDashboardModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, GetMealLogByDate>> getMealLogByDate(
      String date) async {
    final response =
        await apiServices.get('${ApiUrls.getMealLogByDate}/$userId?date=$date');
    print('getMealLogByDate response : ${response.body}');
    print('getMealLogByDate response statusCode : ${response.statusCode}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(
        GetMealLogByDate.fromJson(jsonDecode(response.body)),
      );
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, GetDashboardModel>> getDashboardData() async {
    final response = await apiServices.get(
      '${ApiUrls.getDashboardData}/$userId',
    );
    print("response123 : ${response.body}");
    print("response statusCode: ${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetDashboardModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
