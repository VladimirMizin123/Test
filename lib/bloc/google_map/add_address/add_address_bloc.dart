import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/google_map/add_address/add_address_event.dart';
import 'package:gymeats_mobile/bloc/google_map/add_address/add_address_state.dart';
import 'package:gymeats_mobile/repository/add_address.dart';

import '../../../widget/app_widget.dart';

class AddAddressBloc extends Bloc<AddAddressEvent, AddAddressState> {
  AddAddressBloc() : super(InitialState()) {
    on<SaveClickEvent>(_onAddAddress);
  }

  final AddAddressRepository _repository = AddAddressRepository();

  _onAddAddress(SaveClickEvent event, Emitter<AddAddressState> emit) async {
    emit(LoadingState());
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
          .fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        showToast(isSuccess: true, message: right.message!);
        emit(AddAddressSuccessfulState());
        Get.back();
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(ErrorState());
    }
  }

  onFailError({required String text, required Emitter<AddAddressState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(ErrorState());
  }
}
