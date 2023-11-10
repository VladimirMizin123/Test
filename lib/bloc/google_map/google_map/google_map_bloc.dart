import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/bloc/google_map/google_map/google_map_event.dart';
import 'package:gymeats_mobile/bloc/google_map/google_map/google_map_state.dart';

class GoogleMapBloc extends Bloc<GoogleMapEvent, GoogleMapState> {
  GoogleMapBloc() : super(InitialState()) {
    // on<GetCurrentLocationEvent>(getCurrentLocation);
    // on<UpdateExerciseEvent>(_onUpdateExercise);
    // on<DeleteExerciseEvent>(_onDeleteExercise);
  }
}
