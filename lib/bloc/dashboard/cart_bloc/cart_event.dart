part of 'cart_bloc.dart';

sealed class CartEvent {}

class GetCartEvent extends CartEvent {
  GetCartEvent();
}

class AddCartEvent extends CartEvent {
  final ShoppingListData shoppingItem;

  AddCartEvent({required this.shoppingItem});
}

class UpdateCartEvent extends CartEvent {
  final ShoppingListData shoppingItem;

  UpdateCartEvent({required this.shoppingItem});
}

class RemoveCart extends CartEvent {}

class RemoveCartItem extends CartEvent {
  String? productID;
  RemoveCartItem({required this.productID});
}

class ChangeQty extends CartEvent {
  final String? productID;
  final ModifyType type;
  ChangeQty({required this.productID, required this.type});
}

enum ModifyType { increment, decrement }
