import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';

import '../../app/functions.dart';
import '../../repository/forgot_password.dart';
import '../../widget/app_widget.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ButtonClickEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(InitialState()) {
    on<ButtonClickEvent>(_onForgotPassword);
  }

  final ForgotPasswordRepository _repository = ForgotPasswordRepository();

  _onForgotPassword(
      ButtonClickEvent event, Emitter<ForgotPasswordState> emit) async {
    bool isEmail = emailValid(event.email);
    bool isValidEmail = validateEmail(event.email);

    if (isEmail && isValidEmail) {
      emit(ForgotLoadingState());
      try {
        await _repository.checkEmailExistFunction(event.email).fold((left) {
          onFailError(emit: emit, text: left.errorMessage!);
        }, (right) async {
          if (right.data!.isEmailExist == true) {
            await _repository
                .forgotPassword(
              email: event.email,
            )
                .fold((left) {
              onFailError(emit: emit, text: left.errorMessage!);
            }, (right) async {
              showToast(isSuccess: true, message: right.message!);
              emit(ForgotSuccessState());
              Get.toNamed('/OpenEmailAppScreen');
            });
          } else {
            onFailError(emit: emit, text: "Email address is not registered.");
          }
        });
      } catch (e) {
        showToast(isSuccess: false, message: e.toString());
        emit(ForgotErrorState());
      }
    } else {
      if (isEmail) {
        onFailError(emit: emit, text: StringUtils.enterValidEmail);
      } else {
        onFailError(emit: emit, text: StringUtils.pleaseEnterEmail);
      }
    }
  }

  onFailError(
      {required String text, required Emitter<ForgotPasswordState> emit}) {
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
