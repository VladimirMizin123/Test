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
    on<AddRestaurantCartEvent>(_onAddToGroceryList);
  }

  final RestaurantRepository _repository = RestaurantRepository();

  /// Get Grocery Item Bloc =================================================================
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

  /// Get Restaurant List Bloc =================================================================
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

  /// Get Restaurant Menu List Bloc  =================================================================
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
      log('e---------->>>>>> ${e}');

      // showToast(isSuccess: false, message: e.toString());
      emit(GetRestaurantMenuListErrorState());
    }
  }

  /// Get Cousines Bloc ==============================================================================

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

  /// Add Restaurant Item to cart Bloc ==============================================================================

  _onAddToGroceryList(
      AddRestaurantCartEvent event, Emitter<RestaurantState> emit) async {
    emit(AddToRestaurantCartLoadingState());

    try {
      await _repository
          .menuAddToCartRestaurant(addItemsToShoppingList: event.addItemsList)
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(AddToRestaurantCartSuccessState(isAdded: right.success ?? true));
        showToast(isSuccess: false, message: right.message ?? 'Added!');
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(AddToRestaurantCartErrorState());
    }
  }

  onFailError({required String text, required Emitter<RestaurantState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(ErrorState());
  }
}
