import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/google_map/add_address/add_address_event.dart';
import 'package:gymeats_mobile/bloc/google_map/add_address/add_address_state.dart';
import 'package:gymeats_mobile/repository/add_address.dart';
import 'package:gymeats_mobile/screen/appmanager/app_manager_screen.dart';

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
      )
          .fold(
        (left) {
          onFailError(emit: emit, text: left.errorMessage!);
        },
        (right) {
          // showToast(isSuccess: true, message: right.message!);
          emit(AddAddressSuccessfulState());

          if (event.isFrom == 'isFromCheckout') {
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
      )
          .fold(
        (left) {
          onFailError(emit: emit, text: left.errorMessage!);
        },
        (right) {
          // showToast(isSuccess: true, message: right.message!);
          emit(AddAddressSuccessfulState());

          if (event.isFrom == 'isFromCheckout') {
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

          if (event.isFrom == 'isFromCheckout') {
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
