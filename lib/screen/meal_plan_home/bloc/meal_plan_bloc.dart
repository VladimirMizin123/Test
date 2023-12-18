import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_event.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_repository.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bloc/meal_plan_state.dart';

import '../../../repository/get_grocery_details.dart';
import '../../../widget/app_widget.dart';

class MealPlanBloc extends Bloc<MealPlanEvent, FetchMealPlanState> {
  MealPlanBloc() : super(InitialState()) {
    on<MealPlanFetchEvent>(_onFetchMealPlan);
    on<SkipMealPlanEvent>(_onSkipMealPlan);
    on<AddSwapMealEvent>(_onSwapMealPlan);
    on<AddToGroceryListEvent>(_onAddToGroceryList);
    on<FetchSwapMealItemEvent>(_onFetchSwapMealItem);
    on<FetchMealDetailsEvent>(_onFetchMealDetails);
    on<RestaurantSearchEvent>(_onRestaurantSearch);
    // on<SwapMealDetailsEvent>(_onSwapMealDetails);
    on<GroceryAddToShoppingListEvent>(_onAddToShoppingList);
    on<GrocerySearchEvent>(_onSearchItem);
    on<GetMealLogByDateEvent>(_onGetMealLogByDate);
    on<AddUserRestrictionEvent>(_onAddUserRestriction);
    on<BarcodeScanEvent>(_onScanBarcode);
    on<FetchMealDetailsByNameEvent>(_onFetchMealDetailsById);
    on<GetAllRestrictionEvent>(_onGetAllRestriction);
    on<GetUserRestrictionEvent>(_onGetUserRestriction);
    on<ClearUserGroceryMealPlanEvent>(_onClearGroceryList);
  }

  final MealPlanRepository _repository = MealPlanRepository();
  final AddNewGroceryItemRepository _repositoryGrocery =
      AddNewGroceryItemRepository();
  final box = GetStorage();
  // _onSwapMealDetails(SwapMealDetailsEvent event, Emitter<FetchMealPlanState> emit) async {
  //   emit(SwapMealDetailsState(similarMealData: event.similarMealData,dateTime: event.dateTime, day: event.day, mealId: event.mealId));
  // }

  _onClearGroceryList(ClearUserGroceryMealPlanEvent event,
      Emitter<FetchMealPlanState> emit) async {
    emit(ClearGroceryListLoadingState());

    try {
      await _repository.clearGroceryList().fold((left) async {
        // onFailError(emit: emit, text: left.errorMessage!);
        emit(ClearGroceryListErrorState());
        _repository.addGroceryToShoppingListFromSuggestic().fold((left) {
          onFailError(emit: emit, text: left.errorMessage!);
        }, (right) {
          showToast(isSuccess: true, message: 'Grocery Generated Successfully');
        });
      }, (right) {
        emit(ClearGroceryListSuccessState());
        // showToast(isSuccess: true, message: right.message ?? 'Added!');
      });
    } catch (e) {
      // showToast(isSuccess: false, message: e.toString());
      emit(ClearGroceryListErrorState());
    }
  }

  _onScanBarcode(
      BarcodeScanEvent event, Emitter<FetchMealPlanState> emit) async {
    emit(BarcodeScannerLoadingState());
    try {
      await _repository.fetchBarcode(event.barcode).fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(BarcodeScannerErrorState());
      }, (right) {
        emit(BarcodeScannerSuccessState(barcodeScannerData: right.data));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(BarcodeScannerErrorState());
    }
  }

  _onFetchMealDetailsById(FetchMealDetailsByNameEvent event,
      Emitter<FetchMealPlanState> emit) async {
    emit(NutritionixGetNxMealInfoByNameLoadingState());

    try {
      await _repository
          .groceryDetailsMealInfo(
        productName: event.recipeName!,
      )
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(NutritionixGetNxMealInfoByNameErrorState());
      }, (right) {
        log('RIGHT PART CALL - - - - - - - - - - - - ');

        emit(NutritionixGetNxMealInfoByNameSuccessState(
            nutritionixGetNxMealInfoByNameModelData: right.data!));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(NutritionixGetNxMealInfoByNameErrorState());
    }
  }

