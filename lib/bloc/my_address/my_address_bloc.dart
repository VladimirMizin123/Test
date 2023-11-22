import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/my_address/my_address_event.dart';
import 'package:gymeats_mobile/bloc/my_address/my_address_state.dart';
import 'package:gymeats_mobile/repository/get_address.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';

class MyAddressBloc extends Bloc<MyAddressEvent, MyAddressState> {
  MyAddressBloc() : super(InitialState()) {
    on<GetUserAddressEvent>(_onGetUserAddress);
    on<SetPrimaryAddressEvent>(_onSetPrimaryAddress);
  }

  final GetAddressRepository _repository = GetAddressRepository();

  /// Get ADDRESS List Bloc =================================================================

  _onGetUserAddress(
      GetUserAddressEvent event, Emitter<MyAddressState> emit) async {
    emit(GetUserAddressLoadingState());

    try {
      await _repository.getUserAddressData().fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) async {
        emit(GetUserAddressSuccessState(userAddress: right.data ?? []));

        right.data?.forEach((element) async {
          if (element.isPrimary == true) {
            await PreferenceUtils.setString(
                latitude, element.latitude.toString());
            await PreferenceUtils.setString(
                longitude, element.longitude.toString());
          }
        });
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetUserAddressErrorState());
    }
  }

  /// Set Primary ADDRESS Bloc =================================================================

  _onSetPrimaryAddress(
      SetPrimaryAddressEvent event, Emitter<MyAddressState> emit) async {
    emit(GetUserAddressLoadingState());

    try {
      await _repository.setUserAddressPrimary(event.addressId ?? '').fold(
          (left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) {
        emit(SetAddressPrimarySuccessState());
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(GetUserAddressErrorState());
    }
  }

  onFailError({required String text, required Emitter<MyAddressState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(ErrorState());
  }
}
