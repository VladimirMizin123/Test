import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_event.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_repository.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_state.dart';

import '../../../widget/app_widget.dart';

class MealPlanBloc extends Bloc<MealPlanEvent, FetchMealPlanState> {
  MealPlanBloc() : super(InitialState()) {
    on<MealPlanFetchEvent>(_onFetchMealPlan);
    on<SkipMealPlanEvent>(_onSkipMealPlan);
    on<AddToGroceryListEvent>(_onAddToGroceryList);
    on<FetchSwapMealItemEvent>(_onFetchSwapMealItem);
    on<FetchMealDetailsEvent>(_onFetchMealDetails);
    on<RestaurantSearchEvent>(_onRestaurantSearch);
    on<SwapMealDetailsEvent>(_onSwapMealDetails);
    on<GroceryAddToShoppingListEvent>(_onAddToShoppingList);
    on<GrocerySearchEvent>(_onSearchItem);
  }

  final MealPlanRepository _repository = MealPlanRepository();

  _onSwapMealDetails(
      SwapMealDetailsEvent event, Emitter<FetchMealPlanState> emit) async {
    emit(SwapMealDetailsState(
        similarMealData: event.similarMealData,
        day: event.day,
        mealId: event.mealId));
  }

  _onFetchMealPlan(
      MealPlanFetchEvent event, Emitter<FetchMealPlanState> emit) async {
    emit(FetchMealPlanLoadingState());

    try {
      await _repository.fetchMealPlan().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(FetchMealPlanSuccessState(
            mealPlanList:
                right.data == null ? [] : right.data!.reversed.toList()));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(FetchMealPlanErrorState());
    }
  }

  _onSkipMealPlan(
      SkipMealPlanEvent event, Emitter<FetchMealPlanState> emit) async {
    emit(SkipMealPlanLoadingState());

    try {
      await _repository
          .addEatenMeal(
        mealId: event.mealID,
        calorie: event.calorie,
        carbs: event.carbs,
        fat: event.fat,
        mealName: event.mealName,
        mealType: event.mealType,
        noOfServing: event.noOfServing,
        protein: event.protein,
        recipeId: event.recipeId,
      )
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        log('RIGHT PART CALL - - - - - - - - - - - - ');

        emit(SkipMealPlanSuccessState(
            skipMealPlanData: right.success!, mealID: event.mealID));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(SkipMealPlanErrorState());
    }
  }

  _onAddToGroceryList(
      AddToGroceryListEvent event, Emitter<FetchMealPlanState> emit) async {
    emit(AddToGroceryLoadingState());

    try {
      await _repository
          .recipeAddToGrocery(addItemsToShoppingList: event.addItemsList)
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        log('_onAddToGroceryList RIGHT PART CALL - - - - - - - - - - - - ');

        emit(AddToGrocerySuccessState(isAdded: right.success ?? true));
        showToast(isSuccess: false, message: right.message ?? 'Added!');
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(AddToGroceryErrorState());
    }
  }

  _onFetchSwapMealItem(
      FetchSwapMealItemEvent event, Emitter<FetchMealPlanState> emit) async {
    emit(FetchSwapMealLoadingState());

    try {
      await _repository
          .fetchSwapMealItem(recipeID: event.recipeID!, serving: event.serving!)
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        log('RIGHT PART CALL - - - - - - - - - - - - ');

        emit(FetchSwapMealSuccessState(
            similarMealData: right.data!.recipeSwapOptions!.similar));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(FetchSwapMealErrorState());
    }
  }

  _onFetchMealDetails(
      FetchMealDetailsEvent event, Emitter<FetchMealPlanState> emit) async {
    emit(MealDetailsLoadingState());

    try {
      await _repository
          .fetchMealDetails(
        recipeID: event.recipeID!,
      )
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        log('RIGHT PART CALL - - - - - - - - - - - - ');

        emit(MealDetailsSuccessState(fetchModelData: right.data));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(MealDetailsErrorState());
    }
  }

  _onRestaurantSearch(
      RestaurantSearchEvent event, Emitter<FetchMealPlanState> emit) async {
    emit(RestaurantSearchLoadingState());
    try {
      await _repository
          .restaurantSearch(
              name: event.name!,
              latitude: event.latitude!,
              longitude: event.longitude!,
              maximumMiles: event.maximumMiles!,
              pickup: event.pickup!)
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        log('RIGHT PART CALL - - - - - - - - - - - - ');

        emit(RestaurantSearchSuccessState(restaurantSearchData: right.data));
      });
    } catch (e) {
      print(e);
      showToast(isSuccess: false, message: e.toString());
      emit(RestaurantSearchErrorState());
    }
  }

  _onSearchItem(
      GrocerySearchEvent event, Emitter<FetchMealPlanState> emit) async {
    emit(GrocerySearchLoadingState());
    try {
      await _repository
          .grocerySearch(
              latitude: '37.7786357',
              longitude: '-122.3918135',
              grocerySearchModal: event.grocerySearchModelList!)
          .fold((left) {
        emit(GrocerySearchErrorState());
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(GrocerySearchSuccessState(
            groceryMultiSearchProductList: right.data!.carts));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GrocerySearchErrorState());
    }
  }

  _onAddToShoppingList(GroceryAddToShoppingListEvent event,
      Emitter<FetchMealPlanState> emit) async {
    emit(GroceryAddToShoppingLoadingState(
        productId: event.productID,
        isAdd: event.isAdd,
        isRemove: event.isRemove));

    try {
      await _repository
          .recipeAddToShoppingList(
              mealmeStoreId: event.mealmeStoreId,
              price: event.price,
              productID: event.productID,
              productName: event.productName,
              quantity: event.quantity,
              recipeId: event.recipeId,
              unitOfMeasurement: event.unitOfMeasurement,
              isChecked: event.isChecked,
              unitSize: event.unitSize)
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(GroceryAddToShoppingSuccessState(
            isAdded: right.success ?? false,
            recipesAddToGroceryData: right.data,
            isAdd: event.isAdd,
            isRemove: event.isRemove));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GroceryAddToShoppingErrorState());
    }
  }

  /// ON FAIL

  onFailError(
      {required String text, required Emitter<FetchMealPlanState> emit}) {
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
