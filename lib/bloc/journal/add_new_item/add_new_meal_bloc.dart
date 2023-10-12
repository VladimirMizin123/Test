import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/journal/add_new_item/add_new_meal_event.dart';
import 'package:gymeats_mobile/bloc/journal/add_new_item/add_new_meal_item_state.dart';
import 'package:gymeats_mobile/repository/add_new_meal.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class AddNewMealBloc extends Bloc<AddNewMealEvent, AddNewMealState> {
  AddNewMealBloc() : super(InitialState()) {
    on<AddNewMeal>(_onAddNewMeal);
    on<GetSelectedImagePath>(_onGetSelectedImagePath);
  }

  final AddNewMealRepository _repository = AddNewMealRepository();

  _onAddNewMeal(AddNewMeal event, Emitter<AddNewMealState> emit) async {
    emit(LoadingState());
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
              quantity: event.quantity)
          .fold(
        (left) {
          onFailError(emit: emit, text: left.errorMessage!);
        },
        (right) {
          showToast(isSuccess: true, message: right.message!);
          emit(AddNewMealSuccessfulState());

          // Get.offAllNamed('/JournalScreen');
        },
      );
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(ErrorState());
    }
  }

  onFailError({required String text, required Emitter<AddNewMealState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(ErrorState());
  }

  _onGetSelectedImagePath(
      GetSelectedImagePath event, Emitter<AddNewMealState> emit) async {
    emit(SelectedImagePathState(imgPath: event.imagePath));
  }
}
