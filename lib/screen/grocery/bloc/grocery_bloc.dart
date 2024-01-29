import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_bloc.dart';
import 'package:gymeats_mobile/bloc/grocery/add_new_grocery/add_new_grocery_event.dart';
import 'package:gymeats_mobile/screen/appmanager/app_manager_screen.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_repository.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class GroceryBloc extends Bloc<GroceryEvent, GroceryState> {
  GroceryBloc() : super(InitialState()) {
    // on<AddGroceryToShoppingListFromSuggesticEvent>(_onAddGroceryToShoppingListFromSuggestic);
    on<GroceryFetchEvent>(_onFetchGroceryItem);
    on<GroceryAddToShoppingListEvent>(_onAddToShoppingList);
    on<RemoveGroceryEvent>(_onRemoveShoppingItem);
    on<GrocerySearchEvent>(_onSearchItem);
    on<GroceryDetailsMealInfoEvent>(_onGroceryDetailsMealInfo);
    on<GrocerySelectedStoreEvent>(_onGrocerySelectedStoreEvent);
    on<GroceryProductListEvent>(_onGroceryProductList);
    on<CleatGroceryEvent>(_onClearShoppingList);
    on<BarcodeScanEvent>(_onScanBarcode);
    on<AddNewCustomMealEvent>(_onAddCustomMeal);
    on<GetUserAddressEvent>(_onGetUserAddress);
    on<CreateOrderEvent>(_onCreateOrder);
    on<CreateProductEvent>(_onCreateProduct);
    on<CreateCheckoutEvent>(_onCreateCheckout);
    on<GetDeliveryStatusEvent>(_onGetDeliveryStatus);
  }

  final GroceryRepository _repository = GroceryRepository();

  _onGroceryProductList(
      GroceryProductListEvent event, Emitter<GroceryState> emit) async {
    emit(GroceryProductListState(
        productList: event.productList, productId: event.productId));
  }

  _onScanBarcode(BarcodeScanEvent event, Emitter<GroceryState> emit) async {
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

  _onAddCustomMeal(
      AddNewCustomMealEvent event, Emitter<GroceryState> emit) async {
    emit(AddNewCustomMealLoadingState());
    try {
      await _repository
          .addNewCustomMeal(
              calorie: event.calorie,
              carbs: event.carbs,
              fat: event.fat,
              name: event.name,
              protein: event.protein,
              type: event.type)
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(AddNewCustomMealErrorState());
      }, (right) {
        emit(AddNewCustomMealSuccessState(isAdded: right.success));
        showToast(isSuccess: false, message: right.message!);
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(AddNewCustomMealErrorState());
    }
  }

  _onFetchGroceryItem(
      GroceryFetchEvent event, Emitter<GroceryState> emit) async {
    emit(GroceryFetchLoadingState());

    try {
      await _repository.fetchGroceryShoppingList().fold((left) {
        emit(GroceryErrorState());
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(GroceryFetchSuccessState(
            edgesList: right.data == null ? [] : right.data!));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GroceryErrorState());
    }
  }

  _onAddToShoppingList(
      GroceryAddToShoppingListEvent event, Emitter<GroceryState> emit) async {
    emit(GroceryAddToShoppingLoadingState(
        productId: event.productID,
        isAdd: event.isAdd,
        isRemove: event.isRemove));

    try {
      await _repository
          .recipeAddToGrocery(
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
        emit(GroceryAddToShoppingErrorState());
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

  _onRemoveShoppingItem(
      RemoveGroceryEvent event, Emitter<GroceryState> emit) async {
    emit(RemoveGroceryLoadingState(productId: event.productID));

    try {
      await _repository.removeGrocery(productID: event.productID!).fold((left) {
        emit(RemoveGroceryErrorState(productID: event.productID));
        onFailError(emit: emit, text: left.errorMessage!);
        emit(RemoveGroceryErrorState(productID: event.productID));
      }, (right) {
        emit(RemoveGrocerySuccessState(
            productID: event.productID, isDelete: right.success));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(RemoveGroceryErrorState(productID: event.productID));
    }
  }

  _onSearchItem(GrocerySearchEvent event, Emitter<GroceryState> emit) async {
    emit(GrocerySearchLoadingState());
    try {
      await _repository
          .grocerySearch(
              latitude: PreferenceUtils.getString(latitude).isNotEmpty
                  ? PreferenceUtils.getString(latitude)
                  : '41.881832',
              longitude: PreferenceUtils.getString(longitude).isNotEmpty
                  ? PreferenceUtils.getString(longitude)
                  : '-87.623177',
              grocerySearchModal: event.grocerySearchModelList!,
              getUserAddress: event.getUserAddress)
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

  _onGroceryDetailsMealInfo(
      GroceryDetailsMealInfoEvent event, Emitter<GroceryState> emit) async {
    emit(GroceryNutritionixGetNxMealInfoByNameLoadingState());

    try {
      await _repository
          .groceryDetailsMealInfo(productName: event.groceryProductName!)
          .fold((left) {
        emit(GrocerySearchErrorState());
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(GroceryNutritionixGetNxMealInfoByNameSuccessState(
            nutritionixGetNxMealInfoByNameModelData: right.data!));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GroceryNutritionixGetNxMealInfoByNameErrorState());
    }
  }

  _onGrocerySelectedStoreEvent(
      GrocerySelectedStoreEvent event, Emitter<GroceryState> emit) async {
    emit(
        GrocerySelectedStoreEventState(productsList: event.productsList ?? []));
  }

  _onClearShoppingList(
      CleatGroceryEvent event, Emitter<GroceryState> emit) async {
    emit(ClearShoppingListLoadingState());

    try {
      await _repository.clearShoppingList().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(GroceryAddToGroceryErrorState());
      }, (right) {
        log('RIGHT PART CALL - - - - - - - - - - - - ');

        emit(ClearShoppingListSuccessState(isClear: right.success ?? true));
        showToast(isSuccess: true, message: right.message ?? 'Added!');
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GroceryAddToGroceryErrorState());
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

  // Get Grocery Item Bloc =================================================================
  _onGetUserAddress(
      GetUserAddressEvent event, Emitter<GroceryState> emit) async {
    emit(GetUserAddressLoadingState());

    try {
      await _repository.getUserAddressData().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(GetUserAddressSuccessState(userAddress: right.data ?? []));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetUserAddressErrorState());
    }
  }

  // Create Order Bloc ==============================================================================

  _onCreateOrder(CreateOrderEvent event, Emitter<GroceryState> emit) async {
    emit(CreateOrderLoadingState());

    try {
      await _repository
          .createOrder(createOrderModel: event.createGroceryOrderModel)
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        showToast(isSuccess: false, message: left.errorMessage ?? "");

        emit(CreateOrderErrorState());
      }, (right) async {
        emit(CreateOrderSuccessState(orderData: right.data));

        /// After order success
        Get.offAll(
          () => const AppManagerScreen(selectIndex: 2),
        );
        Get.toNamed('/OrderHistoryScreen');
        showToast(
            isSuccess: true,
            message: right.message ?? "Order Created Successfully");

        ///call Clear Shopping List api
        ///
        if (event.orderId != null) {
          event.orderId!.forEach((element) {
            AddNewGroceryItemBloc().add(
              RemoveGroceryItemEvent(
                userGroceryListId: element.id,
              ),
            );
          });
        }

        /// Clear All List
        /* await _repository.clearShoppingList().fold((left) {}, (right) {});*/
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(CreateOrderErrorState());
    }
  }

  // Create Product Bloc ==============================================================================

  _onCreateProduct(CreateProductEvent event, Emitter<GroceryState> emit) async {
    emit(CreateProductLoadingState());

    try {
      await _repository
          .createProduct(
              createProductRequestModel: event.createProductRequestModel)
          .fold((left) {
        emit(CreateProductErrorState());
        onFailError(emit: emit, text: left.errorMessage!);
        showToast(isSuccess: false, message: left.errorMessage ?? "");
        emit(CreateProductErrorState());
      }, (right) {
        emit(CreateProductSuccessState(productData: right.data));
        // showToast(isSuccess: true, message: right.message ?? "");
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(CreateProductErrorState());
    }
  }

  // Create Product Bloc ==============================================================================

  _onCreateCheckout(
      CreateCheckoutEvent event, Emitter<GroceryState> emit) async {
    emit(CreateCheckoutLoadingState());

    try {
      await _repository
          .createCheckout(
              createCheckOutRequestModel: event.createCheckOutRequestModel)
          .fold((left) {
        emit(CreateCheckoutErrorState());
        onFailError(emit: emit, text: left.errorMessage!);
        showToast(isSuccess: false, message: left.errorMessage ?? "");
      }, (right) {
        emit(CreateCheckoutSuccessState(data: right.data));
        // showToast(isSuccess: true, message: right.message ?? "");
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(CreateCheckoutErrorState());
    }
  }

  // Get Delivery Status Bloc ==============================================================================

  _onGetDeliveryStatus(
      GetDeliveryStatusEvent event, Emitter<GroceryState> emit) async {
    emit(GetDeliveryStatusLoadingState());

    try {
      await _repository.getDeliveryStatus().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(GetDeliveryStatusErrorState());
        showToast(isSuccess: false, message: left.errorMessage ?? "");
      }, (right) {
        emit(GetDeliveryStatusSuccessState(data: right.data ?? {}));
        // showToast(isSuccess: true, message: right.message ?? "");
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetDeliveryStatusErrorState());
    }
  }
}
