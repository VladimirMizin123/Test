import 'dart:io';

import 'package:gymeats_mobile/models/get_custom_meal_list_model.dart';

abstract class AddNewMealState {}

class InitialState extends AddNewMealState {}

class AddNewMealSuccessfulState extends AddNewMealState {
  final String? productId;

  AddNewMealSuccessfulState({this.productId});
}

class AddNewMealLoadingState extends AddNewMealState {
  final String? productId;

  AddNewMealLoadingState({this.productId});
}

class AddNewMealErrorState extends AddNewMealState {
  final String? productId;

  AddNewMealErrorState({this.productId});
}

class SelectedImagePathState extends AddNewMealState {
  final File? imgPath;

  SelectedImagePathState({required this.imgPath});
}

/// Get Grocery State ===============================================================

class GetCustomMealListSuccessState extends AddNewMealState {
  final List<CustomMealDetails>? customMealDetails;

  GetCustomMealListSuccessState({this.customMealDetails});
}

class GetCustomMealListLoadingState extends AddNewMealState {}

class GetCustomMealListErrorState extends AddNewMealState {}
