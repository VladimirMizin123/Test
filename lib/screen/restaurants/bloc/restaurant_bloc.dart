// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/repository/get_address.dart';
import 'package:gymeats_mobile/repository/get_restaurant_details.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_state.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:gymeats_mobile/widget/extended_address_sheet.dart';
import 'package:gymeats_mobile/widget/food_menu_address.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  RestaurantBloc() : super(InitialState()) {
    on<GetUserAddressEvent>(_onGetUserAddress);
    on<GetRestaurantListEvent>(_onGetRestaurantList);
    on<GetRestaurantMenuListEvent>(_onGetRestaurantMenuList);
    on<GetCousinesEvent>(_onGetCousinesList);
    on<AddRestaurantCartEvent>(_onAddToShoppingList);
    on<CreateOrderEvent>(_onCreateOrder);
    on<CreateProductEvent>(_onCreateProduct);
    on<CreateCheckoutEvent>(_onCreateCheckout);
    on<GetOrderDetailsEvent>(_onGetOrderDetails);
    on<GetDeliveryStatusEvent>(_onGetDeliveryStatus);
    on<UpdateDeliveryStatusEvent>(_onUpdateDeliveryStatus);
    on<MealPlanMatchEvent>(_onMatchMealPlan);
    on<FetchCustomizationEvent>(_onfetchCustomization);
    on<ProductCustomizationEvent>(_onProductCustomization);
    on<RestaurantVerifyEvent>(_onStoreVerify);
    on<RestaurantByNameEvent>(_onGetStoreByName);
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

  List<dynamic> lastCategoryData = [];

  // Get Restaurant List Bloc =================================================================
  _onGetRestaurantList(
      GetRestaurantListEvent event, Emitter<RestaurantState> emit) async {
    emit(GetRestaurantListLoadingState());

    try {
      lastCategoryData = event.categotyData;
      await resFuture(event, emit);
    } catch (e) {
      // showToast(isSuccess: false, message: e.toString());
      emit(GetRestaurantListErrorState());
    }
  }

  _onStoreVerify(
      RestaurantVerifyEvent event, Emitter<RestaurantState> emit) async {
    try {
      // !
      Map<String, dynamic> req = PreferenceUtils.getMenuAddress();
      final value =
          Constant.i.requiredAddressField.every((e) => req.containsKey(e));

      if (value) {
        emit(VerifyRestaurantLoader(id: event.id));
        final response = await _repository.storeLookup(storeId: event.id ?? "");
        if (response.isRight) {
          final store = response.right.data?.store?.quoteIds ?? [];
          log("Store Id Find : $store");

          if (store.isNotEmpty) {
            (double?, double?) pos = await Constant.i.position;
            List<Future<Either<ErrorModel, GetRestaurantMenuListModel>>>
                futureList = [];
            for (int i = 0; i < store.length; i++) {
              futureList.add(
                _repository.getRestaurantMenuList(
                  restaurantId: event.id,
                  pickup: event.pickup,
                  latitude: event.latitude,
                  longitude: event.longitude,
                  mealType: "restaurant",
                  position: pos,
                  menuId: store[i],
                  additionalData: req,
                  needLeft: true,
                ),
              );
            }

            Stream<Either<ErrorModel, GetRestaurantMenuListModel>>
                futureStream = Stream.fromFutures(futureList);
            Either<ErrorModel, GetRestaurantMenuListModel>? storeRes;
            bool hasError = false;

            await for (Either<ErrorModel, GetRestaurantMenuListModel> result
                in futureStream) {
              if (result.isRight &&
                  (result.right.data?.categories?.isNotEmpty ?? false)) {
                storeRes = result;
                hasError = false;
                break;
              } else if (result.isLeft) {
                storeRes = result;
                hasError = true;
              }
            }
            if (event.id != prevId || storeRes == null || hasError) {
              if (storeRes == null || hasError) {
                if (storeRes != null && hasError) {
                  showToast(
                      isSuccess: false,
                      message: storeRes.left.errorMessage != null
                          ? storeRes.left.errorMessage!
                          : StringUtils.restaurantNotAvailable);
                }
                emit(VerifyRestaurantLoader(id: null));
                event.notVerify?.call();
              }
              return;
            }
            emit(VerifyRestaurantLoader(id: null));
            await Future.delayed(const Duration(milliseconds: 200));
            if (event.id != prevId) {
              return;
            }
            if (storeRes.isRight) {
              if (storeRes.right.success ?? false) {
                event.onVerify
                    ?.call(storeRes.right.data, storeRes.right.data?.quote);
              } else {
                showToast(
                    isSuccess: false,
                    message: storeRes.right.errorMessage ?? "");
                event.notVerify?.call();
              }
            } else {
              showToast(
                  isSuccess: false,
                  message: storeRes.left.errorMessage != null
                      ? storeRes.left.errorMessage!
                      : StringUtils.restaurantNotAvailable);
              event.notVerify?.call();
            }
          } else {
            event.notVerify?.call();
          }
        } else {
          event.notVerify?.call();
        }
      } else {
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
        if (result == true) {
          add(event);
        }
      }
    } catch (e) {
      log(e.toString());
      event.notVerify?.call();
      emit(VerifyRestaurantLoader(id: null));
      if (event.id == prevId) {
        showToast(
            isSuccess: false, message: StringUtils.restaurantNotAvailable);
      }
    }
  }

  Future<dynamic> resFuture(
      GetRestaurantListEvent event, Emitter<RestaurantState> emit) async {
    String pref;

    if (event.pickup) {
      pref = restaurantsPickup;
    } else {
      pref = restaurantsBring;
    }

    Either<ErrorModel, GetRestaurantListModel> data =
        await _repository.getRestaurantListData(
      latitude: event.latitude,
      longitude: event.longitude,
      maximumMiles: PreferenceUtils.getRestaurantsRadius().round(),
      pickup: event.pickup,
      categoriesData: event.categotyData,
      mealName: event.mealName,
    );
    if (data.isRight) {
      GetRestaurantListModel right = data.right;
      if (event.storeLocal) {
        log("Set Cache : $pref");
        PreferenceUtils.setString(pref, jsonEncode(right.data ?? []));
        for (int i = 0; i < (right.data?.length ?? 0); i++) {
          if (right.data?[i].logoPhotos?.isNotEmpty ?? false) {
            PreferenceUtils.setString("${right.data?[i].id}_img",
                right.data?[i].logoPhotos?[0] ?? "");
          }
        }
      }

      emit(GetRestaurantListSuccessState(restaurantList: right.data ?? []));
      emit(RestaurantVerificationLoader(isLoading: false));
    } else {
      onFailError(emit: emit, text: data.left.errorMessage!);
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
        latitude: event.getUserAddress?.latitude,
        longitude: event.getUserAddress?.longitude,
      )
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(GetRestaurantMenuListErrorState());
      }, (right) async {
        event.onDataGet?.call(right.data);
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
    try {
      emit(MatchMealLoadingState(isLoading: true));
      RestaurantMenu menu = event.menu;
      List<Category> categories = menu.categories ?? [];
      Category? category = categories.firstWhereOrNull(
          (element) => element.subcategoryId == event.subcategoryId);
      Map<String, dynamic> req = {
        // "restrictions": PreferenceUtils.getStringList(getUserRestriction),
        // "allergies": PreferenceUtils.getStringList(getUserAllergies),
        "restrictions": [],
        "allergies": [],
        "calories": event.calories ?? 0.0,
        "Categorie": category?.name,
        "restaurantMenu":
            category?.menuItemList?.map((e) => e.toJson()).toList() ?? [],
      };
      log(ApiUrls.filterMenuFromAI);
      log(jsonEncode(req));
      var res =
          await _repository.apiServices.post(ApiUrls.filterMenuFromAI, req);
      log("Response : ${res.body}");
      if (res.statusCode == 200) {
        var resData = jsonDecode(res.body);
        List<MenuItemList> updatedList = List<MenuItemList>.from(
            resData["data"]?.map((x) => MenuItemList.fromJson(x)) ?? []);
        log("Pass Record : ${category?.menuItemList?.length} Found Match Record : ${updatedList.length}");
        event.onSuccess?.call();
        emit(MatchMealState(
            subCategoryId: event.subcategoryId, updatedList: updatedList));
      } else {
        event.onError?.call();
        dynamic data = jsonDecode(res.body);
        if (data != null) {
          String message = data?["errorMessage"].toString() ?? "";
          if (message.trim().isNotEmpty) {
            showToast(isSuccess: false, message: message);
          }
        }
      }
    } catch (e) {
      log(e.toString());
    } finally {
      emit(MatchMealLoadingState(isLoading: false));
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

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>PAYMENT PART START<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  // Create Order Bloc ==============================================================================

  _onCreateOrder(CreateOrderEvent event, Emitter<RestaurantState> emit) async {
    emit(CreateOrderLoadingState());

    try {
      await _repository
          .createOrder(createOrderModel: event.createOrderModel)
          .fold((left) async {
        log("Error Json : ${left.toJson()} :${left.statusCode}");
        if (left.statusCode != 500) {
          showToast(
              message: (left.errorMessage?.trim().isNotEmpty ?? false)
                  ? (left.errorMessage ?? "")
                  : (left.message ?? ""),
              isSuccess: false);
        }

        onFailError(
            emit: emit,
            text: (left.errorMessage?.trim().isNotEmpty ?? false)
                ? (left.errorMessage ?? "")
                : (left.message ?? ""));
        if (left.statusCode == 500) {
          dynamic result = await showModalBottomSheet(
            context: event.context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            isScrollControlled: true,
            builder: (context) => const ExtendedAddress(),
          );
          if (result != null) {
            Map req = result as Map;
            add(
              CreateOrderEvent(
                createOrderModel: event.createOrderModel
                  ..extendedAddress = req["extendedAddress"],
                context: event.context,
              ),
            );
          }
        } else {
          showToast(isSuccess: false, message: left.errorMessage ?? "");
        }
        emit(CreateOrderErrorState());
      }, (right) {
        // if (right.data?.orderPlaced ?? false) {
        emit(CreateOrderSuccessState(orderData: right.data));
        showToast(
            isSuccess: true,
            message: right.message ?? StringUtils.orderCreatedSuccessfully);
        // } else {
        //   emit(CreateOrderErrorState());
        //   showToast(
        //       isSuccess: false,
        //       message:
        //           right.message ?? StringUtils.theOrderNotPlacedDueToSomeIssue);
        // }
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

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>PAYMENT PART END<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  onFailError({required String text, required Emitter<RestaurantState> emit}) {
    // showToast(isSuccess: false, message: text);
    emit(ErrorState());
  }

  _onfetchCustomization(
      FetchCustomizationEvent event, Emitter<RestaurantState> emit) async {
    try {
      emit(FetchCustomizationLoaderState());
      UserAddress? address;
      (double?, double?) pos = await Constant.i.position;
      if (pos.$1 == null && pos.$2 == null) {
        Either<ErrorModel, GetUserAddressModel> res =
            await GetAddressRepository().getUserAddressData();
        if (res.isRight) {
          res.right.data?.forEach((element) async {
            if (element.isPrimary == true) {
              address = element;
            }
          });
          if ((res.right.data?.isNotEmpty ?? false) &&
              !res.right.data!.any((element) => (element.isPrimary ?? false))) {
            address = res.right.data?.first;
          }
        }
      }

      await _repository
          .fetchCustomization(
        event.productId,
        latitude: pos.$1 ?? address?.latitude,
        longitude: pos.$2 ?? address?.longitude,
        pickup: event.pickUp,
      )
          .fold(
        (left) {
          showToast(isSuccess: false, message: left.errorMessage ?? "");
        },
        (right) {
          event.callback(right);
        },
      );
    } catch (e) {
      log(e.toString());
    } finally {
      emit(FetchCustomizationSuccessState());
    }
  }

  _onProductCustomization(
      ProductCustomizationEvent event, Emitter<RestaurantState> emit) async {
    try {
      emit(FetchCustomizationLoaderState());
      await _repository.getProductCustomization(event.productId).fold(
        (left) {
          showToast(isSuccess: false, message: left.errorMessage ?? "");
        },
        (right) {
          event.callback(right);
        },
      );
    } catch (e) {
      log(e.toString());
    } finally {
      emit(FetchCustomizationSuccessState());
    }
  }

  String? prevName;
  String? prevId;

  _onGetStoreByName(
      RestaurantByNameEvent event, Emitter<RestaurantState> emit) async {
    emit(GetRestaurantListLoadingState());
    try {
      prevName = event.name;
      if (prevName?.trim().isNotEmpty ?? false) {
        await _repository
            .getStoreByName(
          latitude: event.latitude.toString(),
          longitude: event.longitude.toString(),
          pickup: event.pickup,
          name: event.name,
          cuisine: event.cuisine,
        )
            .fold((left) {
          emit(GetRestaurantListErrorState());
          onFailError(emit: emit, text: left.errorMessage!);
        }, (right) async {
          if (event.name == prevName) {
            List<RestaurantList> resList = right.data
                    ?.map((e) => RestaurantList.fromJson(e.toJson()))
                    .toList() ??
                [];
            emit(GetRestaurantListSuccessState(restaurantList: resList));
            emit(RestaurantVerificationLoader(isLoading: false));
          }
        });
      } else {
        emit(RestaurantVerificationLoader(isLoading: false));
        emit(GetRestaurantListErrorState());
      }
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetRestaurantListErrorState());
    }
  }
}