  _onFetchMealPlan(
      MealPlanFetchEvent event, Emitter<FetchMealPlanState> emit) async {
    emit(FetchMealPlanLoadingState());

    try {
      await _repository.fetchMealPlan().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(FetchMealPlanErrorState());
      }, (right) {
        print('------>>>>>>DATATATATATATATAT');

        box.write('mealPlan', right.data);

        emit(FetchMealPlanSuccessState(
            mealPlanList:
                right.data == null ? [] : right.data!.reversed.toList()));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());

      emit(FetchMealPlanErrorState());
    }
  }

  _onGetMealLogByDate(
      GetMealLogByDateEvent event, Emitter<FetchMealPlanState> emit) async {
    emit(OnGetMealLogByDateLoadingState());
    try {
      await _repository.getMealLogByDate(event.date!).fold(
        (left) async {
          log("LEFT");
          bool hasData = false;
          await _repositoryGrocery.getGroceryListData().fold((l) {
            log((l.errorMessage).toString(), name: "EMIT");

            onFailError(emit: emit, text: l.errorMessage!);
            emit(FetchMealPlanErrorState());
          }, (r) {
            log((r.data?.isNotEmpty ?? false).toString(), name: "EMIT");
            log((r.data ?? false).toString(), name: "EMIT");
            hasData = r.data?.isNotEmpty ?? false;
            // onFailError(
            //     emit: emit, text: left.errorMessage!, hasGrocery: hasData);

            emit(FetchMealPlanErrorState(hasGrocery: hasData));
          });
          // onFailError(emit: emit, text: left.errorMessage!);
        },
        (right) {
          _repositoryGrocery.getGroceryListData().fold((left) {
            log((left.errorMessage).toString(), name: "EMIT");

            onFailError(emit: emit, text: left.errorMessage!);
          }, (r) {
            log((r.data?.isNotEmpty ?? false).toString(), name: "EMIT");
            emit(OnGetMealLogByDateSuccessState(
                modelData: right.data,
                hasGrocery: r.data?.isNotEmpty ?? false));
          });
        },
      );
    } catch (e) {
      // showToast(isSuccess: false, message: e.toString());
      emit(FetchMealPlanErrorState());
    }
  }

  _onGetAllRestriction(
      GetAllRestrictionEvent event, Emitter<FetchMealPlanState> emit) async {
    emit(GetAllRestrictionLoadingState());
    try {
      final response = await _repository.getAllRestriction();
      response.fold((left) {
        emit(GetAllRestrictionErrorState());
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(GetAllRestrictionSuccessState(
            edgesRestrictionList:
                right.data.restrictions.edgesRestrictionList));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetAllRestrictionErrorState());
    }
  }

  _onGetUserRestriction(
      GetUserRestrictionEvent event, Emitter<FetchMealPlanState> emit) async {
    emit(GetUserRestrictionLoadingState());
    try {
      final response = await _repository.getUserRestriction();
      response.fold((left) {
        emit(GetUserRestrictionErrorState());
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(GetUserRestrictionSuccessState(edgesRestrictionList: right.data));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetUserRestrictionErrorState());
    }
  }

  _onAddUserRestriction(
      AddUserRestrictionEvent event, Emitter<FetchMealPlanState> emit) async {
    emit(AddRestrictionLoadingState());
    try {
      final response = await _repository.addUserRestriction(
          restrictionList: event.edgeRestrictionList ?? []);
      response.fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(AddRestrictionErrorState());
      }, (right) {
        showToast(isSuccess: false, message: right.message);
        emit(AddRestrictionSuccessState(data: right.data));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(AddRestrictionErrorState());
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

  _onSwapMealPlan(
      AddSwapMealEvent event, Emitter<FetchMealPlanState> emit) async {
    emit(SwapMealPlanLoadingState());

    try {
      await _repository
          .addSwapMeal(
        mealId: event.mealId,
        recipeId: event.recipeId,
      )
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        log('RIGHT PART CALL - - - - - - - - - - - - ');

        // emit(SwapMealPlanSuccessState(swapMealPlanData: right.success!, mealID: event.mealId!));
        emit(SwapMealDetailsState(
            similarMealData: event.similarMealData,
            dateTime: event.dateTime,
            day: event.day,
            mealId: event.mealId));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(SwapMealPlanErrorState());
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
              recipeID: event.recipeID!, recipeName: event.recipeName!)
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
      {required String text,
      required Emitter<FetchMealPlanState> emit,
      bool? hasGrocery}) {
    showToast(isSuccess: false, message: text);
    emit(FetchMealPlanErrorState(hasGrocery: hasGrocery ?? false));
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
