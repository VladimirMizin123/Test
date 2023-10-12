import 'package:gymeats_mobile/models/get_grocery_item_list_model.dart';

abstract class AddNewGroceryItemState {}

class InitialState extends AddNewGroceryItemState {}

class AddGroceryItemSuccessfulState extends AddNewGroceryItemState {
  final String? productId;

  AddGroceryItemSuccessfulState({this.productId});
}

class LoadingState extends AddNewGroceryItemState {
  final String? productId;

  LoadingState({this.productId});
}

class ErrorState extends AddNewGroceryItemState {
  final String? productId;

  ErrorState({this.productId});
}

/// Get Grocery State ===============================================================

class GetGroceryListSuccessState extends AddNewGroceryItemState {
  final List<GroceryDetails>? groceryDetails;

  GetGroceryListSuccessState({this.groceryDetails});
}

class GetGroceryListLoadingState extends AddNewGroceryItemState {}

class GetGroceryListErrorState extends AddNewGroceryItemState {}

/// Remove Grocery Item State ===============================================================

class RemoveGroceryItemLoadingState extends AddNewGroceryItemState {
  final String? userGroceryListId;

  RemoveGroceryItemLoadingState({
    this.userGroceryListId,
  });
}

class RemoveGroceryItemSuccessState extends AddNewGroceryItemState {
  final String? userGroceryListId;
  final bool? isDelete;

  RemoveGroceryItemSuccessState(
      {required this.userGroceryListId, required this.isDelete});
}

class RemoveGroceryItemErrorState extends AddNewGroceryItemState {
  final String? userGroceryListId;

  RemoveGroceryItemErrorState({required this.userGroceryListId});
}

/// Update Add Grocery List State ===============================================================

class UpdateAddGroceryListLoadingState extends AddNewGroceryItemState {
  final String? userGroceryListId;

  UpdateAddGroceryListLoadingState({required this.userGroceryListId});
}

class UpdateAddGroceryListErrorState extends AddNewGroceryItemState {
  final String? userGroceryListId;

  UpdateAddGroceryListErrorState({required this.userGroceryListId});
}

class UpdateAddGroceryListSuccessState extends AddNewGroceryItemState {
  final String? userGroceryListId;

  UpdateAddGroceryListSuccessState({required this.userGroceryListId});
}

/// Update Remove Grocery List State ===============================================================

class UpdateRemoveGroceryListLoadingState extends AddNewGroceryItemState {
  final String? userGroceryListId;

  UpdateRemoveGroceryListLoadingState({required this.userGroceryListId});
}

class UpdateRemoveGroceryListErrorState extends AddNewGroceryItemState {
  final String? userGroceryListId;

  UpdateRemoveGroceryListErrorState({required this.userGroceryListId});
}

class UpdateRemoveGroceryListSuccessState extends AddNewGroceryItemState {
  final String? userGroceryListId;

  UpdateRemoveGroceryListSuccessState({required this.userGroceryListId});
}

/// Clear Grocery List State ===============================================================

class ClearGroceryListLoadingState extends AddNewGroceryItemState {}

class ClearGroceryListErrorState extends AddNewGroceryItemState {}

class ClearGroceryListSuccessState extends AddNewGroceryItemState {
  final bool isClear;

  ClearGroceryListSuccessState({required this.isClear});
}
