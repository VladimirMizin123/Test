import '../../models/sign_up_data_navigate_model.dart';

abstract class UserSignUpInfoEvent {}

class LatLogEvent extends UserSignUpInfoEvent {}

class SignUpApiEvent extends UserSignUpInfoEvent {
  UserSignUpDataModel model;

  SignUpApiEvent({required this.model});
}
