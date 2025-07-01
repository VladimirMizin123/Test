import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/bloc/dashboard/cart_bloc/cart_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';

part 'store_cart_event.dart';
part 'store_cart_state.dart';

class StoreCartBloc extends Bloc<StoreCartEvent, StoreCartState> {
  StoreCartBloc() : super(StoreCheckoutState(menuItemList: [])) {
    on<ModifyCart>(_onModifyCart);
    on<GetGroceryCartList>(_getGroceryCartList);
    on<ChangeGroceryQty>(_onChangeQty);
  }
  _onModifyCart(ModifyCart event, Emitter<StoreCartState> emit) async {
    Object s = state;
    if (s is StoreCheckoutState) {
      List<MenuItemList> actualList = s.menuItemList;
      List<MenuItemList> updatedList = event.menuItemList
          .where((element) =>
              element.cartQuantity != null && element.cartQuantity! > 0)
          .toList();
      for (int i = 0; i < updatedList.length; i++) {
        int index = actualList.indexWhere(
            (element) => element.productId == updatedList[i].productId);
        if (index.isNegative) {
          actualList.add(updatedList[i]);
        } else {
          actualList[index] = updatedList[i];
        }
      }
      actualList.removeWhere(
        (element) => element.cartQuantity == null || element.cartQuantity! <= 0,
      );
      emit(StoreCheckoutState(menuItemList: actualList));
    }
  }

  _getGroceryCartList(GetGroceryCartList event, Emitter<StoreCartState> emit) {
    try {
      Object s = state;
      if (s is StoreCheckoutState) {
        // emit(StoreCheckoutState(menuItemList: s.menuItemList));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  _onChangeQty(ChangeGroceryQty event, Emitter<StoreCartState> emit) {
    final s = state;
    if (s is StoreCheckoutState) {
      final List<MenuItemList> shoppingList = List.from(s.menuItemList);

      final index = shoppingList.indexWhere((e) => e.productId == event.productID);
      if (index == -1) return;

      final qty = shoppingList[index].cartQuantity ?? 0;

      switch (event.type) {
        case ModifyType.decrement:
          if (qty <= 1) {
            shoppingList.removeAt(index);
          } else {
            final unitPrice = shoppingList[index].totalPrice! / qty;
            shoppingList[index].cartQuantity = qty - 1;
            shoppingList[index].totalPrice = (unitPrice * (qty - 1)).toInt();
          }
          break;

        case ModifyType.increment:
          final unitPrice = shoppingList[index].totalPrice! / qty;
          shoppingList[index].cartQuantity = qty + 1;
          shoppingList[index].totalPrice = (unitPrice * (qty + 1)).toInt();
          break;
      }

      emit(StoreCheckoutState(menuItemList: shoppingList));
    }
  }
}
