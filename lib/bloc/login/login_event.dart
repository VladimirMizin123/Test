abstract class LoginEvent {}

class LoginClickEvent extends LoginEvent {
  final String email;
  final String password;
  LoginClickEvent({required this.email, required this.password});
}
