import 'package:gymeats_mobile/models/get_order_invoice_list_model.dart';

import '../../../models/fetch_meal_plan_model.dart';
import '../../../models/get_dashboard_model.dart';
import '../../../models/get_meallogby_date_model.dart';

abstract class GetDashboardState {}

class InitialState extends GetDashboardState {}

class LoadDashboardData extends GetDashboardState {
  GetDashboardModel model;
  List<MealDataByDate>? data;
  LoadDashboardData({required this.model, this.data});
}

class LoadMealData extends GetDashboardState {
  List<MealData> trackerDataList;
  LoadMealData({required this.trackerDataList});
}

class ErrorStateData extends GetDashboardState {
  String errMessage;

  ErrorStateData({
    required this.errMessage,
  });
}

class LoadingData extends GetDashboardState {}

class NextScreenState extends GetDashboardState {
  String dietId;
  NextScreenState({required this.dietId});
}

class LoadingDoneState extends GetDashboardState {
  final String mealID;

  LoadingDoneState({required this.mealID});
}

class GetOrderInvoiceLoadingState extends GetDashboardState {}

class GetOrderInvoiceSuccessState extends GetDashboardState {
  final List<InvoiceList> invoiceData;

  GetOrderInvoiceSuccessState({required this.invoiceData});
}

class GetOrderInvoiceErrorState extends GetDashboardState {}
