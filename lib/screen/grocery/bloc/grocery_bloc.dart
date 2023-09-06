import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_repository.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class GroceryBloc extends Bloc<GroceryEvent, GroceryState> {
  GroceryBloc() : super(InitialState()) {
    on<AddGroceryToShoppingListFromSuggesticEvent>(_onAddGroceryToShoppingListFromSuggestic);
    on<GroceryFetchEvent>(_onFetchGroceryItem);
    on<GroceryAddToShoppingListEvent>(_onAddToShoppingList);
  }

  final GroceryRepository _repository = GroceryRepository();

  _onAddGroceryToShoppingListFromSuggestic(AddGroceryToShoppingListFromSuggesticEvent event, Emitter<GroceryState> emit) async {
    emit(AddGroceryToShoppingListFromSuggesticLoadingState());

    try {
      await _repository.addGroceryToShoppingListFromSuggestic(latitude: event.latitude, longitude: event.longitude).fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(AddGroceryToShoppingListFromSuggesticSuccessState(isAdded: right.success ?? false));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(AddGroceryToShoppingListFromSuggesticErrorState());
    }
  }

  _onFetchGroceryItem(GroceryFetchEvent event, Emitter<GroceryState> emit) async {
    emit(GroceryFetchLoadingState());

    try {
      await _repository.fetchGroceryShoppingList().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(GroceryFetchSuccessState(edgesList: right.data == null ? [] : right.data!.shoppingListAggregate!.edges));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GroceryErrorState());
    }
  }

  _onAddToShoppingList(GroceryAddToShoppingListEvent event, Emitter<GroceryState> emit) async {
    emit(GroceryAddToShoppingLoadingState(databaseIdOfRecipes: event.productID));

    try {
      await _repository.recipeAddToGrocery(mealmeStoreId: event.mealmeStoreId, price: event.price, productID: event.productID, productName: event.productName, quantity: event.quantity, recipeId: event.recipeId, unitOfMeasurement: event.unitOfMeasurement, unitSize: event.unitSize).fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(GroceryAddToShoppingSuccessState(isAdded: right.success ?? false, productID: event.productID));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GroceryAddToShoppingErrorState());
    }
  }

  /// ON FAIL

  onFailError({required String text, required Emitter<GroceryState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(GroceryErrorState());
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
