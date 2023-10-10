import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_event.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_state.dart';
import 'package:gymeats_mobile/repository/get_grocery_details.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class AddNewGroceryItemBloc
    extends Bloc<AddNewGroceryItemEvent, AddNewGroceryItemState> {
  AddNewGroceryItemBloc() : super(InitialState()) {
    on<AddNewGroceryItem>(_onAddNewGroceryItem);
    on<GetGroceryItemEvent>(_onGetGroceryDetails);
    on<RemoveGroceryItemEvent>(_onRemoveGroceryItem);
  }

  final AddNewGroceryItemRepository _repository = AddNewGroceryItemRepository();

  _onAddNewGroceryItem(
      AddNewGroceryItem event, Emitter<AddNewGroceryItemState> emit) async {
    emit(LoadingState());
    try {
      print('---EDE_E_E${event.groceryItems}');

      await _repository
          .addGroceryItem(
              //itemName: event.itemName,
              userId: event.userId,
              groceryItems: event.groceryItems
              // measurementType: event.measurementType,
              // quantity: event.quantity,
              // measurementValue: event.measurementValue,
              )
          .fold(
        (left) {
          onFailError(emit: emit, text: left.errorMessage!);
        },
        (right) {
          showToast(isSuccess: true, message: right.message!);
          emit(AddGroceryItemSuccessfulState());
        },
      );
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(ErrorState());
    }
  }

  _onGetGroceryDetails(
      GetGroceryItemEvent event, Emitter<AddNewGroceryItemState> emit) async {
    emit(GetGroceryListLoadingState());

    try {
      await _repository.getGroceryListData().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        log('RIGHT PART CALL - - - - - - wdwe- - - - - -${right.data![0].itemName} ');

        emit(GetGroceryListSuccessState(groceryDetails: right.data));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetGroceryListErrorState());
    }
  }

  _onRemoveGroceryItem(RemoveGroceryItemEvent event,
      Emitter<AddNewGroceryItemState> emit) async {
    emit(RemoveGroceryItemLoadingState(
        userGroceryListId: event.userGroceryListId));

    try {
      await _repository
          .deleteGroceryItem(userGroceryListId: event.userGroceryListId!)
          .fold((left) {
        emit(RemoveGroceryItemErrorState(
            userGroceryListId: event.userGroceryListId));
        onFailError(emit: emit, text: left.errorMessage!);
        emit(RemoveGroceryItemErrorState(
            userGroceryListId: event.userGroceryListId));
      }, (right) {
        showToast(isSuccess: true, message: right.message!);

        print('---->>>>${right.success}');
        emit(RemoveGroceryItemSuccessState(
            userGroceryListId: event.userGroceryListId,
            isDelete: right.success));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(RemoveGroceryItemErrorState(
          userGroceryListId: event.userGroceryListId));
    }
  }

  onFailError(
      {required String text, required Emitter<AddNewGroceryItemState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(ErrorState());
  }
}
