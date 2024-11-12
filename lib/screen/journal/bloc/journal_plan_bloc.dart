import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_repository.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_event.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_repository.dart';
import 'package:gymeats_mobile/screen/journal/bloc/journal_plan_state.dart';
import 'package:gymeats_mobile/service/api_urls.dart';

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
    on<GetMealLogByDateEvent>(_onGetMealLogByDate);
    on<UserInvoiceListEvent>(_onGetUserInvoiceList);
  }

  final JournalPlanRepository _repository = JournalPlanRepository();
  final GroceryRepository _grocery = GroceryRepository();

  _onSwapMealDetails(JournalSwapMealDetailsEvent event,
      Emitter<JournalMealPlanState> emit) async {
    try {
      String userID = PreferenceUtils.getString(prefUserData);
      final response = await _repository.apiServices.get(
          '${ApiUrls.addSwapMeal}/$userID?recipeId=${event.similarMealData?.id}&mealId=${event.mealId}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(JournalSwapMealDetailsState(
            similarMealData: event.similarMealData,
            day: event.day,
            mealId: event.mealId));
      }
    } catch (e) {
      log(e.toString());
    } finally {
      event.onComplete?.call();
    }
  }

  _onGetUserInvoiceList(
      UserInvoiceListEvent event, Emitter<JournalMealPlanState> emit) async {
    try {
      emit(UserInvoiceLoadingState(isLoading: true));
      Either<ErrorModel, List<String>> response =
          await _repository.getUserInvoiceList();
      if (response.isRight) {
        emit(UserInvoiceSuccessState(invoiceList: response.right));
      }
    } catch (e) {
      log(e.toString());
    } finally {
      emit(UserInvoiceLoadingState(isLoading: false));
    }
  }

  _onScanBarcode(
      JournalScanBarcodeEvent event, Emitter<JournalMealPlanState> emit) async {
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

  _onFetchMealPlan(
      JournalPlanFetchEvent event, Emitter<JournalMealPlanState> emit) async {
    emit(JournalFetchMealPlanLoadingState(value: true));

    try {
      await _repository.fetchMealPlan().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(JournalFetchMealPlanSuccessState(
            mealPlanList:
                right.data == null ? [] : right.data!.reversed.toList()));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(JournalFetchMealPlanErrorState());
    } finally {
      emit(JournalFetchMealPlanLoadingState(value: false));
    }
  }

  _onGetMealLogByDate(
      GetMealLogByDateEvent event, Emitter<JournalMealPlanState> emit) async {
    emit(OnGetMealLogByDateLoadingState());
    try {
      await _repository.getMealLogByDate(event.date ?? "").fold((left) {
        emit(OnGetMealLogByDateErrorState());
        // onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(OnGetMealLogByDateSuccessState(modelData: right.data));
      });
    } catch (e) {
      // showToast(isSuccess: false, message: e.toString());
      emit(OnGetMealLogByDateErrorState());
    }
  }

  _onSkipMealPlan(JournalSkipMealPlanEvent event,
      Emitter<JournalMealPlanState> emit) async {
    emit(JournalSkipMealPlanLoadingState());

    try {
      await _repository
          .skipMealPlan(
        mealId: event.mealID,
        calorie: event.calorie,
        carbs: event.carbs,
        date: event.date,
        fat: event.fat,
        mealName: event.mealName,
        mealType: event.mealType,
        noOfServing: event.noOfServing,
        protein: event.protein,
        recipeId: event.recipeId,
        value: event.value,
      )
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        log('RIGHT PART CALL - - - - - - - - - - - - ');

        emit(JournalSkipMealPlanSuccessState(mealID: event.mealID));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(JournalSkipMealPlanErrorState());
    }
  }

  _onAddToGroceryList(JournalAddToGroceryListEvent event,
      Emitter<JournalMealPlanState> emit) async {
    emit(JournalAddToGroceryLoadingState());

    try {
      await _repository
          .recipeAddToGrocery(databaseIdOfRecipes: event.databaseIdOfRecipes)
          .fold((left) {
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

  _onFetchSwapMealItem(JournalFetchSwapMealItemEvent event,
      Emitter<JournalMealPlanState> emit) async {
    emit(JournalFetchSwapMealLoadingState());

    try {
      await _repository
          .fetchSwapMealItem(
              recipeID: event.recipeID!, noOfServing: event.noOfServing!)
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        log('RIGHT PART CALL - - - - - - - - - - - - ');

        emit(JournalFetchSwapMealSuccessState(
            similarMealData: right.data.similarCaloriesRecipes));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(JournalFetchSwapMealErrorState());
    }
  }

  _onAddToShoppingList(JournalAddToShoppingListEvent event,
      Emitter<JournalMealPlanState> emit) async {
    emit(JournalAddToShoppingLoadingState(
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
        emit(JournalAddToShoppingSuccessState(
            isAdded: right.success ?? false,
            recipesAddToGroceryData: right.data,
            isAdd: event.isAdd,
            isRemove: event.isRemove));
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

  _onSearchItem(
      JournalSearchEvent event, Emitter<JournalMealPlanState> emit) async {
    emit(JournalSearchLoadingState());
    try {
      (double?, double?) pos = await Constant.i.position;
      await _repository
          .grocerySearch(
              latitude: '${pos.$1 ?? (event.getUserAddress?.latitude ?? 0)}',
              longitude: '${pos.$2 ?? (event.getUserAddress?.longitude ?? 0)}',
              grocerySearchModal: event.journalSearchModelList!,
              getUserAddress: event.getUserAddress)
          .fold((left) {
        emit(JournalSearchSuccessState(groceryMultiSearchProductList: []));
        emit(JournalSearchErrorState());
        onFailError(
            emit: emit,
            text: (left.errorMessage?.trim().isNotEmpty ?? false)
                ? left.errorMessage!
                : StringUtils.noDataFound);
      }, (right) async {
        List<Cart> cartList = right.data?.carts ?? [];
        emit(
            JournalSearchSuccessState(groceryMultiSearchProductList: cartList));

        List<Future> futureList = [];

        for (int i = 0; i < cartList.length; i++) {
          List<GroceryResult> groceryList = cartList[i].groceryResult ?? [];
          for (int j = 0; j < groceryList.length; j++) {
            List<Product> productList = groceryList[j].products ?? [];

            for (int k = 0; k < productList.length; k++) {
              futureList.add(_grocery
                  .groceryDetailsMealInfo(
                      productName: productList[k].itemName!, needCal: true)
                  .fold((left) {}, (right) {
                Map<String, dynamic> json = productList[k]
                    .toJson()
                    .map((key, value) => MapEntry(key, value));
                json["calorie"] = right.data?.nfCalories;
                productList[k] = Product.fromJson(json);
              }));
            }
          }
        }
        await Future.wait(futureList);
        emit(
            JournalSearchSuccessState(groceryMultiSearchProductList: cartList));
      });
    } catch (e) {
      // showToast(isSuccess: false, message: e.toString());
      emit(JournalSearchErrorState());
    }
  }

  _onAddEaten(
      JournalAddToEatenEvent event, Emitter<JournalMealPlanState> emit) async {
    emit(JournalAddEatenLoadingState(
        mealID: event.mealId ?? (event.mealName ?? '')));
    try {
      await _repository
          .addEatenMeal(
              mealId: event.mealId,
              calorie: event.calorie,
              carbs: event.carbs,
              fat: event.fat,
              mealName: event.mealName,
              mealType: event.mealType,
              noOfServing: event.noOfServing,
              protein: event.protein,
              recipeId: event.recipeId)
          .fold((left) {
        emit(JournalSearchErrorState());
        onFailError(emit: emit, text: left.errorMessage ?? "");
      }, (right) {
        emit(JournalAddEatenSuccessState(
            isAdded: right.success,
            mealID: event.mealId ?? (event.mealName ?? "")));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(JournalAddEatenErrorState());
    }
  }

  /// ON FAIL

  onFailError(
      {required String text, required Emitter<JournalMealPlanState> emit}) {
    if (text.trim().isNotEmpty) {
      showToast(isSuccess: false, message: text);
    }

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
