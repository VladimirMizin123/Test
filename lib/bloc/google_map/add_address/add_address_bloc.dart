import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/dashboard/cart_bloc/cart_bloc.dart';
import 'package:gymeats_mobile/bloc/google_map/add_address/add_address_event.dart';
import 'package:gymeats_mobile/bloc/google_map/add_address/add_address_state.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/repository/add_address.dart';
import 'package:gymeats_mobile/screen/appmanager/app_manager_screen.dart';
import 'package:gymeats_mobile/screen/dashboard/dashboard_screen.dart';

import '../../../widget/app_widget.dart';

class AddAddressBloc extends Bloc<AddressEvent, AddressState> {
  AddAddressBloc() : super(InitialState()) {
    on<SaveClickEvent>(_onAddAddress);
    on<UpdateClickEvent>(_onUpdateAddress);
    on<DeleteClickEvent>(_onDeleteAddress);
  }

  final AddAddressRepository _repository = AddAddressRepository();

  _onAddAddress(SaveClickEvent event, Emitter<AddressState> emit) async {
    emit(AddAddressLoadingState());
    try {
      await _repository
          .addAddress(
        latitude: event.latitude,
        longitude: event.longitude,
        streetNum: event.streetNum,
        streetName: event.streetName,
        city: event.city,
        state: event.state,
        country: event.country,
        addressType: event.addressType,
        zipcode: event.zipcode,
        isPrimary: event.isPrimary,
        userId: event.userId,
        floor: event.floor,
      )
          .fold(
        (left) {
          onFailError(emit: emit, text: left.errorMessage!);
        },
        (right) async {
          // showToast(isSuccess: true, message: right.message!);
          cartBloc.add(RemoveCart());
          Constant.i.removeStore();
          emit(AddAddressSuccessfulState());
          if (event.isFrom == 'isFromRestaurant' ||
              event.isFrom == 'isFromCheckout' ||
              event.isFrom == 'isFromGrocery') {
            await PreferenceUtils.setManualLoation(true);
            PreferenceUtils.setFoodMenuAddress(
              req: {
                "user_street_num": event.streetNum,
                "user_street_name": event.streetName,
                "user_city": event.city,
                "user_state": event.state,
                "user_country": event.country,
                "user_zipcode": event.zipcode,
                "extended_address": event.floor ?? "",
              },
            );

            if (event.isFrom == "isFromGrocery") {
              Get.offAll(() => const AppManagerScreen(selectIndex: 1));
            } else {
              Get.offAll(() => const AppManagerScreen(selectIndex: 3));
            }
          }
          if (event.isFrom == 'isFromDashboard') {
            Get.offAll(() => const AppManagerScreen(selectIndex: 2));
          }
          if (event.isFrom == 'isFromProfile') {
            await PreferenceUtils.setManualLoation(true);
            Constant.i.removeStore();
            PreferenceUtils.setFoodMenuAddress(
              req: {
                "user_street_num": event.streetNum,
                "user_street_name": event.streetName,
                "user_city": event.city,
                "user_state": event.state,
                "user_country": event.country,
                "user_zipcode": event.zipcode,
                "extended_address": event.floor ?? "",
              },
            );
            Get.back(result: true);
          }
          if (event.isFrom == 'isFromGroceryCheckout') {
            Get.offAll(() => const AppManagerScreen(selectIndex: 1));
          }
        },
      );
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(ErrorState());
    }
  }

  _onUpdateAddress(UpdateClickEvent event, Emitter<AddressState> emit) async {
    emit(AddAddressLoadingState());
    try {
      await _repository
          .updateAddress(
        latitude: event.latitude,
        longitude: event.longitude,
        streetNum: event.streetNum,
        streetName: event.streetName,
        city: event.city,
        state: event.state,
        country: event.country,
        addressType: event.addressType,
        zipcode: event.zipcode,
        isPrimary: event.isPrimary,
        addressId: event.addressId,
        floor: event.floor,
      )
          .fold(
        (left) {
          onFailError(emit: emit, text: left.errorMessage!);
        },
        (right) async {
          // showToast(isSuccess: true, message: right.message!);
          emit(AddAddressSuccessfulState());

          if (event.isFrom == 'isFromRestaurant') {
            Get.offAll(
              () => const AppManagerScreen(
                selectIndex: 3,
              ),
            );
          }
          if (event.isFrom == 'isFromDashboard') {
            Get.offAll(
              () => const AppManagerScreen(
                selectIndex: 2,
              ),
            );
          }
          if (event.isFrom == 'isFromProfile') {
            if (event.isPrimary) {
              await PreferenceUtils.setManualLoation(true);
              Constant.i.removeStore();
              PreferenceUtils.setFoodMenuAddress(
                req: {
                  "user_street_num": event.streetNum,
                  "user_street_name": event.streetName,
                  "user_city": event.city,
                  "user_state": event.state,
                  "user_country": event.country,
                  "user_zipcode": event.zipcode,
                  "extended_address": event.floor ?? "",
                },
              );
            }
            Get.back(result: true);
          }
        },
      );
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(ErrorState());
    }
  }

  _onDeleteAddress(DeleteClickEvent event, Emitter<AddressState> emit) async {
    emit(AddAddressLoadingState());
    try {
      await _repository
          .deleteAddress(
        addressId: event.addressId,
      )
          .fold(
        (left) {
          onFailError(emit: emit, text: left.errorMessage!);
        },
        (right) {
          // showToast(isSuccess: true, message: right.message!);
          emit(AddAddressSuccessfulState());

          if (event.isFrom == 'isFromRestaurant') {
            Get.offAll(
              () => const AppManagerScreen(
                selectIndex: 3,
              ),
            );
          }
          if (event.isFrom == 'isFromDashboard') {
            Get.offAll(
              () => const AppManagerScreen(
                selectIndex: 2,
              ),
            );
          }
          if (event.isFrom == 'isFromProfile') {
            Get.back(result: true);
          }
        },
      );
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(ErrorState());
    }
  }

  onFailError({required String text, required Emitter<AddressState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(ErrorState());
  }
}
