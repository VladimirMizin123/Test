abstract class SignUpEvent {}

class CheckEmailEvent extends SignUpEvent {
  final String email;
  final String fName;
  final String lName;
  final String password;
  final String confirmPassword;
  final String userName;
  final String phoneNumber;

  CheckEmailEvent({
    required this.email,
    this.fName = '',
    this.lName = '',
    this.password = '',
    this.confirmPassword = '',
    this.userName = '',
    this.phoneNumber = '',
  });
}
