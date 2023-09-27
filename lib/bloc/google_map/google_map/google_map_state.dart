abstract class GoogleMapState {}

class InitialState extends GoogleMapState {}

class GoogleMapSuccessfulState extends GoogleMapState {}

class LoadingState extends GoogleMapState {}

class ErrorState extends GoogleMapState {}

class UpdateLoadingState extends GoogleMapState {}

class UpdateLoadingSuccessState extends GoogleMapState {}

class DeleteLoadingState extends GoogleMapState {}

class DeleteLoadingSuccessState extends GoogleMapState {}
