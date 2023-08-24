import 'package:geolocator/geolocator.dart';

abstract class UserSignUpInfoState{}

class InitialState extends UserSignUpInfoState{}

class LatLogState extends UserSignUpInfoState{
  final Position currentPosition;
  LatLogState({required this.currentPosition});
}

class SignUpSuccessState extends UserSignUpInfoState {}

class SignUpLoadingState extends UserSignUpInfoState {}

class SignUpErrorState extends UserSignUpInfoState {}