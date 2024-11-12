import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/user_sign_up_info/user_sign_up_info_event.dart';
import 'package:gymeats_mobile/bloc/user_sign_up_info/user_sign_up_info_state.dart';
import '../../app/sharedPrefrence.dart';
import '../../repository/sign_up.dart';
import '../../widget/app_widget.dart';

class UserSignUpInfoBloc
    extends Bloc<UserSignUpInfoEvent, UserSignUpInfoState> {
  UserSignUpInfoBloc() : super(InitialState()) {
    on<LatLogEvent>(_onLatLog);
    on<SignUpApiEvent>(_onSignUpApi);
  }

  _onLatLog(LatLogEvent event, Emitter<UserSignUpInfoState> emit) {
    getCurrentPosition(emit);
  }

  Future<void> getCurrentPosition(Emitter<UserSignUpInfoState> emit) async {
    try {
      final hasPermission = await _handleLocationPermission();

      if (!hasPermission) return;
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      debugPrint('position data--> $position');
      emit(LatLogState(currentPosition: position));
    } catch (e) {
      debugPrint(e.toString());
      await Geolocator.requestPermission();
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings().then((value) async {
        permission = await Geolocator.checkPermission();
        debugPrint('permission--> $permission');
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            showToast(
                message: 'Location permissions are denied', isSuccess: false);
            return false;
          }
        }
        if (permission == LocationPermission.deniedForever) {
          showToast(
              message:
                  'Location permissions are permanently denied, we cannot request permissions.',
              isSuccess: false);
          return false;
        }
      });
      return false;
    }

    return true;
  }

  final SignUpRepository _repository = SignUpRepository();
  String userID = '';
  _onSignUpApi(SignUpApiEvent event, Emitter<UserSignUpInfoState> emit) async {
    try {
      emit(SignUpLoadingState());
      final response = await _repository.signUp(model: event.model);

      if (response.isLeft) {
        showToast(
            isSuccess: false,
            message: (response.left.message?.isNotEmpty ?? false)
                ? response.left.message!
                : (response.left.title ?? ""));
        emit(SignUpErrorState());
      } else {
        showToast(isSuccess: true, message: response.right.message!);

        userID = response.right.data?.userId ?? '';

        await PreferenceUtils.setString(prefUserData, userID);
        await PreferenceUtils.setString(
            prefUserEmail, event.model.email?.trim() ?? "");
        await PreferenceUtils.setString(
            prefUserMobile, event.model.phoneNumber?.trim() ?? "");

        event.onComplete?.call();
        emit(SignUpSuccessState());
        Get.offAllNamed('/GenderScreen', arguments: event.model);
      }
    } catch (e) {
      event.onComplete?.call();
      showToast(isSuccess: false, message: e.toString());
      emit(SignUpErrorState());
    }
  }
}
