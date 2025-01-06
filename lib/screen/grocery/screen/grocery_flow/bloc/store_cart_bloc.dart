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
        emit(StoreCheckoutState(menuItemList: s.menuItemList));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  _onChangeQty(ChangeGroceryQty event, Emitter<StoreCartState> emit) {
    Object s = state;
    if (s is StoreCheckoutState) {
      List<MenuItemList> shoppingList = s.menuItemList;
      int index = shoppingList
          .indexWhere((element) => element.productId == event.productID);
      if (index.isNegative) return;
      int qty = shoppingList[index].cartQuantity ?? 0;
      switch (event.type) {
        case ModifyType.decrement:
          if (qty <= 1) {
            shoppingList.removeAt(index);
            break;
          } else {
            shoppingList[index].totalPrice =
                ((shoppingList[index].totalPrice! / qty) * (qty - 1)).toInt();
            shoppingList[index].cartQuantity = qty - 1;
          }
          break;
        case ModifyType.increment:
          shoppingList[index].totalPrice =
              ((shoppingList[index].totalPrice! / qty) * (qty + 1)).toInt();
          shoppingList[index].cartQuantity = qty + 1;
          break;
      }
      emit(StoreCheckoutState(menuItemList: shoppingList));
    }
  }
}
