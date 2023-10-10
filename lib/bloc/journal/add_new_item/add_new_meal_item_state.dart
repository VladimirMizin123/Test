import 'dart:io';

abstract class AddNewMealState {}

class InitialState extends AddNewMealState {}

class AddNewMealSuccessfulState extends AddNewMealState {}

class LoadingState extends AddNewMealState {}

class ErrorState extends AddNewMealState {}

class SelectedImagePathState extends AddNewMealState {
  final File? imgPath;

  SelectedImagePathState({required this.imgPath});
}
