abstract class UserTypeState{}

class InitialState extends UserTypeState{}

class UserTypeClickState extends UserTypeState{
  final bool isMale;
  final bool isFemale;
  final bool isNon;
  UserTypeClickState({required this.isNon, required this.isFemale, required this.isMale});
}

class ChangeButtonState extends UserTypeState{
  final bool isVisible;
  ChangeButtonState({required this.isVisible});
}