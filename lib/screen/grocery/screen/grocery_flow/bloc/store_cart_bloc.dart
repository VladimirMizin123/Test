import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';

part 'store_cart_event.dart';
part 'store_cart_state.dart';

class StoreCartBloc extends Bloc<StoreCartEvent, StoreCartState> {
  StoreCartBloc() : super(StoreCheckoutState(menuItemList: [])) {
    on<ModifyCart>(_onModifyCart);
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
}
