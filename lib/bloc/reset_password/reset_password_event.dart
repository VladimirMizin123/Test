
abstract class ResetPasswordEvent {}

class ButtonClickEvent extends ResetPasswordEvent {
  final String confirmPassword;
  final String password;
  final String passwordResetToken;
  ButtonClickEvent({required this.confirmPassword, required this.password, required this.passwordResetToken});
}
