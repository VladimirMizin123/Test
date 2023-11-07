import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/repository/get_restaurant_details.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_event.dart';
import 'package:gymeats_mobile/screen/restaurants/bloc/restaurant_state.dart';
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
      )
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(GetRestaurantListErrorState());
      }, (right) {
        emit(GetRestaurantListSuccessState(restaurantList: right.data ?? []));
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
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
      )
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
        emit(GetRestaurantMenuListErrorState());
      }, (right) {
        emit(
            GetRestaurantMenuListSuccessState(restaurantMenuList: right.data!));
      });
    } catch (e) {
      // showToast(isSuccess: false, message: e.toString());
      emit(GetRestaurantMenuListErrorState());
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
      showToast(isSuccess: false, message: e.toString());
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
      log('e---------->>>>>> ${e}');

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
      showToast(isSuccess: false, message: e.toString());
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
      log('e---------->>>>>> ${e}');

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
        emit(GetOrderSuccessState(data: right.data ?? []));
        // showToast(isSuccess: true, message: right.message ?? "");
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetOrderErrorState());
    }
  }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>PAYMENT PART END<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  onFailError({required String text, required Emitter<RestaurantState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(ErrorState());
  }
}
