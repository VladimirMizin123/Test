class CreateOrderModel {
  String? userId;
  UserAddress? userAddress;
  bool? pickup;
  List<CreateOrderMealmeItems>? mealmeItems;
  int? driverTipCents;
  int? pickupTipCents;
  String? userDropoffNotes;
  int? userPhone;

  CreateOrderModel(
      {this.userId,
      this.userAddress,
      this.pickup,
      this.mealmeItems,
      this.driverTipCents,
      this.pickupTipCents,
      this.userDropoffNotes,
      this.userPhone});

  CreateOrderModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userAddress = json['userAddress'] != null
        ? UserAddress.fromJson(json['userAddress'])
        : null;
    pickup = json['pickup'];
    if (json['mealmeItems'] != null) {
      mealmeItems = <CreateOrderMealmeItems>[];
      json['mealmeItems'].forEach((v) {
        mealmeItems!.add(CreateOrderMealmeItems.fromJson(v));
      });
    }
    driverTipCents = json['driver_tip_cents'];
    pickupTipCents = json['pickup_tip_cents'];
    userDropoffNotes = json['user_dropoff_notes'];
    userPhone = json['user_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    if (userAddress != null) {
      data['userAddress'] = userAddress!.toJson();
    }
    data['pickup'] = pickup;
    if (mealmeItems != null) {
      data['mealmeItems'] = mealmeItems!.map((v) => v.toJson()).toList();
    }
    data['driver_tip_cents'] = driverTipCents;
    data['pickup_tip_cents'] = pickupTipCents;
    data['user_dropoff_notes'] = userDropoffNotes;
    data['user_phone'] = userPhone;
    return data;
  }
}

class UserAddress {
  dynamic latitude;
  dynamic longitude;
  String? streetNum;
  String? streetName;
  String? city;
  String? state;
  String? country;
  String? zipcode;

  UserAddress(
      {this.latitude,
      this.longitude,
      this.streetNum,
      this.streetName,
      this.city,
      this.state,
      this.country,
      this.zipcode});

  UserAddress.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    streetNum = json['street_Num'];
    streetName = json['street_Name'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    zipcode = json['zipcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['street_Num'] = streetNum;
    data['street_Name'] = streetName;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['zipcode'] = zipcode;
    return data;
  }
}

class CreateOrderMealmeItems {
  String? productId;
  String? notes;
  int? quantity;
  dynamic productMarkedPrice;
  List<SelectedOptions>? selectedOptions;
  int? productType;

  CreateOrderMealmeItems(
      {this.productId,
      this.notes,
      this.quantity,
      this.productMarkedPrice,
      this.selectedOptions,
      this.productType});

  CreateOrderMealmeItems.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    notes = json['notes'];
    quantity = json['quantity'];
    productMarkedPrice = json['product_marked_price'];
    if (json['selected_options'] != null) {
      selectedOptions = <SelectedOptions>[];
      json['selected_options'].forEach((v) {
        selectedOptions!.add(SelectedOptions.fromJson(v));
      });
    }
    productType = json['productType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['notes'] = notes;
    data['quantity'] = quantity;
    data['product_marked_price'] = productMarkedPrice;
    if (selectedOptions != null) {
      data['selected_options'] =
          selectedOptions!.map((v) => v.toJson()).toList();
    }
    data['productType'] = productType;
    return data;
  }
}

class SelectedOptions {
  String? optionId;
  int? quantity;
  int? markedPrice;

  SelectedOptions({this.optionId, this.quantity, this.markedPrice});

  SelectedOptions.fromJson(Map<String, dynamic> json) {
    optionId = json['option_id'];
    quantity = json['quantity'];
    markedPrice = json['marked_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['option_id'] = optionId;
    data['quantity'] = quantity;
    data['marked_price'] = markedPrice;
    return data;
  }
}
