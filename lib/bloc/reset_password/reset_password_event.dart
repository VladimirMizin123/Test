
abstract class ResetPasswordEvent {}

class ButtonClickEvent extends ResetPasswordEvent {
  final String confirmPassword;
  final String password;
  ButtonClickEvent({required this.confirmPassword, required this.password});
}
