import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/bloc/profile/profile_event.dart';
import 'package:gymeats_mobile/bloc/profile/profile_state.dart';

class ProfileBloc extends Bloc<ShowDateEvent, ShowDateState> {
  ProfileBloc() : super(InitialDate());

  _ocClickDate(ClickDateEvent event, Emitter<ShowDateState> emit) {}
}
