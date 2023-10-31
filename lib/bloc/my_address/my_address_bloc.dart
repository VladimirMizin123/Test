import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/bloc/my_address/my_address_event.dart';
import 'package:gymeats_mobile/bloc/my_address/my_address_state.dart';

class MyAddressBloc extends Bloc<MyAddressEvent, MyAddressState> {
  MyAddressBloc() : super(RadioClickState(selectedState: 'Home')) {
    on<MyAddressLoadEvent>(_changeOption);
  }

  _changeOption(MyAddressLoadEvent event, Emitter<MyAddressState> emit) {
    emit(RadioClickState(selectedState: event.firstOption));
  }
}
