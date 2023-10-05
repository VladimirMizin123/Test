import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/bloc/sign_up/sign_up_event.dart';
import 'package:gymeats_mobile/bloc/sign_up/sign_up_state.dart';
import 'package:gymeats_mobile/constant/string_utils.dart';
import '../../models/sign_up_data_navigate_model.dart';
import '../../repository/sign_up.dart';
import '../../widget/app_widget.dart';

class SignUpBloc extends Bloc<CheckEmailEvent, SignUpState> {
  SignUpBloc() : super(InitialState()) {
    on<CheckEmailEvent>(_onCheckEmailExist);
  }

  final SignUpRepository _repository = SignUpRepository();

  _onCheckEmailExist(CheckEmailEvent event, Emitter<SignUpState> emit) async {
    try {
      await _repository.checkIsEmailExist(event.email).fold((left) {
        onFailError(emit: emit, text: left.errorMessage!);
      }, (right) async {
        if (right.data?.isEmailExist == true) {
          showToast(
              isSuccess: false, message: StringUtils.alreadyRegisterEmail);
          emit(IsEmailErrorState());
        } else {
          UserSignUpDataModel userData = UserSignUpDataModel(
            firstName: event.fName,
            lastName: event.lName,
            email: event.email,
            password: event.password,
            userName: event.email,
            confirmPassword: event.confirmPassword,
          );
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
