import 'package:gymeats_mobile/screen/grocery/modal/create_order_request_model.dart';

class CreateOrderModel {
  String? userId;
  UserAddress? userAddress;
  bool? pickup;
  List<CreateOrderMealmeItems>? mealmeItems;
  int? driverTipCents;
  int? pickupTipCents;
  String? userDropoffNotes;
  int? userPhone;
  Map<String, dynamic>? extendedAddress;

  String? productType;
  double? totalAmount;
  double? subtotal;
  double? deliveryFee;
  double? taxesOtherFee;
  OrderStoreModel? store;
  CreateOrderModel({
    this.userId,
    this.userAddress,
    this.pickup,
    this.mealmeItems,
    this.driverTipCents,
    this.pickupTipCents,
    this.userDropoffNotes,
    this.userPhone,
    this.extendedAddress,
    this.productType,
    this.totalAmount,
    this.subtotal,
    this.deliveryFee,
    this.taxesOtherFee,
    this.store,
  });

  CreateOrderModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userAddress = json['userAddress'] != null
        ? UserAddress.fromJson(json['userAddress'])
        : null;
    pickup = json['pickup'];
    driverTipCents = json['driver_tip_cents'];
    pickupTipCents = json['pickup_tip_cents'];
    userDropoffNotes = json['user_dropoff_notes'];
    userPhone = json['user_phone'];

    productType = json['productType'];
    totalAmount = (json['totalAmount'] ?? 0).toDouble();
    subtotal = (json['subtotal'] ?? 0).toDouble();
    deliveryFee = (json['deliveryFee'] ?? 0).toDouble();
    taxesOtherFee = (json['taxesOtherFee'] ?? 0).toDouble();

    store = json['store'] != null ? OrderStoreModel.fromJson(json['store']) : null;

    if (json['mealmeItems'] != null) {
      mealmeItems = <CreateOrderMealmeItems>[];
      json['mealmeItems'].forEach((v) {
        mealmeItems!.add(CreateOrderMealmeItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "productType": productType ?? "default",
      "totalAmount": totalAmount ?? 0,
      "subtotal": subtotal ?? 0,
      "deliveryFee": deliveryFee ?? 0,
      "taxesOtherFee": taxesOtherFee ?? 0,
      "isPickUp": pickup ?? false,
      "store": store?.toJson() ?? {},
      "items": mealmeItems?.map((v) => v.toJson()).toList() ?? [],

      'userId': userId,
      'pickup': pickup,
      'Items': mealmeItems?.map((v) => v.toJson()).toList(),
      'driver_tip_cents': driverTipCents,
      'pickup_tip_cents': pickupTipCents,
      'user_dropoff_notes': userDropoffNotes,
      'user_phone': userPhone,
    };
  }
}

class OrderStoreModel {
  final String? storeId;
  final String? storeName;
  final String? storeLogo;

  OrderStoreModel({
    this.storeId,
    this.storeName,
    this.storeLogo,
  });

  factory OrderStoreModel.fromJson(Map<String, dynamic> json) {
    return OrderStoreModel(
      storeId: json['storeId'],
      storeName: json['storeName'],
      storeLogo: json['storeLogo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "storeId": storeId ?? '',
      "storeName": storeName ?? '',
      "storeLogo": storeLogo ?? '',
    };
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
  String? name;
  String? image;
  Map<String, dynamic>? store;

  CreateOrderMealmeItems({
    this.productId,
    this.notes,
    this.quantity,
    this.productMarkedPrice,
    this.selectedOptions,
    this.productType,
    this.name,
    this.image,
    this.store,
  });

  CreateOrderMealmeItems.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    notes = json['notes'];
    quantity = json['quantity'];
    productMarkedPrice = json['product_marked_price'];
    productType = json['productType'];
    name = json['name'];
    image = json['image'];

    if (json['SelectedOptions'] != null) {
      selectedOptions = <SelectedOptions>[];
      json['SelectedOptions'].forEach((v) {
        selectedOptions!.add(SelectedOptions.fromJson(v));
      });
    } else {
      selectedOptions = <SelectedOptions>[];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'notes': notes,
      'quantity': quantity,
      'product_marked_price': productMarkedPrice,
      'SelectedOptions': selectedOptions?.map((v) => v.toJson()).toList() ?? [],
      'productType': productType,
      'name': name,
      'image': image,

      'name': name ?? '',
      'basePrice': productMarkedPrice ?? 0,
      'quantity': quantity ?? 1,
      'image': image ?? '',
      'selectedOptions': selectedOptions?.map((v) => v.toJson()).toList() ?? [],
    };
  }
}