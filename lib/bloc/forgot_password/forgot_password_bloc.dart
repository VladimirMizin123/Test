import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';

import '../../app/functions.dart';
import '../../app/sharedPrefrence.dart';
import '../../repository/forgot_password.dart';
import '../../widget/app_widget.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ButtonClickEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(InitialState()) {
    on<ButtonClickEvent>(_onForgotPassword);
  }

  final ForgotPasswordRepository _repository = ForgotPasswordRepository();

  _onForgotPassword(ButtonClickEvent event, Emitter<ForgotPasswordState> emit) async {
    bool isEmail = emailValid(event.email);
    bool isValidEmail = validateEmail(event.email);

    if (isEmail && isValidEmail) {
      emit(ForgotLoadingState());
      try {
        await _repository
            .forgotPassword(
          email: event.email,
        )
            .fold((left) {
          onFailError(emit: emit, text: left.errorMessage!);
        }, (right) async {
          showToast(isSuccess: true, message: right.message!);
          emit(ForgotSuccessState());
          if (right.data != null) {
            await PreferenceUtils.setString(passwordResetToken, right.data);
          }
          Get.toNamed('/OpenEmailAppScreen');
        });
      } catch (e) {
        showToast(isSuccess: false, message: e.toString());
        emit(ForgotErrorState());
      }
    } else {
      if (isEmail) {
        onFailError(emit: emit, text: StringUtils.pleaseEnterEmail);
      } else {
        onFailError(emit: emit, text: StringUtils.enterValidEmail);
      }
    }
  }

  onFailError({required String text, required Emitter<ForgotPasswordState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(ForgotErrorState());
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
