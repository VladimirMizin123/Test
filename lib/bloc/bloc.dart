import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/bloc/event.dart';
import 'package:gymeats_mobile/bloc/state.dart';

class BlocClass extends Bloc<Event, State> {
  BlocClass() : super(InitialState()) {
    on<ClickEvent>(_onClick);
  }

  _onClick(ClickEvent event, Emitter<State> emit) {
    emit(LoadState());
  }
}
