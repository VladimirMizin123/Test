import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_shopping_list_model.dart';
part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(RestaurantCartState(shoppingList: [])) {
    on<GetCartEvent>(_onGetCart);
    on<AddCartEvent>(_onAddCart);
    on<UpdateCartEvent>(_onUpdateCart);
    on<RemoveCart>(_onRemoveCart);
    on<RemoveCartItem>(_onRemoveCartItem);
    on<ChangeQty>(_onChangeQty);
  }

  _onGetCart(GetCartEvent event, Emitter<CartState> emit) async {
    try {
      List<ShoppingListData> shoppingList = PreferenceUtils.getRestaurantCart();
      emit(RestaurantCartState(shoppingList: shoppingList));
    } catch (e) {
      log(e.toString());
    }
  }

  _onAddCart(AddCartEvent event, Emitter<CartState> emit) {
    try {
      List<ShoppingListData> shoopingList = PreferenceUtils.getRestaurantCart();
      if (!shoopingList.any(
          (element) => element.productId == event.shoppingItem.productId)) {
        shoopingList.add(event.shoppingItem);
        PreferenceUtils.updateResCart(shoopingList);
        emit(RestaurantCartState(shoppingList: shoopingList));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  _onUpdateCart(UpdateCartEvent event, Emitter<CartState> emit) {
    try {
      List<ShoppingListData> shoppingList = PreferenceUtils.getRestaurantCart();
      int index = shoppingList.indexWhere(
          (element) => element.productId == event.shoppingItem.productId);
      if (!index.isNegative) {
        shoppingList[index] = event.shoppingItem;
        PreferenceUtils.updateResCart(shoppingList);
        emit(RestaurantCartState(shoppingList: shoppingList));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  _onRemoveCart(RemoveCart event, Emitter<CartState> emit) {
    try {
      PreferenceUtils.updateResCart([]);
      emit(RestaurantCartState(shoppingList: []));
    } catch (e) {
      log(e.toString());
    }
  }

  _onRemoveCartItem(RemoveCartItem event, Emitter<CartState> emit) {
    try {
      List<ShoppingListData> shoppingList = PreferenceUtils.getRestaurantCart();
      shoppingList
          .removeWhere((element) => element.productId == event.productID);
      PreferenceUtils.updateResCart(shoppingList);
      emit(RestaurantCartState(shoppingList: shoppingList));
    } catch (e) {
      log(e.toString());
    }
  }

  _onChangeQty(ChangeQty event, Emitter<CartState> emit) {
    List<ShoppingListData> shoppingList = PreferenceUtils.getRestaurantCart();
    int index = shoppingList
        .indexWhere((element) => element.productId == event.productID);
    if (index.isNegative) return;
    int qty = shoppingList[index].quantity ?? 0;
    switch (event.type) {
      case ModifyType.decrement:
        if (qty <= 1) {
          shoppingList.removeAt(index);
          break;
        } else {
          shoppingList[index].price =
              ((shoppingList[index].price! / qty) * (qty - 1)).toInt();
          shoppingList[index].quantity = qty - 1;
        }
        break;
      case ModifyType.increment:
        shoppingList[index].price =
            ((shoppingList[index].price! / qty) * (qty + 1)).toInt();
        shoppingList[index].quantity = qty + 1;
        break;
    }

    PreferenceUtils.updateResCart(shoppingList);
    emit(RestaurantCartState(shoppingList: shoppingList));
  }
}
