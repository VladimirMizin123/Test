part of 'cart_bloc.dart';

sealed class CartState {}

class RestaurantCartState extends CartState {
  final List<ShoppingListData> shoppingList;

  RestaurantCartState({required this.shoppingList});
}
