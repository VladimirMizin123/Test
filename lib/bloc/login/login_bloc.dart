import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/bloc/login/login_event.dart';
import 'package:gymeats_mobile/bloc/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(InitialState()) {
    on<LoginClickEvent>((event, emit) {});
  }
}
