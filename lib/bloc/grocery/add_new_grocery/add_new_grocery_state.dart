import 'package:gymeats_mobile/models/get_grocery_item_list_model.dart';

abstract class AddNewGroceryItemState {}

class InitialState extends AddNewGroceryItemState {}

class AddGroceryItemSuccessfulState extends AddNewGroceryItemState {}

class LoadingState extends AddNewGroceryItemState {}

class ErrorState extends AddNewGroceryItemState {}

class GetGroceryListSuccessState extends AddNewGroceryItemState {
  final List<GroceryDetails>? groceryDetails;

  GetGroceryListSuccessState({this.groceryDetails});
}

class GetGroceryListLoadingState extends AddNewGroceryItemState {}

class GetGroceryListErrorState extends AddNewGroceryItemState {}

/// Remove Grocery Item

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
