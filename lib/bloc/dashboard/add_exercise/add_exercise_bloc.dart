import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';

import '../../../repository/add_exercise.dart';
import '../../../widget/app_widget.dart';
import 'add_exercise_event.dart';
import 'add_exercise_state.dart';

class AddExerciseBloc extends Bloc<AddWaterEvent, AddWaterState> {
  AddExerciseBloc() : super(InitialState()) {
    on<SaveClickEvent>(_onAddWater);
  }

  final AddExerciseRepository _repository = AddExerciseRepository();

  _onAddWater(SaveClickEvent event, Emitter<AddWaterState> emit) async {
    bool isCaloriesBurned = caloriesBurnedValid(event.caloriesBurned);
    bool isExerciseName = exerciseNameValid(event.exerciseName);
    bool isWorkoutTime = workoutTimeValid(event.workoutTime);

    if (isCaloriesBurned && isExerciseName && isWorkoutTime) {
      emit(LoadingState());
      try {
        await _repository
            .addExercise(
          caloriesBurned: event.caloriesBurned,
          exerciseName: event.exerciseName,
          workoutTime: event.workoutTime,
          userId: event.userId,
          createdBy: event.createdBy,
        )
            .fold((left) {
          onFailError(emit: emit, text: left.errorMessage!);
        }, (right) {
          showToast(isSuccess: true, message: right.message!);
          PreferenceUtils.setInt(prefExerciseCAl, int.parse(event.caloriesBurned));
          emit(AddWaterSuccessfulState());
          Get.back(result: event.caloriesBurned);
        });
      } catch (e) {
        showToast(isSuccess: false, message: e.toString());
        emit(ErrorState());
      }
    } else {
      if(!isExerciseName){
        onFailError(emit: emit, text: StringUtils.pleaseEnterExerciseName);
      } else if(!isWorkoutTime){
        onFailError(emit: emit, text: StringUtils.pleaseEnterMinutes);
      }else {
        onFailError(emit: emit, text: StringUtils.pleaseEnterCaloriesBurned);
      }

    }
  }

  onFailError({required String text, required Emitter<AddWaterState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(ErrorState());
  }

  bool caloriesBurnedValid(String text) {
    if (text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool exerciseNameValid(String text) {
    if (text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool workoutTimeValid(String text) {
    if (text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
