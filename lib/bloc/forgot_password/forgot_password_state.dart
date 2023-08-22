abstract class ForgotPasswordState {}

class InitialState extends ForgotPasswordState {}

class ForgotSuccessState extends ForgotPasswordState {}

class ForgotLoadingState extends ForgotPasswordState {}

class ForgotErrorState extends ForgotPasswordState {
}
