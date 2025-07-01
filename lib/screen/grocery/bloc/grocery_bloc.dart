import 'dart:convert';
import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/extention/ext_on_list.dart';
import 'package:gymeats_mobile/models/available_store_model.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_event.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_repository.dart';
import 'package:gymeats_mobile/screen/grocery/bloc/grocery_state.dart';
import 'package:gymeats_mobile/screen/grocery/modal/create_order_request_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/meal_plan_home/bottomsheet/receive_order_ask_bottomsheet.dart';
import 'package:gymeats_mobile/screen/restaurants/checkout_screen.dart';
import 'package:gymeats_mobile/screen/restaurants/model/categorie_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/near_by_store_model.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/food_menu_address.dart';

class GroceryBloc extends Bloc<GroceryEvent, GroceryState> {
  GroceryBloc() : super(InitialState()) {
    // on<AddGroceryToShoppingListFromSuggesticEvent>(_onAddGroceryToShoppingListFromSuggestic);
    on<GroceryFetchEvent>(_onFetchGroceryItem);
    on<GroceryAddToShoppingListEvent>(_onAddToShoppingList);
    on<RemoveGroceryEvent>(_onRemoveShoppingItem);
    on<GrocerySearchEvent>(_onSearchItem);
    on<StoreNearByEvent>(_onNearByStore);
    on<StoreByNameEvent>(_onGetStoreByName);
    on<GroceryDetailsMealInfoEvent>(_onGroceryDetailsMealInfo);
    on<GrocerySelectedStoreEvent>(_onGrocerySelectedStoreEvent);
    on<GroceryProductListEvent>(_onGroceryProductList);
    on<BarcodeScanEvent>(_onScanBarcode);
    on<AddNewCustomMealEvent>(_onAddCustomMeal);
    on<GetUserAddressEvent>(_onGetUserAddress);
    on<CreateOrderEvent>(_onCreateOrder);
    on<CreateProductEvent>(_onCreateProduct);
    on<CreateCheckoutEvent>(_onCreateCheckout);
    on<GetDeliveryStatusEvent>(_onGetDeliveryStatus);
    on<CreateMultipleOrderEvent>(_onMultipleOrderCreate);
    on<StoreCategorieEvent>(_onGetStoreCategorie);
    on<StoreSubCategorieEvent>(_onGetStoreSubCategorie);
    on<StoreVerifyEvent>(_onStoreVerify);
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
        type: event.type,
        date: DateTime.now().toIso8601String(),
      )
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
        getUserAddress: event.getUserAddress,
        askReceiveOrder: event.askReceiveOrder,
      )
          .fold((left) {
        emit(GrocerySearchErrorState());
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) async {
        emit(GroceryPageLoaderState(isLoading: true));
        List<Cart> verifyCartList = [];

        int totalPage = ((right.data?.carts?.length ?? 0) / 5).ceil();
        for (int i = 0; i < totalPage; i++) {
          List<int> array = [];
          for (int j = 0; j < 5; j++) {
            int index = (i * 5) + j;
            if (index < (right.data?.carts?.length ?? 0)) {
              array.add(index);
            }
          }
          if (!isClosed) {
            (double?, double?) pos = await Constant.i.position;

            Map<String, dynamic> requestData = {
              "latitude": pos.$1 ?? event.getUserAddress?.latitude,
              "longitude": pos.$2 ?? event.getUserAddress?.longitude,
              "pickup": event.askReceiveOrder?.index == 1,
              "store_Id":
                  array.map((e) => right.data?.carts?[e].store?.id).toList(),
            };
            final response = await ApiServices()
                .post(ApiUrls.getAvailableGroceryStoreList, requestData);
            AvailableStoreModel store =
                AvailableStoreModel.fromJson(jsonDecode(response.body));
            if (store.data?.stores?.isNotEmpty ?? false) {
              verifyCartList.addAll(right.data?.carts
                      ?.where((element) =>
                          store.data?.stores
                              ?.any((e) => e.storeId == element.store?.id) ??
                          false)
                      .toList() ??
                  []);
              emit(GrocerySearchSuccessState(
                  groceryMultiSearchProductList: verifyCartList));
            }
          } else {
            break;
          }
        }
        emit(GroceryPageLoaderState(isLoading: false));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GrocerySearchErrorState());
    }
  }

  _onStoreVerify(StoreVerifyEvent event, Emitter<GroceryState> emit) async {
    try {
      Map<String, dynamic> req = PreferenceUtils.getMenuAddress();
      final value =
          Constant.i.requiredAddressField.every((e) => req.containsKey(e));

      if (!value) {
        dynamic result = await showModalBottomSheet(
          context: event.context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          isScrollControlled: true,
          builder: (context) => FoodMenuAddress(request: req),
        );
        if (result != true) {
          return;
        }
      }
      emit(VerifyLoader(id: event.id));

      DateTime time = DateTime.now();

      // (double?, double?) pos = await Constant.i.position;

      log("Take Time : ${DateTime.now().difference(time).inSeconds}.${DateTime.now().difference(time).inMilliseconds % 1000}");

      Either<ErrorModel, CategorieModel> categoriesRes =
          await _repository.getStoreCategorieList(event.getUserAddress,
              event.askReceiveOrder?.index, event.id ?? "",
              name: event.name ?? "");

      emit(VerifyLoader(id: null));
      if (event.id != prevId) {
        return;
      }
      await Future.delayed(const Duration(milliseconds: 200));
      if (event.id != prevId) {
        return;
      }

      if (categoriesRes.isLeft) {
        if (categoriesRes.left.errorMessage != null) {
          showToast(
              isSuccess: false, message: categoriesRes.left.errorMessage ?? "");
        } else {
          showToast(isSuccess: false, message: StringUtils.storeNotAvailable);
        }
        event.notVerify?.call();
      } else {
        if (categoriesRes.isRight && (categoriesRes.right.success ?? false)) {
          event.onVerify
              ?.call(categoriesRes.isRight ? categoriesRes.right : null);
        } else {
          if (categoriesRes.right.errorMessage != null) {
            showToast(
                isSuccess: false,
                message: categoriesRes.right.errorMessage ?? "");
          } else {
            showToast(isSuccess: false, message: StringUtils.storeNotAvailable);
          }
          event.notVerify?.call();
        }
      }
    } catch (e) {
      emit(VerifyLoader(id: null));
      if (event.id == prevId) {
        showToast(isSuccess: false, message: StringUtils.storeNotAvailable);
      }
    }
  }

  _onNearByStore(StoreNearByEvent event, Emitter<GroceryState> emit) async {
    emit(GrocerySearchLoadingState());
    try {
      String prefKey = groceryBring;
      // if (event.askReceiveOrder == AskReceiveOrder.bringTheOrder) {
      //   prefKey = groceryBring;
      // } else {
      //   prefKey = groceryPickup;
      // }
      Either<ErrorModel, NearByStoreModel> res =
          await _repository.nearByStoreSearch(
        getUserAddress: event.getUserAddress,
        askReceiveOrder: event.askReceiveOrder,
      );

      if (res.isLeft) {
        emit(GrocerySearchErrorState());
        onFailError(emit: emit, text: res.left.errorMessage!);
      } else {
        log("Set Cache : $prefKey");
        PreferenceUtils.setString(prefKey, jsonEncode(res.right.data));
        emit(NearByStoreSuccessState(storeList: res.right.data));
        emit(NearByStoreLoaderState(isLoading: false));
      }
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(NearByStoreErrorState(message: e.toString()));
    }
  }

  String? prevName;
  String? prevId;

  _onGetStoreByName(StoreByNameEvent event, Emitter<GroceryState> emit) async {
    emit(GrocerySearchLoadingState());
    try {
      prevName = event.name;
      if (prevName?.trim().isNotEmpty ?? false) {
        await _repository
            .getStoreByName(
          latitude: PreferenceUtils.getString(latitude).isNotEmpty
              ? PreferenceUtils.getString(latitude)
              : '41.881832',
          longitude: PreferenceUtils.getString(longitude).isNotEmpty
              ? PreferenceUtils.getString(longitude)
              : '-87.623177',
          getUserAddress: event.getUserAddress,
          askReceiveOrder: event.askReceiveOrder,
          name: event.name,
        )
            .fold((left) {
          emit(GrocerySearchErrorState());
          onFailError(emit: emit, text: left.errorMessage!);
        }, (right) async {
          if (event.name == prevName) {
            emit(NearByStoreSuccessState(storeList: right.data));
            emit(NearByStoreLoaderState(isLoading: false));
          }
        });
      } else {
        emit(NearByStoreLoaderState(isLoading: false));
      }
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(NearByStoreErrorState(message: e.toString()));
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
    print('_onCreateOrder STARTED');
    emit(CreateOrderLoadingState(isLoading: true));
    print('Emitted CreateOrderLoadingState(isLoading: true)');

    try {
      print('Calling _repository.createOrder...');
      await _repository
          .createOrder(createOrderModel: event.createGroceryOrderModel)
          .fold((left) async {
        print('Repository returned failure: ${left.errorMessage}');
        showToast(isSuccess: false, message: left.errorMessage ?? "");
        emit(CreateOrderErrorState());
        print('Emitted CreateOrderErrorState');
      }, (right) async {
        print('Repository returned success: ${right.message}');
        if (event.onSuccess != null) {
          print('Calling onSuccess callback');
          event.onSuccess?.call(right.data);
        } else {
          print('Emitting CreateOrderSuccessState');
          emit(CreateOrderSuccessState(orderData: right.data));
        }

        showToast(
          isSuccess: true,
          message: right.message ?? "Order Created Successfully",
        );
      });
    } catch (e, stack) {
      print('Exception caught in _onCreateOrder: $e');
      print('Stack trace: $stack');
      showToast(isSuccess: false, message: e.toString());
      emit(CreateOrderErrorState());
      print('Emitted CreateOrderErrorState from catch');
    } finally {
      emit(CreateOrderLoadingState(isLoading: false));
      print('Emitted CreateOrderLoadingState(isLoading: false)');
      print('_onCreateOrder FINISHED');
    }
  }

  _onMultipleOrderCreate(
      CreateMultipleOrderEvent event, Emitter<GroceryState> emit) async {
    try {
      emit(CreateOrderLoadingState());
      List<CreateOrderGroceryItems> uniqueStore = event.data
          .map((e) => e)
          .toList()
          .unique((element) => element.storeId);

      for (int i = 0; i < uniqueStore.length; i++) {
        log("Started ${i + 1}");
        bool isLastElement = i == uniqueStore.length - 1;

        var res = await GroceryRepository().createOrder(
          createOrderModel: CreateGroceryOrderModel(
            userId: userId,
            pickup: event.askReceiveOrder == 0 ? false : true,
            groceryItems: event.data
                .where((element) => element.storeId == uniqueStore[i].storeId)
                .toList(),
            userAddress: UserAddress(
              streetName: event.address?.streetName ?? '',
              streetNum: event.address?.streetNum ?? '',
              latitude: (event.address?.latitude ?? 0.0),
              longitude: (event.address?.longitude ?? 0.0),
              city: event.address?.city ?? '',
              country: event.address?.country ?? '',
              state: event.address?.state ?? "",
              zipcode: event.address?.zipcode ?? '',
            ),
            userPhone: 1234567890,
            driverTipCents: 0,
            pickupTipCents: 0,
            userDropoffNotes: '',
          ),
        );
        if (res.isRight) {
          var result = await Get.to(
            () => CheckOutScreen(
              isFromGrocery: true,
              cartData: event.selectedStoreProductList
                  .where((element) =>
                      element.store?.name == uniqueStore[i].storeId)
                  .toList(),
              orderData: res.right.data,
              getUserAddress: event.address,
              groceryList: event.edgesList
                      ?.where((element) =>
                          element.product?.storeName == uniqueStore[i].storeId)
                      .toList() ??
                  [],
              hasMultipleStore: !isLastElement,
              createMultipleOrder: uniqueStore.length > 1 && isLastElement,
            ),
          );

          if (result == true) {
            showToast(
              message:
                  "Order#${i + 1} of ${uniqueStore.length} is succesfully placed. Now preparing Order#${i + 2} of ${uniqueStore.length}",
              isSuccess: true,
              timeInSecForIosWeb: 3,
            );
            continue;
          } else {
            break;
          }
        } else {
          onFailError(emit: emit, text: res.left.errorMessage!);
          showToast(isSuccess: false, message: res.left.errorMessage ?? "");
        }
      }
    } catch (e) {
      log(e.toString());
    } finally {
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

  _onGetStoreCategorie(
      StoreCategorieEvent event, Emitter<GroceryState> emit) async {
    try {
      emit(CategorieLoaderState(loader: true));
      await _repository
          .getStoreCategorieList(
              event.address, event.askReceiveOrder, event.storeId)
          .fold(
        (left) => {},
        (right) {
          emit(CategorieSuccessState(categoriesList: right));
        },
      );
    } catch (e) {
      log(e.toString());
    } finally {
      emit(CategorieLoaderState(loader: false));
    }
  }

  _onGetStoreSubCategorie(
      StoreSubCategorieEvent event, Emitter<GroceryState> emit) async {
    try {
      emit(SubCategorieLoaderState(loader: true));
      await _repository
          .getMenuList(event.address, event.askReceiveOrder, event.storeId,
              event.subcategoryId)
          .fold(
        (left) => {},
        (right) {
          emit(
            SubCategorySuccessState(
              subcategoryList: right.data?.categories ?? [],
              subcategoryId: event.subcategoryId,
            ),
          );
        },
      );
    } catch (e) {
      log(e.toString());
    } finally {
      emit(SubCategorieLoaderState(loader: false));
    }
  }
}
