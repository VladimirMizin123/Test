abstract class SignUpEvent {}

class CheckEmailEvent extends SignUpEvent {
  final String email;
  final String fName;
  final String lName;
  final String password;
  final String confirmPassword;
  final String userName;

  CheckEmailEvent({
    required this.email,
    this.fName = '',
    this.lName = '',
    this.password = '',
    this.confirmPassword = '',
    this.userName = '',
  });
}
