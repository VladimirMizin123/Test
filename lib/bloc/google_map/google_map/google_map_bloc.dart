import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymeats_mobile/bloc/google_map/google_map/google_map_event.dart';
import 'package:gymeats_mobile/bloc/google_map/google_map/google_map_state.dart';

class GoogleMapBloc extends Bloc<GoogleMapEvent, GoogleMapState> {
  GoogleMapBloc() : super(InitialState()) {
    // on<GetCurrentLocationEvent>(getCurrentLocation);
    // on<UpdateExerciseEvent>(_onUpdateExercise);
    // on<DeleteExerciseEvent>(_onDeleteExercise);
  }
}
