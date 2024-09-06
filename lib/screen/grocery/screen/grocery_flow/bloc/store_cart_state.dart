part of 'store_cart_bloc.dart';

abstract class StoreCartState {}

class StoreCheckoutState extends StoreCartState {
  final List<MenuItemList> menuItemList;

  StoreCheckoutState({required this.menuItemList});
}
