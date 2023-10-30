import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/bloc/units/units_event.dart';
import 'package:gymeats_mobile/bloc/units/units_state.dart';

class UnitsBloc extends Bloc<UnitsEvent, UnitsState> {
  UnitsBloc() : super(InitialUnitState()) {
    on<UnitsLoadEvent>(_changeOption);
  }

  _changeOption(UnitsLoadEvent event, Emitter<UnitsState> emit) {
    emit(RadioOnTapState(selectedState: event.selectedOption));
  }
}
