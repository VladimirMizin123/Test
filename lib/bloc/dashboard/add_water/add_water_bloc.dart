import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';

import '../../../repository/add_water.dart';
import '../../../widget/app_widget.dart';
import 'add_water_event.dart';
import 'add_water_state.dart';

class AddWaterBloc extends Bloc<AddWaterEvent, AddWaterState> {
  AddWaterBloc() : super(InitialState()) {
    on<SaveClickEvent>(_onAddWater);
    on<UpdateWaterEvent>(_onUpdateWater);
  }

  final AddWaterRepository _repository = AddWaterRepository();

  _onAddWater(SaveClickEvent event, Emitter<AddWaterState> emit) async {
    bool isTextFill = addWaterValid(event.waterML);

    if (isTextFill) {
      emit(LoadingState());
      try {
        await _repository
            .addWater(waterML: event.waterML, userId: userId, createdDate: '')
            .fold((left) {
          onFailError(emit: emit, text: left.errorMessage!);
        }, (right) {
          showToast(isSuccess: true, message: right.message!);
          double waterML = PreferenceUtils.getDouble(prefWaterML);
          waterML = waterML + double.parse(event.waterML);

          PreferenceUtils.setDouble(prefWaterML, waterML);
          emit(AddWaterSuccessfulState());

          Get.back(result: event.waterML);
        });
      } catch (e) {
        log(e.toString());
        showToast(isSuccess: false, message: e.toString());
        emit(ErrorState());
      }
    } else {
      onFailError(emit: emit, text: StringUtils.pleaseEnterEmail);
    }
  }

  _onUpdateWater(UpdateWaterEvent event, Emitter<AddWaterState> emit) async {
    bool isTextFill = addWaterValid(event.waterML);

    if (isTextFill) {
      emit(UpdateWaterLoadingState());
      try {
        await _repository
            .updateWater(
                waterML: event.waterML, userId: userId, createdDate: '')
            .fold((left) {
          onFailError(emit: emit, text: left.errorMessage!);
        }, (right) {
          showToast(isSuccess: true, message: right.message!);
          // int waterML = PreferenceUtils.getInt(prefWaterML);
          // waterML = waterML + int.parse(event.waterML);
          double waterML = double.parse(event.waterML);
          PreferenceUtils.setDouble(prefWaterML, waterML);
          emit(UpdateWaterSuccessfulState());
          Get.back(result: event.waterML);
        });
      } catch (e) {
        showToast(isSuccess: false, message: e.toString());
        emit(UpdateWaterErrorState());
      }
    } else {
      onFailError(emit: emit, text: StringUtils.pleaseEnterEmail);
    }
  }

  onFailError({required String text, required Emitter<AddWaterState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(ErrorState());
  }

  bool addWaterValid(String text) {
    if (text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
