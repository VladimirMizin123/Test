import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_manager_event.dart';
part 'app_manager_state.dart';

class AppManagerBloc extends Bloc<AppManagerEvent, AppManagerState> {
  AppManagerBloc() : super(AppManagerInitial()) {
    on<AppManagerEvent>((event, emit) {});
  }
}
