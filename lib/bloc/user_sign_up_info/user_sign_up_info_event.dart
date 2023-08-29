import '../../models/sign_up_data_navigate_model.dart';

abstract class UserSignUpInfoEvent {}

class LatLogEvent extends UserSignUpInfoEvent {}

class SignUpApiEvent extends UserSignUpInfoEvent {
  UserSignUpDataModel model;

  SignUpApiEvent({required this.model});
}

class LoginApiEvent extends UserSignUpInfoEvent {
  String email;
  String password;
  String gender;

  LoginApiEvent({required this.email, required this.password, required this.gender});
}
