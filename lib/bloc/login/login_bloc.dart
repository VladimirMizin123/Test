import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/login/login_event.dart';
import 'package:gymeats_mobile/bloc/login/login_state.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';

import '../../app/functions.dart';
import '../../repository/get_user_details.dart';
import '../../repository/login.dart';
import '../../widget/app_widget.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(InitialState()) {
    on<LoginClickEvent>(_onLogin);
  }

  final LoginRepository _repository = LoginRepository();
  final GetUserDetailsByIDDataRepository _dataRepository =
      GetUserDetailsByIDDataRepository();

  _onLogin(LoginClickEvent event, Emitter<LoginState> emit) async {
    debugPrint('email--> ${event.email}');
    debugPrint('password--> ${event.password}');
    bool isEmail = emailValid(event.email);
    bool isPassword = passwordValid(event.password);
    bool isValidEmail = validateEmail(event.email);

    if (isEmail && isPassword && isValidEmail) {
      emit(LoginLoadingState());
      try {
        final response = await _repository.login(
            email: event.email.trim(), password: event.password);

        response.fold((left) {
          onFailError(emit: emit, text: left.errorMessage!);
        }, (right) async {
          if (right.data != null) {
            await PreferenceUtils.setString(
                prefToken, right.data!.token!.accessToken!);

            log('right.data!.token!.accessToken!---------->>>>>> ${right.data!.token!.accessToken!}');

            userId = right.data!.userId!;
            await PreferenceUtils.setString(prefUserData, right.data!.userId!);
            await PreferenceUtils.setString(prefUserEmail, event.email.trim());
            await PreferenceUtils.setBool(prefIsLogin, true);
            await PreferenceUtils.setBool(prefIsConfirmEmail, true);
          }
          final getUserDetailsResponse = await _dataRepository
              .getUserDetailsData(right.data?.userId ?? userId);
          getUserDetailsResponse.fold((left) {
            onFailError(emit: emit, text: left.errorMessage!);
          }, (r) async {
            final getGender = r.data!.gender;

            await PreferenceUtils.setString(
                prefUserMobile, r.data?.phoneNumber ?? '');
            // emit(LoginSuccessfulState());
            Get.toNamed('/RandomLoginScreen',
                arguments: getGender.toString().capitalizeFirst);
            // Get.toNamed('/AppManagerScreen', preventDuplicates: false);
          });
        });
        // await _repository
        //     .login(email: event.email.trim(), password: event.password)
        //     .fold((left) {
        //   onFailError(emit: emit, text: left.errorMessage!);
        // }, (right) {
        //   if (right.data != null) {
        //     PreferenceUtils.setString(
        //         prefToken, right.data!.token!.accessToken!);
        //     userId = right.data!.userId!;
        //     PreferenceUtils.setString(prefUserData, right.data!.userId!);
        //     PreferenceUtils.setBool(prefIsLogin, true);
        //     PreferenceUtils.setBool(prefIsConfirmEmail, true);
        //   }
        //   emit(LoginSuccessfulState());
        //   // Get.toNamed('/FirstPersonalizedWelcomeScreen',arguments: );
        //   Get.toNamed('/AppManagerScreen', preventDuplicates: false);
        // });
      } catch (e) {
        showToast(isSuccess: false, message: e.toString());
        emit(LoginErrorState());
      }
    } else {
      if (!isEmail) {
        onFailError(emit: emit, text: StringUtils.pleaseEnterEmail);
      } else if (!isValidEmail) {
        onFailError(emit: emit, text: StringUtils.enterValidEmail);
      } else if (!isPassword) {
        onFailError(emit: emit, text: StringUtils.pleaseEnterPassword);
      }
    }
  }

  onFailError({required String text, required Emitter<LoginState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(LoginErrorState());
  }

  bool emailValid(String email) {
    if (email.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool passwordValid(String password) {
    if (password.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
