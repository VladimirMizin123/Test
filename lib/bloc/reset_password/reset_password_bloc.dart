import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/reset_password/reset_password_event.dart';
import 'package:gymeats_mobile/bloc/reset_password/reset_password_state.dart';
import 'package:gymeats_mobile/constant/app_string.dart';
import '../../app/functions.dart';
import '../../repository/login.dart';
import '../../repository/reset_password.dart';
import '../../widget/app_widget.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc() : super(InitialState()) {
    on<ButtonClickEvent>(_onLogin);
  }

  final ResetPasswordRepository _repository = ResetPasswordRepository();

  _onLogin(ButtonClickEvent event, Emitter<ResetPasswordState> emit) async {
    bool isNewPassword = newPasswordValid(event.password);
    bool isConfirmPassword = confirmPasswordValid(event.confirmPassword);
    bool isPasswordMatch =
        validateConfirmPassword(event.password, event.confirmPassword);
    bool isPasswordValid = validatePassword(
      event.password,
    );

    if (isConfirmPassword && isNewPassword && isPasswordMatch) {
      emit(ResetLoadingState());
      try {
        await _repository
            .resetPassword(
                newPassword: event.password,
                confirmPassword: event.confirmPassword)
            .fold((left) {
          onFailError(emit: emit, text: left.errorMessage!);
        }, (right) {
          emit(ResetSuccessState());
          Get.toNamed('/LoginScreen', preventDuplicates: false);
        });
      } catch (e) {
        showToast(isSuccess: false, message: e.toString());
        emit(ResetErrorState());
      }
    } else {
      if (!isNewPassword) {
        onFailError(emit: emit, text: AppStrings.pleaseEnterNewPassword);
      } else if (!isPasswordValid) {
        onFailError(emit: emit, text: AppStrings.pleaseEnterPasswordValidation);
      } else if (!isConfirmPassword) {
        onFailError(emit: emit, text: AppStrings.pleaseEnterConfirmPassword);
      } else if (!isPasswordMatch) {
        onFailError(emit: emit, text: AppStrings.passwordNotMatch);
      }
    }
  }

  onFailError(
      {required String text, required Emitter<ResetPasswordState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(ResetErrorState());
  }

  bool confirmPasswordValid(String password) {
    if (password.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool newPasswordValid(String password) {
    if (password.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
