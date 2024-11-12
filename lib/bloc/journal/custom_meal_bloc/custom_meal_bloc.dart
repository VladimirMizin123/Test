import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/journal/custom_meal_bloc/custom_meal_event.dart';
import 'package:gymeats_mobile/bloc/journal/custom_meal_bloc/custom_meal_item_state.dart';
import 'package:gymeats_mobile/repository/get_new_meal_details.dart';
import 'package:gymeats_mobile/screen/appmanager/app_manager_screen.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:intl/intl.dart';

class AddNewMealBloc extends Bloc<AddNewMealEvent, AddNewMealState> {
  AddNewMealBloc() : super(InitialState()) {
    on<AddNewMeal>(_onAddNewMeal);
    on<UpdateNewMealEvent>(_onUpdateNewMeal);
    on<GetSelectedImagePath>(_onGetSelectedImagePath);
    on<GetCustomListEvent>(_onGetCustomMealListDetails);
  }

  final AddNewMealRepository _repository = AddNewMealRepository();

  _onAddNewMeal(AddNewMeal event, Emitter<AddNewMealState> emit) async {
    emit(AddNewMealLoadingState(productId: event.id));
    try {
      await _repository
          .addMeal(
        imageUrl: event.imageUrl,
        calorie: event.calorie,
        carbs: event.carbs,
        fat: event.fat,
        name: event.name,
        protein: event.protein,
        type: event.type,
        userId: event.userId,
        quantity: event.quantity,
        date: event.date ?? DateTime.now().toIso8601String(),
      )
          .fold(
        (left) {
          onFailError(emit: emit, text: left.errorMessage!);
        },
        (right) {
          showToast(isSuccess: true, message: right.message!);
          emit(AddNewMealSuccessfulState(productId: event.id));

          ///change bottom bar to select journal screen
          // Get.offAllNamed('/AppManagerScreen');
          // Get.offAllNamed('/AppManagerScreen');
          Get.offAll(() => const AppManagerScreen(
                selectIndex: 4,
              ));
        },
      );
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(AddNewMealErrorState(productId: event.id));
    }
  }

  _onUpdateNewMeal(
      UpdateNewMealEvent event, Emitter<AddNewMealState> emit) async {
    emit(AddNewMealLoadingState(productId: event.id));
    try {
      await _repository
          .updateMeal(
              id: event.id.toString(),
              imageUrl: event.imageUrl,
              calorie: event.calorie,
              carbs: event.carbs,
              fat: event.fat,
              name: event.name,
              protein: event.protein,
              type: event.type,
              userId: event.userId,
              quantity: event.quantity)
          .fold(
        (left) {
          onFailError(emit: emit, text: left.errorMessage!);
        },
        (right) {
          showToast(isSuccess: true, message: right.message!);
          emit(AddNewMealSuccessfulState(productId: event.id));

          ///change bottom bar to select journal screen
          // Get.offAllNamed('/AppManagerScreen');
          // Get.offAllNamed('/AppManagerScreen');
          Get.offAll(() => const AppManagerScreen(
                selectIndex: 4,
              ));
        },
      );
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(AddNewMealErrorState(productId: event.id));
    }
  }

  onFailError({required String text, required Emitter<AddNewMealState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(AddNewMealErrorState());
  }

  _onGetSelectedImagePath(
      GetSelectedImagePath event, Emitter<AddNewMealState> emit) async {
    emit(SelectedImagePathState(imgPath: event.imagePath));
  }

  /// Get Grocery Item Bloc =================================================================
  _onGetCustomMealListDetails(
      GetCustomListEvent event, Emitter<AddNewMealState> emit) async {
    emit(GetCustomMealListLoadingState());

    try {
      await _repository
          .getCustomMealListData(event.dateTime != null
              ? DateFormat('yyyy-MM-dd').format(event.dateTime!)
              : null)
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        log('right.data---------->>>>>> ${right.data}');

        emit(GetCustomMealListSuccessState(customMealDetails: right.data));
      });
    } catch (e) {
      print('--ERROR-->>>${e.toString()}');

      showToast(isSuccess: false, message: e.toString());
      emit(GetCustomMealListErrorState());
    }
  }
}
