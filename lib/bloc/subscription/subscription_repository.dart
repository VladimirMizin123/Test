import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/models/subscription_status_model.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';

class SubscriptionRepository {
  final ApiServices apiServices = ApiServices();

  String get userEmail => PreferenceUtils.getString(prefUserEmail);

  Future<Either<ErrorModel, SubscriptionStatusModel>>
      fetchSubscriptionStatus() async {
    String apiURL = '${ApiUrls.getSubscriptionStatus}/$userEmail';
    print(apiURL);
    final response = await apiServices.get(apiURL);
    if (response.statusCode == 200 || response.statusCode == 201) {
      await PreferenceUtils.setInt(userMealPlanCountState, 1);
      return Right(SubscriptionStatusModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, bool>> receiptDetailAdd(
      Map<String, dynamic> data) async {
    String apiURL = ApiUrls.addReceiptDetails;
    final response = await apiServices.post(apiURL, data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      log('Response : $response');
      return const Right(true);
    } else if (response.statusCode == 401) {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
