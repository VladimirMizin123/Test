import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
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
  }

  final AddWaterRepository _repository = AddWaterRepository();

  _onAddWater(SaveClickEvent event, Emitter<AddWaterState> emit) async {
    bool isTextFill = addWaterValid(event.waterML);

    if (isTextFill) {
      emit(LoadingState());
      try {
        await _repository.addWater(
            waterML: event.waterML, userId: userId, createdDate: '').fold((
            left) {
          onFailError(emit: emit, text: left.errorMessage!);
        }, (right) {
          showToast(isSuccess: true, message: right.message!);
          PreferenceUtils.setInt(prefWaterML, int.parse(event.waterML));
          emit(AddWaterSuccessfulState());
          Get.back(result: event.waterML);
        });
      } catch (e) {
        showToast(isSuccess: false, message: e.toString());
        emit(ErrorState());
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
