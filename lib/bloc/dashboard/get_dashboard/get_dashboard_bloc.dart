import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  }

  final GetDashboardDataRepository _dashboardRepository =
      GetDashboardDataRepository();
  final MealPlanRepository _planRepository = MealPlanRepository();
  final AddEatenMealRepository _eatenMealRepository = AddEatenMealRepository();

  _onGetSurveyData(
      GetDashboardData event, Emitter<GetDashboardState> emit) async {
    _onGetSurveyData(
        GetDashboardData event, Emitter<GetDashboardState> emit) async {
      try {
        final response = await _dashboardRepository.getDashboardData();
        response.fold((left) {}, (right) {
          emit(LoadDashboardData(model: right));
        });
      } catch (e) {
        emit(ErrorStateData(errMessage: e.toString()));
      }
    }
  }

  List<MealData> dataList = [];

  _onGenMealTrackerData(
      GenMealTrackerData event, Emitter<GetDashboardState> emit) async {
    try {
      emit(LoadingData());
      await _planRepository.fetchMealPlan().fold((left) {
        emit(ErrorStateData(errMessage: left.errorMessage!));
      }, (right) {
        right.data!.map((e) {
          if (dateTimeYYYYMMDD(dateTimeVal: e.date.toString()) ==
              dateTimeNow()) {
            if (dateTimeYYYYMMDD(dateTimeVal: e.date.toString()) ==
                dateTimeNow()) {
              dataList.addAll(e.meals!);
            }
          }
        }).toList();
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
          .addEatenMeal(userId: userId, mealId: event.mealId)
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
}
