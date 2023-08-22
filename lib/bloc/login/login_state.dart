abstract class LoginState {}

class InitialState extends LoginState {}

class LoginSuccessfulState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginErrorState extends LoginState {
}
