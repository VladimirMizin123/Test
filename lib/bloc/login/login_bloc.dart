import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/login/login_event.dart';
import 'package:gymeats_mobile/bloc/login/login_state.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import '../../app/functions.dart';
import '../../app/sharedPrefrence.dart';
import '../../repository/login.dart';
import '../../widget/app_widget.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(InitialState()) {
    on<LoginClickEvent>(_onLogin);
  }

  final LoginRepository _repository = LoginRepository();

  _onLogin(LoginClickEvent event, Emitter<LoginState> emit) async {
    debugPrint('email--> ${event.email}');
    debugPrint('password--> ${event.password}');
    bool isEmail = emailValid(event.email);
    bool isPassword = passwordValid(event.password);
    bool isValidEmail = validateEmail(event.email);

    if (isEmail && isPassword && isValidEmail) {
      emit(LoginLoadingState());
      try {
        await _repository
            .login(email: event.email.trim(), password: event.password)
            .fold((left) {
          onFailError(emit: emit, text: left.errorMessage!);
        }, (right) {
          if (right.data != null) {
            PreferenceUtils.setString(
                prefToken, right.data!.token!.accessToken!);
          }

          emit(LoginSuccessfulState());
          Get.toNamed('/AppManagerScreen');
        });
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
