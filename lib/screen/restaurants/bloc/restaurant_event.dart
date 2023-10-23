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

  GetRestaurantMenuListEvent(this.restaurantId, this.pickUp);
}
