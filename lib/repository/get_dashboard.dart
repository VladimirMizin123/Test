import 'dart:convert';
import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/models/get_order_invoice_list_model.dart';

import '../models/error_model.dart';
import '../models/get_dashboard_model.dart';
import '../models/get_meallogby_date_model.dart';
import '../service/api_urls.dart';
import '../service/apis.dart';

class GetDashboardDataRepository {
  final ApiServices apiServices = ApiServices();

  Future<Either<ErrorModel, GetDashboardModel>> getDashboardData() async {
    final response = await apiServices.get(
      '${ApiUrls.getDashboardData}/$userId',
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

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetMealLogByDate.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, GetOrderInvoiceListModel>>
      getInvoiceOrderList() async {
    log('Api ${ApiUrls.getOrderInvoiceList}/$userId');
    final response =
        await apiServices.get('${ApiUrls.getOrderInvoiceList}/$userId');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(
          GetOrderInvoiceListModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(
          GetOrderInvoiceListModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<bool> addIngredientToUserGroceryList() async {
    final response = await apiServices
        .get('${ApiUrls.addIngredientToUserGroceryList}/$userId');
    log("Response : ${response.body.toString()}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return true;
    }
  }
}
