import 'dart:async';
import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gymeats_mobile/bloc/user_sign_up_info/user_sign_up_info_event.dart';
import 'package:gymeats_mobile/bloc/user_sign_up_info/user_sign_up_info_state.dart';
import 'package:gymeats_mobile/models/sign_up_model.dart';

import '../../app/sharedPrefrence.dart';
import '../../repository/login.dart';
import '../../repository/sign_up.dart';
import '../../widget/app_widget.dart';

class UserSignUpInfoBloc
    extends Bloc<UserSignUpInfoEvent, UserSignUpInfoState> {
  UserSignUpInfoBloc() : super(InitialState()) {
    on<LatLogEvent>(_onLatLog);
    on<SignUpApiEvent>(_onSignUpApi);
    on<LoginApiEvent>(_onLoginApi);
  }

  _onLatLog(LatLogEvent event, Emitter<UserSignUpInfoState> emit) {
    getCurrentPosition();
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      debugPrint('position data--> $position');

      emit(LatLogState(currentPosition: position));
    }).catchError((e) async {
      debugPrint(e.toString());
      await Geolocator.requestPermission();
    });
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
  final LoginRepository _loginRepository = LoginRepository();

  _onSignUpApi(SignUpApiEvent event, Emitter<UserSignUpInfoState> emit) async {
    try {
      emit(SignUpLoadingState());
      await _repository.signUp(model: event.model).fold((left) {
        showToast(isSuccess: false, message: left.message!);
        emit(SignUpErrorState());
      }, (right) async {
        if (right.data != null) {
          userData = right.data!;
          await PreferenceUtils.setBool(prefIsLogin, true);
          await PreferenceUtils.setString(prefUserData, jsonEncode(right.data!));
        }
        showToast(isSuccess: true, message: right.message!);
        emit(LoginApiState());

      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(SignUpErrorState());
    }
  }

  _onLoginApi(LoginApiEvent event, Emitter<UserSignUpInfoState> emit) {
    _loginRepository.login(email: event.email, password: event.password).fold((left) {},
            (right) async {
          if (right.data != null) {
            PreferenceUtils.setString(prefToken, right.data!.token!.accessToken!);
            userData = UserData(userId: right.data!.userId);
          }
          emit(SignUpSuccessState());
          Get.toNamed('/GenderScreen', arguments: event.gender);
        });
  }
}
