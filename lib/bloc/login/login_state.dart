abstract class LoginState {}

class InitialState extends LoginState {}

class LoginClickState extends LoginState {
  final String email;
  final String password;
  LoginClickState({required this.email, required this.password});
}

class LoginSuccessful extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginErrorState extends LoginState {
  final String error;
  LoginErrorState({required this.error});
}
