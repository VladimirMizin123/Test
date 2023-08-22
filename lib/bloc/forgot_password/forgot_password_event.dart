abstract class ForgotPasswordEvent {}

class ButtonClickEvent extends ForgotPasswordEvent {
  final String email;
  ButtonClickEvent({required this.email});
}
