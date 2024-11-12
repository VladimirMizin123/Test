part of 'store_cart_bloc.dart';

abstract class StoreCartEvent {}

class ModifyCart extends StoreCartEvent {
  final List<MenuItemList> menuItemList;

  ModifyCart({required this.menuItemList});
}

class GetGroceryCartList extends StoreCartEvent {
  GetGroceryCartList();
}

class ChangeGroceryQty extends StoreCartEvent {
  final String? productID;
  final ModifyType type;
  ChangeGroceryQty({required this.productID, required this.type});
}
