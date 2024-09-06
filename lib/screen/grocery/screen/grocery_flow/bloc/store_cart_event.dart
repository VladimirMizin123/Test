part of 'store_cart_bloc.dart';

abstract class StoreCartEvent {}

class ModifyCart extends StoreCartEvent {
  final List<MenuItemList> menuItemList;

  ModifyCart({required this.menuItemList});
}
