import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/bloc/sign_up/sign_up_event.dart';
import 'package:gymeats_mobile/bloc/sign_up/sign_up_state.dart';
import '../../models/sign_up_data_navigate_model.dart';
import '../../repository/sign_up.dart';
import '../../widget/app_widget.dart';

class SignUpBloc extends Bloc<CheckEmailEvent, SignUpState> {
  SignUpBloc() : super(InitialState()) {
    on<CheckEmailEvent>(_onCheckEmailExist);
  }

  final SignUpRepository _repository = SignUpRepository();

  _onCheckEmailExist(CheckEmailEvent event, Emitter<SignUpState> emit) async {
    emit(LoggingState());

    try {
      Map<String, String> req = {
        "email": event.email,
        "password": event.password,
        "confirmPassword": event.confirmPassword,
      };
      await _repository.registerUser(req).fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) async {
        if (right.data == null) {
          showToast(isSuccess: false, message: right.message);
          emit(IsEmailErrorState());
        } else {
          UserSignUpDataModel userData = UserSignUpDataModel(
            firstName: event.fName,
            lastName: event.lName,
            email: event.email,
            password: event.password,
            userName: event.userName,
            confirmPassword: event.confirmPassword,
            phoneNumber: event.phoneNumber,
            userId: right.data?.userId,
            referralCode: event.referralCode,
          );
          await PreferenceUtils.setString(prefUserEmail, event.email.trim());
          await PreferenceUtils.setString(prefUserName, event.userName);
          emit(InitialState());
          await Get.toNamed('/GoogleMapScreen',
              arguments: {"string": 'isFromRegister', "userData": userData});
        }
      });
    } catch (e) {
      showToast(isSuccess: false, message: e.toString());
      emit(IsEmailErrorState());
    }
  }

  onFailError({required String text, required Emitter<SignUpState> emit}) {
    showToast(isSuccess: false, message: text);
    emit(IsEmailErrorState());
  }
}
