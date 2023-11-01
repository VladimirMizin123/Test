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
    on<AddRestaurantCartEvent>(_onAddToRestaurantList);
    on<GetShoppingListEvent>(_onFetchShoppingList);
    on<UpdateRestaurantCartEvent>(_onUpdateToRestaurantList);
    on<RemoveShoppingListItemEvent>(_onRemoveShoppingList);
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

  _onAddToRestaurantList(
      AddRestaurantCartEvent event, Emitter<RestaurantState> emit) async {
    emit(AddToRestaurantCartLoadingState());

    try {
      await _repository
          .addMenuToCartRestaurant(addItemsToShoppingList: event.addItemsList)
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        showToast(isSuccess: true, message: right.message!);
        emit(AddToRestaurantCartSuccessState(
            isAdded: right.success ?? true, data: right.data));
      });
    } catch (e) {
      log('e---------->>>>>> ${e}');

      showToast(isSuccess: false, message: e.toString());
      emit(AddToRestaurantCartErrorState());
    }
  }

  // Get Shopping List Bloc =========================================================================================

  _onFetchShoppingList(
      GetShoppingListEvent event, Emitter<RestaurantState> emit) async {
    emit(GetShoppingListLoadingState());

    try {
      await _repository.getShoppingList().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(
          GetShoppingListSuccessState(
              shoppingListData: right.data == null ? [] : right.data!),
        );
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetShoppingListErrorState());
    }
  }

  // Update Restaurant Item to cart Bloc ============================================================================

  _onUpdateToRestaurantList(
      UpdateRestaurantCartEvent event, Emitter<RestaurantState> emit) async {
    emit(UpdateToRestaurantCartLoadingState(
        productId: event.updateItemList.oldProductId!));

    try {
      await _repository
          .updateMenuToCartRestaurant(
              updateItemsToShoppingList: event.updateItemList)
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        log('----DATA------PRICE--->>>>>>>>${right.data['price']}');
        log('----DATA------QUANTITY--->>>>>>>>${right.data['quantity']}');
        showToast(isSuccess: true, message: right.message!);
        emit(UpdateToRestaurantCartSuccessState(
            isAdded: right.success ?? true, data: right.data));
      });
    } catch (e) {
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

  onFailError({required String text, required Emitter<RestaurantState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(ErrorState());
  }
}
