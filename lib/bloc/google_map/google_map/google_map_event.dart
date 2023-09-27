import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class GoogleMapEvent {}

class GetCurrentLocationEvent extends GoogleMapEvent {
  final List<Marker> markers;
  final LatLng? selectedLatLng;
  final CameraPosition currentPosition;

  GetCurrentLocationEvent({
    required this.markers,
    required this.selectedLatLng,
    required this.currentPosition,
  });
}

class UpdateExerciseEvent extends GoogleMapEvent {
  final String? id;
  final String? exerciseName;
  final String? calorieBurnedPerMinute;

  UpdateExerciseEvent({
    this.id,
    this.calorieBurnedPerMinute,
    this.exerciseName,
  });
}

class DeleteExerciseEvent extends GoogleMapEvent {
  final String? exerciseName;

  DeleteExerciseEvent({
    this.exerciseName,
  });
}
