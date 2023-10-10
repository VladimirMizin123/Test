abstract class AddWaterState {}

class InitialState extends AddWaterState {}

class AddWaterSuccessfulState extends AddWaterState {}

class LoadingState extends AddWaterState {}

class ErrorState extends AddWaterState {}

class UpdateWaterSuccessfulState extends AddWaterState {}

class UpdateWaterLoadingState extends AddWaterState {}

class UpdateWaterErrorState extends AddWaterState {}
