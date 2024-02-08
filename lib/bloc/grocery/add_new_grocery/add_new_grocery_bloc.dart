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
    on<UpdateAddNewGroceryItem>(_onAddUpdateGroceryItem);
    on<UpdateRemoveNewGroceryItem>(_onRemoveUpdateGroceryItem);
    on<ClearUserGroceryEvent>(_onClearGroceryList);
    on<AddGroceryToShoppingListFromSuggesticEvent>(
        _onAddGroceryToShoppingListFromSuggestic);
  }

  final AddNewGroceryItemRepository _repository = AddNewGroceryItemRepository();

  /// Add Grocery Item Bloc =================================================================

  _onAddNewGroceryItem(
      AddNewGroceryItem event, Emitter<AddNewGroceryItemState> emit) async {
    emit(LoadingState(productId: event.id ?? ''));
    try {
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
          showToast(isSuccess: true, message: 'Ingredients Added Successfully');
          emit(AddGroceryItemSuccessfulState(productId: event.id ?? ''));
        },
      );
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(ErrorState(productId: event.id ?? ''));
    }
  }

  /// Get Grocery Item Bloc =================================================================
  _onGetGroceryDetails(
      GetGroceryItemEvent event, Emitter<AddNewGroceryItemState> emit) async {
    emit(GetGroceryListLoadingState());

    try {
      await _repository.getGroceryListData().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(GetGroceryListSuccessState(groceryDetails: right.data));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetGroceryListErrorState());
    }
  }

  /// Remove Grocery Item Bloc =================================================================
  _onRemoveGroceryItem(RemoveGroceryItemEvent event,
      Emitter<AddNewGroceryItemState> emit) async {
    emit(RemoveGroceryItemLoadingState(
        userGroceryListId: event.userGroceryListId));

    try {
      await _repository
          .deleteGroceryItem(userGroceryListId: event.userGroceryListId!)
          .fold((left) {
        // emit(RemoveGroceryItemErrorState(
        //     userGroceryListId: event.userGroceryListId));
        onFailError(emit: emit, text: left.errorMessage!);
        // emit(RemoveGroceryItemErrorState(
        //     userGroceryListId: event.userGroceryListId));
      }, (right) {
        if (event.showToast) {
          showToast(isSuccess: true, message: right.message!);
        }

        emit(RemoveGroceryItemSuccessState(
            userGroceryListId: event.userGroceryListId,
            isDelete: right.success));
      });
    } catch (e) {
      print('---->>>>>>');
      showToast(isSuccess: false, message: e.toString());
      emit(RemoveGroceryItemErrorState(
          userGroceryListId: event.userGroceryListId));
    }
  }

  /// Update Add Grocery Item Bloc =================================================================

  _onAddUpdateGroceryItem(UpdateAddNewGroceryItem event,
      Emitter<AddNewGroceryItemState> emit) async {
    emit(UpdateAddGroceryListLoadingState(userGroceryListId: event.id));
    try {
      await _repository
          .updateGroceryItem(
        id: event.id,
        itemName: event.itemName,
        userId: event.userId,
        measurementType: event.measurementType,
        quantity: event.quantity,
        measurementValue: event.measurementValue,
      )
          .fold(
        (left) {
          onFailError(emit: emit, text: left.errorMessage!);
        },
        (right) {
          showToast(isSuccess: true, message: right.message!);
          emit(UpdateAddGroceryListSuccessState(userGroceryListId: event.id));
        },
      );
    } catch (e) {
      print('------->>>${e.toString()}');

      showToast(isSuccess: false, message: e.toString());
      emit(UpdateAddGroceryListErrorState(userGroceryListId: event.id));
    }
  }

  /// Update Remove Grocery Item Bloc =================================================================

  _onRemoveUpdateGroceryItem(UpdateRemoveNewGroceryItem event,
      Emitter<AddNewGroceryItemState> emit) async {
    emit(UpdateRemoveGroceryListLoadingState(userGroceryListId: event.id));
    try {
      log('event.id---------->>>>>> ${event.id.runtimeType}');
      log('event.id---------->>>>>> ${event.itemName.runtimeType}');
      log('event.id---------->>>>>> ${event.userId.runtimeType}');
      log('event.id---------->>>>>> ${event.measurementType.runtimeType}');
      log('event.id---------->>>>>> ${event.measurementValue.runtimeType}');
      log('event.id---------->>>>>> ${event.quantity.runtimeType}');

      await _repository
          .updateGroceryItem(
        id: event.id,
        itemName: event.itemName,
        userId: event.userId,
        measurementType: event.measurementType,
        quantity: event.quantity,
        measurementValue: event.measurementValue,
      )
          .fold(
        (left) {
          onFailError(emit: emit, text: left.errorMessage!);
        },
        (right) {
          showToast(isSuccess: true, message: right.message!);
          emit(
              UpdateRemoveGroceryListSuccessState(userGroceryListId: event.id));
        },
      );
    } catch (e) {
      print('------->>>${e.toString()}');

      showToast(isSuccess: false, message: e.toString());
      emit(UpdateRemoveGroceryListErrorState(userGroceryListId: event.id));
    }
  }

  _onAddGroceryToShoppingListFromSuggestic(
      AddGroceryToShoppingListFromSuggesticEvent event,
      Emitter<AddNewGroceryItemState> emit) async {
    emit(AddGroceryToShoppingListFromSuggesticLoadingState());

    try {
      await _repository
          .addGroceryToShoppingListFromSuggestic(
              latitude: event.latitude, longitude: event.longitude)
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(AddGroceryToShoppingListFromSuggesticErrorState());
      }, (right) {
        emit(AddGroceryToShoppingListFromSuggesticSuccessState(
            groceryDetails: right.data));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(AddGroceryToShoppingListFromSuggesticErrorState());
    }
  }

  /// Clear Grocery List Bloc =================================================================
  _onClearGroceryList(
      ClearUserGroceryEvent event, Emitter<AddNewGroceryItemState> emit) async {
    emit(ClearGroceryLoadingState());

    try {
      await _repository.clearGroceryList().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(ClearGroceryErrorState());
      }, (right) {
        emit(ClearGrocerySuccessState(isClear: right.success ?? true));
        showToast(isSuccess: true, message: right.message ?? 'Added!');
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(ClearGroceryErrorState());
    }
  }

  onFailError(
      {required String text, required Emitter<AddNewGroceryItemState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(ErrorState());
  }
}
