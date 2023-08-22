abstract class ResetPasswordState {}

class InitialState extends ResetPasswordState {}

class ResetSuccessState extends ResetPasswordState {}

class ResetLoadingState extends ResetPasswordState {}

class ResetErrorState extends ResetPasswordState {
}
