import 'package:gymeats_mobile/screen/restaurants/model/add_items_model.dart';

abstract class RestaurantEvent {}

/// Get User Address Event ===============================================================
class GetUserAddressEvent extends RestaurantEvent {}

/// Get Restaurant List Event ===============================================================
class GetRestaurantListEvent extends RestaurantEvent {
  final dynamic latitude;
  final dynamic longitude;
  final String userStreetNum;
  final String userStreetName;
  final String userCity;
  final String userState;
  final String userCountry;
  final String userZipcode;
  final bool pickup;
  final int maximumMiles;

  GetRestaurantListEvent(
    this.latitude,
    this.longitude,
    this.userStreetNum,
    this.userStreetName,
    this.userCity,
    this.userState,
    this.userCountry,
    this.userZipcode,
    this.pickup,
    this.maximumMiles,
  );
}

/// Get Restaurant List Event ===============================================================
class GetRestaurantMenuListEvent extends RestaurantEvent {
  final String? restaurantId;
  final bool? pickUp;
  final String? mealType;

  GetRestaurantMenuListEvent(
    this.restaurantId,
    this.pickUp,
    this.mealType,
  );
}

/// Get Cousines List Event ===============================================================
class GetCousinesEvent extends RestaurantEvent {
  final dynamic latitude;
  final dynamic longitude;
  final String userStreetNum;
  final String userStreetName;
  final String userCity;
  final String userState;
  final String userCountry;
  final String userZipcode;
  final bool pickup;
  final int maximumMiles;

  GetCousinesEvent(
    this.latitude,
    this.longitude,
    this.userStreetNum,
    this.userStreetName,
    this.userCity,
    this.userState,
    this.userCountry,
    this.userZipcode,
    this.pickup,
    this.maximumMiles,
  );
}

/// Add to Cart Event ===============================================================
class AddRestaurantCartEvent extends RestaurantEvent {
  final List<AddRestaurantItemsToShoppingListModel> addItemsList;
  AddRestaurantCartEvent({required this.addItemsList});
}

class GetShoppingListEvent extends RestaurantEvent {}
