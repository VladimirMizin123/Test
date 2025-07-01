class CreateGroceryOrderModel {
  String? userId;
  UserAddress? userAddress;
  bool? pickup;
  List<CreateOrderGroceryItems>? groceryItems;
  int? driverTipCents;
  int? pickupTipCents;
  String? userDropoffNotes;
  int? userPhone;
  Map<String, dynamic>? extendedAddress;

  CreateGroceryOrderModel({
    this.userId,
    this.userAddress,
    this.pickup,
    this.groceryItems,
    this.driverTipCents,
    this.pickupTipCents,
    this.userDropoffNotes,
    this.userPhone,
    this.extendedAddress,
  });

  CreateGroceryOrderModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userAddress = json['userAddress'] != null
        ? UserAddress.fromJson(json['userAddress'])
        : null;
    pickup = json['pickup'];
    if (json['mealmeItems'] != null) {
      groceryItems = <CreateOrderGroceryItems>[];
      json['mealmeItems'].forEach((v) {
        groceryItems!.add(CreateOrderGroceryItems.fromJson(v));
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
    // data['userAddress'] = userAddress?.toJson();
    data['pickup'] = pickup;
    if (groceryItems != null) {
      data['mealmeItems'] = groceryItems!.map((v) => v.toJson()).toList();
    }
    data['driver_tip_cents'] = driverTipCents;
    data['pickup_tip_cents'] = pickupTipCents;
    data['user_dropoff_notes'] = userDropoffNotes;
    data['user_phone'] = userPhone;
    // data["extendedAddress"] = extendedAddress;
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
    if (streetNum != null) {
      data['street_Num'] = streetNum;
    }

    if (streetName != null) {
      data['street_Name'] = streetName;
    }

    if (city != null) {
      data['city'] = city;
    }

    if (state != null) {
      data['state'] = state;
    }
    if (country != null) {
      data['country'] = country;
    }
    if (zipcode != null) {
      data['zipcode'] = zipcode;
    }

    return data;
  }
}

class CreateOrderGroceryItems {
  String? productId;
  String? notes;
  int? quantity;
  dynamic productMarkedPrice;
  List<SelectedOptions>? selectedOptions;
  int? productType;
  String? storeId;

  CreateOrderGroceryItems({
    this.productId,
    this.notes,
    this.quantity,
    this.productMarkedPrice,
    this.selectedOptions,
    this.productType,
    this.storeId,
  });

  CreateOrderGroceryItems.fromJson(Map<String, dynamic> json) {
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
    storeId = json["store_id"];
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
    data['store_id'] = storeId;
    return data;
  }
}

class SelectedOptions {
  String? optionId;
  int? quantity;
  int? markedPrice;

  String? optionName;

  SelectedOptions({
    this.optionId,
    this.quantity,
    this.markedPrice,
    this.optionName,
  });

  SelectedOptions.fromJson(Map<String, dynamic> json) {
    optionId = json['option_id'];
    quantity = json['quantity'];
    markedPrice = json['marked_price'];

    optionName = json['optionName'];
  }

  Map<String, dynamic> toJson() {
    return {
      'option_id': optionId,
      'quantity': quantity,
      'marked_price': markedPrice,

      'optionName': optionName ?? '',
      'optionId': optionId ?? '',
      'optionPrice': markedPrice ?? 0,
    };
  }
}
