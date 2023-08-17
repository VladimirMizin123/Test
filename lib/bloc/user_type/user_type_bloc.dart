import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/bloc/user_type/user_type_event.dart';
import 'package:gymeats_mobile/bloc/user_type/user_type_state.dart';

class UserTypeBloc extends Bloc<UserTypeEvent, UserTypeState> {
  UserTypeBloc() : super(InitialState()) {
    on<UserTypeClickEvent>(_onUserType);
    on<TextChangeEvent>(_onTextChange);
  }

  _onUserType(UserTypeClickEvent event, Emitter<UserTypeState> emit) {
    emit(UserTypeClickState(isMale: event.isMale,isFemale: event.isFemale,isNon: event.isNon));
  }

  _onTextChange(TextChangeEvent event, Emitter<UserTypeState> emit) {
    if(event.age.isEmpty || event.height.isEmpty || event.weight.isEmpty){
      emit(ChangeButtonState(isVisible: false));
    }else{
      emit(ChangeButtonState(isVisible: true));
    }
  }
}