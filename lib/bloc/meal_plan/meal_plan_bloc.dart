import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/bloc/meal_plan/meal_plan_event.dart';
import 'package:gymeats_mobile/bloc/meal_plan/meal_plan_repository.dart';
import 'package:gymeats_mobile/bloc/meal_plan/meal_plan_state.dart';

import '../../widget/app_widget.dart';

class MealPlanBloc extends Bloc<MealPlanEvent, FetchMealPlanState> {
  MealPlanBloc() : super(InitialState()) {
    on<MealPlanFetchEvent>(_onFetchMealPlan);
    on<SkipMealPlanEvent>(_onSkipMealPlan);
  }

  final MealPlanRepository _repository = MealPlanRepository();

  _onFetchMealPlan(MealPlanFetchEvent event, Emitter<FetchMealPlanState> emit) async {
    emit(FetchMealPlanLoadingState());

    try {
      await _repository.fetchMealPlan().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(FetchMealPlanSuccessState(mealPlanList: right.data == null ? [] : right.data!.reversed.toList()));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(FetchMealPlanErrorState());
    }
  }



  _onSkipMealPlan(SkipMealPlanEvent event, Emitter<FetchMealPlanState> emit) async {
    emit(SkipMealPlanLoadingState());

    try {
      await _repository.skipMealPlan(mealID: event.mealID).fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        log('RIGHT PART CALL - - - - - - - - - - - - ');

        emit(SkipMealPlanSuccessState(skipMealPlanData: right.data!, mealID: event.mealID));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(SkipMealPlanErrorState());
    }
  }

  onFailError({required String text, required Emitter<FetchMealPlanState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(FetchMealPlanErrorState());
  }

  bool emailValid(String email) {
    if (email.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool passwordValid(String password) {
    if (password.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
