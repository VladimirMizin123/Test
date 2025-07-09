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
import 'package:gymeats_mobile/widget/food_menu_address.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  RestaurantBloc() : super(InitialState()) {
    on<GetUserAddressEvent>(_onGetUserAddress);
    on<GetRestaurantListEvent>(_onGetRestaurantList);
    on<InitializeRestaurantsWindowsEvent>(_onInitializeRestaurantsWindows);
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

  Future<void> _onInitializeRestaurantsWindows(
      InitializeRestaurantsWindowsEvent event,
      Emitter<RestaurantState> emit,
  ) async {
    final tempRepository = RestaurantRepository();

    try {
      await tempRepository.handleRestaurantsWindowsInitialization();
    } catch (_) {
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
      emit(VerifyRestaurantLoader(id: event.id));

      final tempRepository = RestaurantRepository();

      Either<ErrorModel, GetRestaurantMenuListModel>? storeRes;
      try {
        storeRes = await tempRepository.getRestaurantMenuList(
          restaurantId: event.id,
          pickup: event.pickup,
          latitude: 0.0,
          longitude: 0.0,
          mealType: "restaurant",
          needLeft: true,
          restaurantName: event.restaurantName,
        );
      } catch (e, st) {
        print('error during getRestaurantMenuList');
      }
      emit(VerifyRestaurantLoader(id: null));

      if (event.id != prevId) {
        return;
      }
      if (storeRes != null) {
        storeRes.fold(
          (error) {
            showToast(
              isSuccess: false,
              message: error.errorMessage?.isNotEmpty == true
                  ? error.errorMessage!
                  : StringUtils.restaurantNotAvailable,
            );
            event.notVerify?.call();
          },
          (menuModel) {
            if (menuModel.success ?? false) {
              event.onVerify?.call(menuModel.data, menuModel.data?.quote);
            } else {
              showToast(
                isSuccess: false,
                message: menuModel.errorMessage ?? "",
              );
              event.notVerify?.call();
            }
          },
        );
      } else {
        showToast(
          isSuccess: false,
          message: StringUtils.restaurantNotAvailable,
        );
        event.notVerify?.call();
      }
    } catch (e) {
      log(e.toString());
      event.notVerify?.call();
      emit(VerifyRestaurantLoader(id: null));
      if (event.id == prevId) {
        showToast(
          isSuccess: false,
          message: StringUtils.restaurantNotAvailable,
        );
      }
    }
  }

  Future<dynamic> resFuture(
    GetRestaurantListEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    String pref = event.pickup ? restaurantsPickup : restaurantsBring;

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
      final GetRestaurantListModel right = data.right;

      if (event.storeLocal) {
        log("Set Cache : $pref");

        PreferenceUtils.setString(pref, jsonEncode(right.data ?? []));

        for (final restaurant in right.data ?? []) {
          final String? id = restaurant.id;
          final List<String>? logos = restaurant.logoPhotos;

          if (id != null && logos != null && logos.isNotEmpty) {
            PreferenceUtils.setString("${id}_img", logos.first);
          }
        }
      }

      if (right.data != null && right.data!.isNotEmpty) {
        await Future.delayed(Duration(milliseconds: 100));
        if (!event.firstCall) {
          emit(GetRestaurantListSuccessState(restaurantList: right.data ?? []));
          emit(RestaurantVerificationLoader(isLoading: false));
        }
      }
      
    } else {
      final String error = data.left.errorMessage ?? "Error fetching restaurants";
      onFailError(emit: emit, text: error);
      emit(GetRestaurantListErrorState());
    }
  }

  // Get Restaurant Menu List Bloc  =================================================================
  _onGetRestaurantMenuList(
      GetRestaurantMenuListEvent event, Emitter<RestaurantState> emit) async {
    emit(GetRestaurantMenuListLoadingState());
    try {
      print("BEFORE CALL REPOSITORY");
      await _repository
          .getRestaurantMenuList(
        restaurantId: event.restaurantId,
        pickup: event.pickUp,
        mealType: event.mealType,
        latitude: event.getUserAddress?.latitude,
        longitude: event.getUserAddress?.longitude,
      )
          .fold((left) {
            print("RETURN IS LEFT");
        onFailError(emit: emit, text: left.errorMessage!);
        
        emit(GetRestaurantMenuListErrorState());
      }, (right) async {
        print("RETURN IS RIGHT");
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
    MealPlanMatchEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    try {
      print('HEREE');
      emit(MatchMealLoadingState(isLoading: true));

      RestaurantMenu menu = event.menu;
      List<Category> categories = menu.categories ?? [];

      Category? category;
      Category? parentCategory;
      List<MenuItemList> menuItemList = [];

      if (event.subcategoryId != null) {
        print('NOT NULL');
        parentCategory = categories.firstWhereOrNull(
          (cat) => cat.name == event.categoryId,
        );

        if (parentCategory != null) {
          category = parentCategory;
          int? subIndex = int.tryParse(event.subcategoryId!);

          if (subIndex != null &&
              parentCategory.subcategories != null &&
              subIndex >= 0 &&
              subIndex < parentCategory.subcategories!.length) {
            var sub = parentCategory.subcategories![subIndex];
            menuItemList = sub.menuItemList ?? [];
          }
        }
      } else {
        print('SUB IS NULL');
        parentCategory = categories[event.categoryId != null ? int.parse(event.categoryId!) : 0];
        category = parentCategory;
        menuItemList = parentCategory.menuItemList ?? [];
      }

      Map<String, dynamic> req = {
        "restrictions": [],
        "allergies": [],
        "calories": event.calories ?? 0.0,
        "Categorie": category?.name,
        "restaurantMenu": menuItemList.map((e) => e.toJson()).toList(),
      };


      var res = await _repository.apiServices.post(ApiUrls.filterMenuFromAI, req);

      if (res.statusCode == 200) {
        var resData = jsonDecode(res.body);
        print(resData);

        List<MenuItemList> updatedList = List<MenuItemList>.from(
          resData["data"]?.map((x) => MenuItemList.fromJson(x)) ?? [],
        );

        event.onSuccess?.call();
        emit(MatchMealState(
          subCategoryId: event.subcategoryId,
          updatedList: updatedList,
          categoryName: parentCategory!.name,
        ));
      } else {
        event.onError?.call();
        dynamic data = jsonDecode(res.body);
        print(data);
        if (data != null) {
          String message = data?["errorMessage"]?.toString() ?? "";

          if (message.trim().isNotEmpty) {
            showToast(isSuccess: false, message: message);
          }
        }
      }
    } catch (e, stackTrace) {
      print("Exception: $e");
      print("Stacktrace: $stackTrace");
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
    print('_onCreateOrder STARTED');
    emit(CreateOrderLoadingState());
    print('Emitted CreateOrderLoadingState');

    try {
      print('Calling _repository.createOrder...');
      await _repository
          .createOrder(createOrderModel: event.createOrderModel,  isMock: event.isMock)
          .fold((left) async {
        print('Repository returned failure');
        log("Error Json : ${left.toJson()} : ${left.statusCode}");
        showToast(isSuccess: false, message: left.errorMessage ?? "");
        emit(CreateOrderErrorState());
        print('Emitted CreateOrderErrorState');
      }, (right) {
        print('Repository returned success');
        print('Order data: ${right.data}');
        emit(CreateOrderSuccessState(orderData: right.data));
        print('Emitted CreateOrderSuccessState');
        showToast(
          isSuccess: true,
          message: right.message ?? StringUtils.orderCreatedSuccessfully,
        );
      });
    } catch (e, stack) {
      print('Exception caught in _onCreateOrder: $e');
      print('Stack trace: $stack');
      showToast(isSuccess: false, message: e.toString());
      emit(CreateOrderErrorState());
      print('Emitted CreateOrderErrorState from catch');
    } finally {
      print('_onCreateOrder FINISHED');
    }
  }

  // Create Product Bloc ==============================================================================

  _onCreateProduct(
      CreateProductEvent event, Emitter<RestaurantState> emit) async {
    emit(CreateProductLoadingState());
    print('onCreateProduct');
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
    print('ON CREATE CHECKOUT');
    try {
      print('inside TRY');
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
      print('CATCH');
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
