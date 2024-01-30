import 'dart:convert';
import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/repository/get_restaurant_details.dart';
import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';
import 'package:gymeats_mobile/screen/grocery/modal/nutritionix_get_nx_meal_info_by_name_modal.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_state.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';
import 'package:gymeats_mobile/service/hive_singleton.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  RestaurantBloc() : super(InitialState()) {
    on<GetUserAddressEvent>(_onGetUserAddress);
    on<GetRestaurantListEvent>(_onGetRestaurantList);
    on<GetRestaurantMenuListEvent>(_onGetRestaurantMenuList);
    on<GetCousinesEvent>(_onGetCousinesList);
    on<AddRestaurantCartEvent>(_onAddToShoppingList);
    on<GetShoppingListEvent>(_onFetchShoppingList);
    on<UpdateRestaurantCartEvent>(_onUpdateShoppingList);
    on<RemoveShoppingListItemEvent>(_onRemoveShoppingList);
    on<CreateOrderEvent>(_onCreateOrder);
    on<CreateProductEvent>(_onCreateProduct);
    on<CreateCheckoutEvent>(_onCreateCheckout);
    on<GetOrderDetailsEvent>(_onGetOrderDetails);
    on<GetDeliveryStatusEvent>(_onGetDeliveryStatus);
    on<UpdateDeliveryStatusEvent>(_onUpdateDeliveryStatus);
    on<ClearShoppingListItemEvent>(_onClearShoppingList);
    on<MealPlanMatchEvent>(_onMatchMealPlan);
    on<CheckDeliverableGroceryEvent>(_onCheckDeliverableGroceryStore);
  }

  final RestaurantRepository _repository = RestaurantRepository();

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>RESTAURANT PART<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  // Get Grocery Item Bloc =================================================================
  _onGetUserAddress(
      GetUserAddressEvent event, Emitter<RestaurantState> emit) async {
    emit(GetUserAddressLoadingState());

    try {
      await _repository.getUserAddressData().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(GetUserAddressErrorState());
      }, (right) {
        emit(GetUserAddressSuccessState(userAddress: right.data ?? []));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetUserAddressErrorState());
    }
  }

  // Get Restaurant List Bloc =================================================================
  _onGetRestaurantList(
      GetRestaurantListEvent event, Emitter<RestaurantState> emit) async {
    emit(GetRestaurantListLoadingState());

    try {
      await _repository
          .getRestaurantListData(
        latitude: event.latitude,
        longitude: event.longitude,
        maximumMiles: event.maximumMiles,
        pickup: event.pickup,
        userCity: event.userCity,
        userCountry: event.userCountry,
        userState: event.userState,
        userStreetName: event.userStreetName,
        userStreetNum: event.userStreetNum,
        userZipcode: event.userZipcode,
        categoriesData: event.categotyData,
      )
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(GetRestaurantListErrorState());
      }, (right) {
        emit(GetRestaurantListSuccessState(restaurantList: right.data ?? []));
      });
    } catch (e) {
      // showToast(isSuccess: false, message: e.toString());
      emit(GetRestaurantListErrorState());
    }
  }

  // Get Restaurant Menu List Bloc  =================================================================
  _onGetRestaurantMenuList(
      GetRestaurantMenuListEvent event, Emitter<RestaurantState> emit) async {
    emit(GetRestaurantMenuListLoadingState());

    try {
      await _repository
          .getRestaurantMenuList(
              restaurantId: event.restaurantId,
              pickup: event.pickUp,
              mealType: event.mealType,
              getUserAddress: event.getUserAddress)
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(GetRestaurantMenuListErrorState());
      }, (right) async {
        emit(
            GetRestaurantMenuListSuccessState(restaurantMenuList: right.data!));
      });
    } catch (e) {
      // showToast(isSuccess: false, message: e.toString());
      emit(GetRestaurantMenuListErrorState());
    }
  }

  _onMatchMealPlan(
      MealPlanMatchEvent event, Emitter<RestaurantState> emit) async {
    if (state is GetRestaurantMenuListSuccessState) {
      GetRestaurantMenuListSuccessState successState =
          state as GetRestaurantMenuListSuccessState;
      RestaurantMenu menu = successState.restaurantMenuList;
      List<Category> categories = menu.categories ?? [];
      emit(GetRestaurantMenuListLoadingState());
      try {
        final HiveSingleton hive = HiveSingleton();
        List<Future<dynamic>> futureList = [];

        List<MenuItemList> menuItem = categories
                .firstWhereOrNull(
                    (element) => element.subcategoryId == event.subcategoryId)
                ?.menuItemList ??
            [];
        HiveSingleton hiveSingleton = HiveSingleton();
        for (int j = 0; j < menuItem.length; j++) {
          MenuItemList menu = menuItem[j];
          dynamic response = await hive.getValueByKey(menu.name ?? "");

          if (response != null && (response is Map)) {
            menu.mealInfoData =
                NutritionixGetNxMealInfoByNameModelData.fromJson(response);
          } else {
            String apiURL =
                '${ApiUrls.getNxMealInfoByName}?name=${menu.name?.replaceAll("&", "%26")}';
            futureList.add(
              _repository.apiServices.get(apiURL).then(
                (value) async {
                  if (value.statusCode == 200 || value.statusCode == 201) {
                    Map<String, dynamic> json = jsonDecode(value.body);
                    if (menu.name != null) {
                      await hiveSingleton.addValueToBox(
                          menu.name!, json["data"]);
                    }
                    menu.mealInfoData =
                        NutritionixGetNxMealInfoByNameModelData.fromJson(
                            json["data"] ?? {});
                  } else {
                    Map<String, dynamic> json = jsonDecode(value.body);
                    if (json["data"] == null) {
                      String apiNutritionixURL =
                          '${ApiUrls.getNxSearchData}?branded=true&common=false&query=${menu.name?.replaceAll("&", "%26")}';
                      final responseNutritionix = await _repository.apiServices
                          .getNutritionix(apiNutritionixURL);

                      Map<String, dynamic> jsonNutritionix =
                          jsonDecode(responseNutritionix.body);
                      if (jsonNutritionix["branded"] is List) {
                        List brandedList = jsonNutritionix["branded"] as List;
                        if (brandedList.isNotEmpty) {
                          Map menuMap = brandedList.first as Map;
                          menuMap = menuMap.map((key, value) =>
                              MapEntry("$key".camelCase, value));
                          menuMap["foodName"] = menu.name;
                          if (menu.name != null) {
                            await hiveSingleton.addValueToBox(
                                menu.name!, menuMap);
                          }
                          menu.mealInfoData =
                              NutritionixGetNxMealInfoByNameModelData.fromJson(
                                  menuMap);
                          await _repository.apiServices
                              .post(ApiUrls.addNutritionDataToDb, menuMap);
                        }
                      }
                    }
                  }
                },
              ),
            );
          }
        }
        await Future.wait(futureList);
      } catch (e) {
        log(e.toString());
      }
      emit(GetRestaurantMenuListSuccessState(restaurantMenuList: menu));
    }
  }

  // Get Cousines Bloc ==============================================================================

  _onGetCousinesList(
      GetCousinesEvent event, Emitter<RestaurantState> emit) async {
    emit(GetCousinesListLoadingState());

    try {
      await _repository
          .getCousinesListData(
        latitude: event.latitude,
        longitude: event.longitude,
        maximumMiles: event.maximumMiles,
        pickup: event.pickup,
        userCity: event.userCity,
        userCountry: event.userCountry,
        userState: event.userState,
        userStreetName: event.userStreetName,
        userStreetNum: event.userStreetNum,
        userZipcode: event.userZipcode,
      )
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(GetCousinesListErrorState());
      }, (right) {
        emit(GetCousinesListSuccessState(cousinesList: right.data!));
      });
    } catch (e) {
      // showToast(isSuccess: false, message: e.toString());
      emit(GetCousinesListErrorState());
    }
  }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>RESTAURANT PART END<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>SHOPPING LIST PART<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  // Add Restaurant Item to cart Bloc ==============================================================================

  _onAddToShoppingList(
      AddRestaurantCartEvent event, Emitter<RestaurantState> emit) async {
    emit(AddToRestaurantCartLoadingState(
        productId: event.addItemsList[0].productId!));

    try {
      await _repository
          .addMenuToCartRestaurant(addItemsToShoppingList: event.addItemsList)
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(AddToRestaurantCartErrorState(
            productId: event.addItemsList[0].productId!));
      }, (right) {
        showToast(isSuccess: true, message: right.message!);
        emit(AddToRestaurantCartSuccessState(
            isAdded: right.success ?? true, data: right.data));
      });
    } catch (e) {
      log('e---------->>>>>> $e');

      showToast(isSuccess: false, message: e.toString());
      emit(AddToRestaurantCartErrorState(
          productId: event.addItemsList[0].productId!));
    }
  }

  // Get Shopping List Bloc =========================================================================================

  _onFetchShoppingList(
      GetShoppingListEvent event, Emitter<RestaurantState> emit) async {
    emit(GetShoppingListLoadingState());

    try {
      await _repository.getShoppingList().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(GetShoppingListErrorState());
      }, (right) {
        emit(
          GetShoppingListSuccessState(
              shoppingListData:
                  right.data == [] || right.data == null ? [] : right.data!),
        );
      });
    } catch (e) {
      // showToast(isSuccess: false, message: e.toString());
      emit(GetShoppingListErrorState());
    }
  }

  // Update Restaurant Item to cart Bloc ============================================================================

  _onUpdateShoppingList(
      UpdateRestaurantCartEvent event, Emitter<RestaurantState> emit) async {
    emit(UpdateToRestaurantCartLoadingState(
        productId: event.updateItemList.oldProductId!));

    try {
      await _repository
          .updateMenuToCartRestaurant(
              updateItemsToShoppingList: event.updateItemList)
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(UpdateToRestaurantCartErrorState(
            productId: event.updateItemList.oldProductId!));
      }, (right) {
        log('----DATA------PRICE--->>>>>>>>${right.data['price']}');
        log('----DATA------QUANTITY--->>>>>>>>${right.data['quantity']}');
        showToast(isSuccess: true, message: right.message!);
        emit(UpdateToRestaurantCartSuccessState(
            isAdded: right.success ?? true, data: right.data));
      });
    } catch (e) {
      log('e---------->>>>>> $e');

      showToast(isSuccess: false, message: e.toString());
      emit(UpdateToRestaurantCartErrorState(
          productId: event.updateItemList.oldProductId!));
    }
  }

  // Remove Shopping List Item Bloc =========================================================================================

  _onRemoveShoppingList(
      RemoveShoppingListItemEvent event, Emitter<RestaurantState> emit) async {
    emit(RemoveShoppingListItemLoadingState(productId: event.productID));

    try {
      await _repository.removeShoppingListItem(productID: event.productID).fold(
          (left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(RemoveShoppingListItemErrorState(productId: event.productID));
      }, (right) {
        emit(
          RemoveShoppingListItemSuccessState(productId: event.productID),
        );
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(RemoveShoppingListItemErrorState(productId: event.productID));
    }
  }

  // Clear Shopping List Item Bloc =========================================================================================

  _onClearShoppingList(
      ClearShoppingListItemEvent event, Emitter<RestaurantState> emit) async {
    emit(ClearShoppingListItemLoadingState());

    try {
      await _repository.clearShoppingListItem().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(ClearShoppingListItemErrorState());
      }, (right) {
        emit(ClearShoppingListItemSuccessState());
      });
    } catch (e) {
      emit(ClearShoppingListItemErrorState());
    }
  }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>SHOPPING LIST PART END<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>PAYMENT PART START<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  // Create Order Bloc ==============================================================================

  _onCreateOrder(CreateOrderEvent event, Emitter<RestaurantState> emit) async {
    emit(CreateOrderLoadingState());

    try {
      await _repository
          .createOrder(createOrderModel: event.createOrderModel)
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(CreateOrderErrorState());
        showToast(isSuccess: false, message: left.errorMessage ?? "");

        emit(CreateOrderErrorState());
      }, (right) {
        emit(CreateOrderSuccessState(orderData: right.data));
        showToast(
            isSuccess: true,
            message: right.message ?? "Order Created Successfully");
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(CreateOrderErrorState());
    }
  }

  // Create Product Bloc ==============================================================================

  _onCreateProduct(
      CreateProductEvent event, Emitter<RestaurantState> emit) async {
    emit(CreateProductLoadingState());

    try {
      await _repository
          .createProduct(
              createProductRequestModel: event.createProductRequestModel)
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(CreateProductErrorState());
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
      CreateCheckoutEvent event, Emitter<RestaurantState> emit) async {
    emit(CreateCheckoutLoadingState());

    try {
      await _repository
          .createCheckout(
              createCheckOutRequestModel: event.createCheckOutRequestModel)
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(CreateCheckoutErrorState());
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

  // Get Order Details Bloc ==============================================================================
  _onGetOrderDetails(
      GetOrderDetailsEvent event, Emitter<RestaurantState> emit) async {
    emit(GetOrderLoadingState());

    try {
      await _repository.getOrderDetails(mealmeId: event.mealMeOrderId).fold(
          (left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(GetOrderErrorState());
        showToast(isSuccess: false, message: left.errorMessage ?? "");
      }, (right) {
        emit(GetOrderSuccessState(data: right.data!));
        // showToast(isSuccess: true, message: right.message ?? "");
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetOrderErrorState());
    }
  }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>PAYMENT PART END<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  // Get Delivery Status Bloc ==============================================================================

  _onGetDeliveryStatus(
      GetDeliveryStatusEvent event, Emitter<RestaurantState> emit) async {
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

  // Get Delivery Status Bloc ==============================================================================

  _onUpdateDeliveryStatus(
      UpdateDeliveryStatusEvent event, Emitter<RestaurantState> emit) async {
    emit(UpdateDeliveryStatusLoadingState());

    try {
      await _repository.updateDeliveryStatus(pickup: event.pickUp).fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(UpdateDeliveryStatusErrorState());
        showToast(isSuccess: false, message: left.errorMessage ?? "");
      }, (right) {
        emit(UpdateDeliveryStatusSuccessState(data: right.data ?? {}));
        // showToast(isSuccess: true, message: right.message ?? "");
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(UpdateDeliveryStatusErrorState());
    }
  }

  _onCheckDeliverableGroceryStore(
      CheckDeliverableGroceryEvent event, Emitter<RestaurantState> emit) async {
    try {
      emit(DeliverableLoaderState());
      List<Cart> cartList = [];
      for (int i = 0; i < event.cartList.length; i++) {
        Store? store = event.cartList[i].store;
        if (store?.isSelected ?? false) {
          Map<String, dynamic> requestData = {
            "latitude": event.address?.latitude,
            "longitude": event.address?.longitude,
            "storeId": store?.id,
            "user_street_num": "${event.address?.streetNum}",
            "user_street_name": "${event.address?.streetName}",
            "user_city": "${event.address?.city}",
            "user_state": "${event.address?.state}",
            "user_country": "${event.address?.country}",
            "user_zipcode": "${event.address?.zipcode}",
            "pickup": false,
          };
          log("Url : ${ApiUrls.checkDeliverableGroceryStore}");
          log("Request Data : $requestData");
          var response = await ApiServices()
              .post(ApiUrls.checkDeliverableGroceryStore, requestData);
          dynamic data = jsonDecode(response.body);
          log(response.body.toString());
          if (data is Map && data["success"] == true) {
            cartList.add(event.cartList[i]);
          } else {
            if (data is Map && data["errorMessage"] != null) {
              showToast(
                message: data["errorMessage"].toString(),
                isSuccess: false,
              );
            }
          }
        }
      }
      event.callback(cartList);
    } catch (e) {
      event.callback([]);
    } finally {
      emit(DeliverableSuccessState());
    }
  }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>PAYMENT PART END<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  onFailError({required String text, required Emitter<RestaurantState> emit}) {
    // showToast(isSuccess: false, message: text);
    emit(ErrorState());
  }
}
