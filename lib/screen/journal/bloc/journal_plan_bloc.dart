import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_event.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_repository.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_state.dart';

import '../../../widget/app_widget.dart';

class JournalPlanBloc extends Bloc<JournalPlanEvent, JournalMealPlanState> {
  JournalPlanBloc() : super(InitialState()) {
    on<JournalPlanFetchEvent>(_onFetchMealPlan);
    on<JournalSkipMealPlanEvent>(_onSkipMealPlan);
    on<JournalAddToGroceryListEvent>(_onAddToGroceryList);
    on<JournalFetchSwapMealItemEvent>(_onFetchSwapMealItem);
    // on<FetchMealDetailsEvent>(_onFetchMealDetails);
    // on<RestaurantSearchEvent>(_onRestaurantSearch);
    on<JournalSwapMealDetailsEvent>(_onSwapMealDetails);
    on<JournalScanBarcodeEvent>(_onScanBarcode);
    on<JournalSearchEvent>(_onSearchItem);
    on<JournalAddToShoppingListEvent>(_onAddToShoppingList);
    on<JournalAddToEatenEvent>(_onAddEaten);
  }

  final JournalPlanRepository _repository = JournalPlanRepository();

  _onSwapMealDetails(JournalSwapMealDetailsEvent event, Emitter<JournalMealPlanState> emit) async {
    emit(JournalSwapMealDetailsState(similarMealData: event.similarMealData, day: event.day, mealId: event.mealId));
  }

  _onScanBarcode(JournalScanBarcodeEvent event, Emitter<JournalMealPlanState> emit) async {
    emit(JournalBarcodeScannerState(barcode: event.barcode));
    emit(JournalBarcodeScannerLoadingState());
    try {
      await _repository.fetchBarcode(event.barcode).fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(JournalBarcodeScannerErrorState());
      }, (right) {
        emit(JournalBarcodeScannerSuccessState(barcodeScannerData: right.data));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(JournalBarcodeScannerErrorState());
    }
  }

  _onFetchMealPlan(JournalPlanFetchEvent event, Emitter<JournalMealPlanState> emit) async {
    emit(JournalFetchMealPlanLoadingState());

    try {
      await _repository.fetchMealPlan().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(JournalFetchMealPlanSuccessState(mealPlanList: right.data == null ? [] : right.data!.reversed.toList()));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(JournalFetchMealPlanErrorState());
    }
  }

  _onSkipMealPlan(JournalSkipMealPlanEvent event, Emitter<JournalMealPlanState> emit) async {
    emit(JournalSkipMealPlanLoadingState());

    try {
      await _repository.skipMealPlan(mealID: event.mealID).fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        log('RIGHT PART CALL - - - - - - - - - - - - ');

        emit(JournalSkipMealPlanSuccessState(skipMealPlanData: right.data!, mealID: event.mealID));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(JournalSkipMealPlanErrorState());
    }
  }

  _onAddToGroceryList(JournalAddToGroceryListEvent event, Emitter<JournalMealPlanState> emit) async {
    emit(JournalAddToGroceryLoadingState());

    try {
      await _repository.recipeAddToGrocery(databaseIdOfRecipes: event.databaseIdOfRecipes).fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        log('RIGHT PART CALL - - - - - - - - - - - - ');

        emit(JournalAddToGrocerySuccessState(isAdded: right.success ?? true));
        showToast(isSuccess: false, message: right.message ?? 'Added!');
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(JournalAddToGroceryErrorState());
    }
  }

  _onFetchSwapMealItem(JournalFetchSwapMealItemEvent event, Emitter<JournalMealPlanState> emit) async {
    emit(JournalFetchSwapMealLoadingState());

    try {
      await _repository.fetchSwapMealItem(recipeID: event.recipeID!, serving: event.serving!).fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        log('RIGHT PART CALL - - - - - - - - - - - - ');

        emit(JournalFetchSwapMealSuccessState(similarMealData: right.data!.recipeSwapOptions!.similar));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(JournalFetchSwapMealErrorState());
    }
  }

  _onAddToShoppingList(JournalAddToShoppingListEvent event, Emitter<JournalMealPlanState> emit) async {
    emit(JournalAddToShoppingLoadingState(productId: event.productID, isAdd: event.isAdd, isRemove: event.isRemove));

    try {
      await _repository.recipeAddToShoppingList(mealmeStoreId: event.mealmeStoreId, price: event.price, productID: event.productID, productName: event.productName, quantity: event.quantity, recipeId: event.recipeId, unitOfMeasurement: event.unitOfMeasurement, isChecked: event.isChecked, unitSize: event.unitSize).fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(JournalAddToShoppingSuccessState(isAdded: right.success ?? false, recipesAddToGroceryData: right.data, isAdd: event.isAdd, isRemove: event.isRemove));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(JournalAddToShoppingErrorState());
    }
  }

  // _onFetchMealDetails(FetchMealDetailsEvent event, Emitter<FetchMealPlanState> emit) async {
  //   emit(MealDetailsLoadingState());

  //   try {
  //     await _repository
  //         .fetchMealDetails(
  //       recipeID: event.recipeID!,
  //     )
  //         .fold((left) {
  //       onFailError(emit: emit, text: left.errorMessage!);
  //     }, (right) {
  //       log('RIGHT PART CALL - - - - - - - - - - - - ');

  //       emit(MealDetailsSuccessState(fetchModelData: right.data));
  //     });
  //   } catch (e) {
  //     showToast(isSuccess: false, message: e.toString());
  //     emit(MealDetailsErrorState());
  //   }
  // }

  // _onRestaurantSearch(RestaurantSearchEvent event, Emitter<FetchMealPlanState> emit) async {
  //   emit(RestaurantSearchLoadingState());
  //   try {
  //     await _repository.restaurantSearch(name: event.name!, latitude: event.latitude!, longitude: event.longitude!, maximumMiles: event.maximumMiles!, pickup: event.pickup!).fold((left) {
  //       onFailError(emit: emit, text: left.errorMessage!);
  //     }, (right) {
  //       log('RIGHT PART CALL - - - - - - - - - - - - ');

  //       emit(RestaurantSearchSuccessState(restaurantSearchData: right.data));
  //     });
  //   } catch (e) {
  //     print(e);
  //     showToast(isSuccess: false, message: e.toString());
  //     emit(RestaurantSearchErrorState());
  //   }
  // }

  _onSearchItem(JournalSearchEvent event, Emitter<JournalMealPlanState> emit) async {
    emit(JournalSearchLoadingState());
    try {
      await _repository.grocerySearch(latitude: '37.7786357', longitude: '-122.3918135', grocerySearchModal: event.journalSearchModelList!).fold((left) {
        emit(JournalSearchErrorState());
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(JournalSearchSuccessState(groceryMultiSearchProductList: right.data!.carts));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(JournalSearchErrorState());
    }
  }

  _onAddEaten(JournalAddToEatenEvent event, Emitter<JournalMealPlanState> emit) async {
    emit(JournalAddEatenLoadingState(mealID: event.mealId!));
    try {
      await _repository.addEatenMeal(mealId: event.mealId!, calorie: event.calorie, carbs: event.carbs, fat: event.fat, mealName: event.mealName, mealType: event.mealType, noOfServing: event.noOfServing, protein: event.protein, recipeId: event.recipeId).fold((left) {
        emit(JournalSearchErrorState());
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(JournalAddEatenSuccessState(isAdded: right.success, mealID: event.mealId!));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(JournalAddEatenErrorState());
    }
  }

  /// ON FAIL

  onFailError({required String text, required Emitter<JournalMealPlanState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(JournalFetchMealPlanErrorState());
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
