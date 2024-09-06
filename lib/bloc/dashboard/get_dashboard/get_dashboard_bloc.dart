import 'dart:convert';
import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:intl/intl.dart';
import '../../../app/functions.dart';
import '../../../app/sharedPrefrence.dart';
import '../../../models/fetch_meal_plan_model.dart';
import '../../../repository/add_eaten_meal.dart';
import '../../../repository/get_dashboard.dart';
import '../../../screen/meal_plan_home/bloc/meal_plan_repository.dart';
import '../../../widget/app_widget.dart';
import 'get_dashboard_event.dart';
import 'get_dashboard_state.dart';

class GetDashboardBloc extends Bloc<GetDashboardEvent, GetDashboardState> {
  GetDashboardBloc() : super(InitialState()) {
    on<GetDashboardData>(_onGetSurveyData);
    on<GenMealTrackerData>(_onGenMealTrackerData);
    on<AddEatenMealData>(_onAddEatenMeal);
    on<GetOrderInvoiceList>(_onGetOrderInvoiceList);
    on<AddIngredientGroceryList>(_onAddIngredientGroceryList);
    on<GetAllergiesAndRestriction>(_onGetAllergiesAndRestriction);
  }

  final GetDashboardDataRepository _dashboardRepository =
      GetDashboardDataRepository();
  final MealPlanRepository _planRepository = MealPlanRepository();
  final AddEatenMealRepository _eatenMealRepository = AddEatenMealRepository();

  _onGetSurveyData(
      GetDashboardData event, Emitter<GetDashboardState> emit) async {
    try {
      final response = await _dashboardRepository.getDashboardData();
      final data = await _dashboardRepository
          .getMealLogByDate(DateFormat('yyyy-MM-dd').format(DateTime.now()));
      if (response.isRight && data.isRight) {
        await PreferenceUtils.setString(
            dashboardModelPref, jsonEncode(response.right));
        await PreferenceUtils.setString(
            mealDataByDatePref, jsonEncode(data.right.data ?? []));
        emit(LoadDashboardData(model: response.right, data: data.right.data));
      } else if (response.isRight && data.isLeft) {
        await PreferenceUtils.setString(
            dashboardModelPref, jsonEncode(response.right));
        await PreferenceUtils.setString(mealDataByDatePref, jsonEncode([]));
        emit(LoadDashboardData(model: response.right, data: []));
      }
    } catch (e) {
      emit(ErrorStateData(errMessage: e.toString()));
    }
  }

  _onGetAllergiesAndRestriction(
      GetAllergiesAndRestriction event, Emitter<GetDashboardState> emit) async {
    try {
      _dashboardRepository.apiServices
          .get(ApiUrls.getUserRestriction)
          .then((value) async {
        if (value != null) {
          dynamic res = jsonDecode(value.body)["data"];
          List dataList = res is List ? res : [];
          await PreferenceUtils.setStringList(
              getUserRestriction, dataList.map((e) => e.toString()).toList());
        }
      });

      _dashboardRepository.apiServices
          .get(ApiUrls.getUserAllergies)
          .then((value) async {
        if (value != null) {
          dynamic res = jsonDecode(value.body)["data"];
          List dataList = res is List ? res : [];
          await PreferenceUtils.setStringList(
              getUserAllergies, dataList.map((e) => e.toString()).toList());
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  List<MealData> dataList = [];

  _onGenMealTrackerData(
      GenMealTrackerData event, Emitter<GetDashboardState> emit) async {
    try {
      emit(LoadingData());
      await _planRepository.fetchMealPlan().fold((left) {
        emit(ErrorStateData(
          errMessage: left.errorMessage!,
        ));
      }, (right) async {
        right.data!.map((e) {
          if (dateTimeYYYYMMDD(dateTimeVal: e.date.toString()) ==
              dateTimeNow()) {
            if (dateTimeYYYYMMDD(dateTimeVal: e.date.toString()) ==
                dateTimeNow()) {
              dataList.addAll(e.meals!);
            }
          }
        }).toList();
        String data = jsonEncode(dataList);
        await PreferenceUtils.setString(trackerListStore, data);
        emit(LoadMealData(trackerDataList: dataList));
      });
    } catch (e) {
      print("Error:- $e");
      emit(ErrorStateData(errMessage: e.toString()));
    }
  }

  _onAddEatenMeal(
      AddEatenMealData event, Emitter<GetDashboardState> emit) async {
    try {
      emit(LoadingDoneState(mealID: event.mealId));
      await _eatenMealRepository
          .addEatenMeal(
              userId: userId,
              mealId: event.mealId,
              value: event.value,
              mealName: event.mealName,
              mealType: event.mealType,
              noOfServing: event.noOfServing,
              protein: event.protein,
              fat: event.fat,
              carbs: event.carbs,
              recipeId: event.recipeId,
              calorie: event.calorie)
          .fold((left) {
        showToast(isSuccess: false, message: left.errorMessage!);
      }, (right) {
        showToast(isSuccess: true, message: right.message!);
        dataList.map((e) {
          if (e.id!.contains(event.mealId)) {
            e.isDone = true;
          }
        }).toList();

        emit(LoadMealData(trackerDataList: dataList));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
    }
  }

  _onGetOrderInvoiceList(
      GetOrderInvoiceList event, Emitter<GetDashboardState> emit) async {
    emit(GetOrderInvoiceLoadingState());

    try {
      await _dashboardRepository.getInvoiceOrderList().fold((left) {
        emit(GetOrderInvoiceErrorState());
      }, (right) {
        emit(GetOrderInvoiceSuccessState(
            invoiceData: right.data?.orderedItems ?? []));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetOrderInvoiceErrorState());
    }
  }

  _onAddIngredientGroceryList(
      AddIngredientGroceryList event, Emitter<GetDashboardState> emit) async {
    try {
      await _dashboardRepository.addIngredientToUserGroceryList();
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
    }
  }
}
