abstract class AddWaterState {}

class InitialState extends AddWaterState {}

class AddWaterSuccessfulState extends AddWaterState {}

class LoadingState extends AddWaterState {}

class ErrorState extends AddWaterState {}

class UpdateLoadingState extends AddWaterState {}
class UpdateLoadingSuccessState extends AddWaterState {}

class DeleteLoadingState extends AddWaterState {}

class DeleteLoadingSuccessState extends AddWaterState {}
