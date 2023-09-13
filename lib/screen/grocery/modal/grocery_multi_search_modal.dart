// To parse this JSON data, do
//
//     final groceryMultiSearchModel = groceryMultiSearchModelFromJson(jsonString);

import 'dart:convert';

GroceryMultiSearchModel groceryMultiSearchModelFromJson(String str) => GroceryMultiSearchModel.fromJson(json.decode(str));

String groceryMultiSearchModelToJson(GroceryMultiSearchModel data) => json.encode(data.toJson());

class GroceryMultiSearchModel {
  final bool? success;
  final dynamic message;
  final dynamic errorMessage;
  final Data? data;

  GroceryMultiSearchModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GroceryMultiSearchModel.fromJson(Map<String, dynamic> json) => GroceryMultiSearchModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class Data {
  final List<Cart>? carts;

  Data({
    this.carts,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        carts: json["carts"] == null ? [] : List<Cart>.from(json["carts"]!.map((x) => Cart.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "carts": carts == null ? [] : List<dynamic>.from(carts!.map((x) => x.toJson())),
      };
}

class Cart {
  final List<GroceryResult>? groceryResult;
  final String? menuId;
  final int? grandTotal;
  final Store? store;

  Cart({
    this.groceryResult,
    this.menuId,
    this.grandTotal,
    this.store,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        groceryResult: json["groceryResult"] == null ? [] : List<GroceryResult>.from(json["groceryResult"]!.map((x) => GroceryResult.fromJson(x))),
        menuId: json["menu_id"],
        grandTotal: json["grand_total"],
        store: json["store"] == null ? null : Store.fromJson(json["store"]),
      );

  Map<String, dynamic> toJson() => {
        "groceryResult": groceryResult == null ? [] : List<dynamic>.from(groceryResult!.map((x) => x.toJson())),
        "menu_id": menuId,
        "grand_total": grandTotal,
        "store": store?.toJson(),
      };
}

class GroceryResult {
  final String? searchedItemName;
  final List<Product>? products;

  GroceryResult({
    this.searchedItemName,
    this.products,
  });

  factory GroceryResult.fromJson(Map<String, dynamic> json) => GroceryResult(
        searchedItemName: json["searchedItemName"],
        products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "searchedItemName": searchedItemName,
        "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class Product {
  final String? productId;
  final String? itemName;
  final String? image;
  final String? description;
  final String? category;
  final int? price;
  final String? formattedPrice;
  final int? originalPrice;
  final List<dynamic>? upcCodes;
  final double? unitSize;
  final String? unitOfMeasurement;
  final List<String>? attributes;
  final bool? shouldFetchCustomizations;
  final dynamic menuId;
  final int? grandTotal;
  final dynamic store;
  final dynamic calorie;
  final dynamic protein;
  final dynamic fat;
  final dynamic carbs;
  final dynamic mealType;
  final dynamic day;
  final dynamic eatableType;
  bool isAdded;
  int cartItemCount;

  Product({
    this.productId,
    this.itemName,
    this.image,
    this.description,
    this.category,
    this.price,
    this.formattedPrice,
    this.originalPrice,
    this.upcCodes,
    this.unitSize,
    this.unitOfMeasurement,
    this.attributes,
    this.shouldFetchCustomizations,
    this.menuId,
    this.grandTotal,
    this.store,
    this.calorie,
    this.protein,
    this.fat,
    this.carbs,
    this.mealType,
    this.day,
    this.eatableType,
    this.isAdded = false,
    this.cartItemCount = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["product_id"],
        itemName: json["item_name"],
        image: json["image"],
        description: json["description"],
        category: json["category"],
        price: json["price"],
        formattedPrice: json["formatted_price"],
        originalPrice: json["original_price"],
        upcCodes: json["upc_codes"] == null ? [] : List<dynamic>.from(json["upc_codes"]!.map((x) => x)),
        unitSize: json["unit_size"]?.toDouble(),
        unitOfMeasurement: json["unit_of_measurement"],
        attributes: json["attributes"] == null ? [] : List<String>.from(json["attributes"]!.map((x) => x)),
        shouldFetchCustomizations: json["should_fetch_customizations"],
        menuId: json["menu_id"],
        grandTotal: json["grand_total"],
        store: json["store"],
        calorie: json["calorie"],
        protein: json["protein"],
        fat: json["fat"],
        carbs: json["carbs"],
        mealType: json["mealType"],
        day: json["day"],
        eatableType: json["eatableType"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "item_name": itemName,
        "image": image,
        "description": description,
        "category": category,
        "price": price,
        "formatted_price": formattedPrice,
        "original_price": originalPrice,
        "upc_codes": upcCodes == null ? [] : List<dynamic>.from(upcCodes!.map((x) => x)),
        "unit_size": unitSize,
        "unit_of_measurement": unitOfMeasurement,
        "attributes": attributes == null ? [] : List<dynamic>.from(attributes!.map((x) => x)),
        "should_fetch_customizations": shouldFetchCustomizations,
        "menu_id": menuId,
        "grand_total": grandTotal,
        "store": store,
        "calorie": calorie,
        "protein": protein,
        "fat": fat,
        "carbs": carbs,
        "mealType": mealType,
        "day": day,
        "eatableType": eatableType,
      };
}

class Store {
  final String? id;
  final String? name;
  final dynamic phoneNumber;
  final Address? address;
  final String? type;
  final String? description;
  final LocalHours? localHours;
  final int? dollarSigns;
  final bool? pickupEnabled;
  final bool? deliveryEnabled;
  final bool? isOpen;
  final List<String>? logoPhotos;
  final bool? offersFirstPartyDelivery;
  final bool? offersThirdPartyDelivery;
  final double? miles;
  final double? weightedRatingValue;
  final int? aggregatedRatingCount;
  bool isSelected;

  Store({
    this.id,
    this.name,
    this.phoneNumber,
    this.address,
    this.type,
    this.description,
    this.localHours,
    this.dollarSigns,
    this.pickupEnabled,
    this.deliveryEnabled,
    this.isOpen,
    this.logoPhotos,
    this.offersFirstPartyDelivery,
    this.offersThirdPartyDelivery,
    this.miles,
    this.weightedRatingValue,
    this.aggregatedRatingCount,
    this.isSelected = false,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json["_id"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        address: json["address"] == null ? null : Address.fromJson(json["address"]),
        type: json["type"],
        description: json["description"],
        localHours: json["local_hours"] == null ? null : LocalHours.fromJson(json["local_hours"]),
        dollarSigns: json["dollar_signs"],
        pickupEnabled: json["pickup_enabled"],
        deliveryEnabled: json["delivery_enabled"],
        isOpen: json["is_open"],
        logoPhotos: json["logo_photos"] == null ? [] : List<String>.from(json["logo_photos"]!.map((x) => x)),
        offersFirstPartyDelivery: json["offers_first_party_delivery"],
        offersThirdPartyDelivery: json["offers_third_party_delivery"],
        miles: json["miles"]?.toDouble(),
        weightedRatingValue: json["weighted_rating_value"]?.toDouble(),
        aggregatedRatingCount: json["aggregated_rating_count"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "phone_number": phoneNumber,
        "address": address?.toJson(),
        "type": type,
        "description": description,
        "local_hours": localHours?.toJson(),
        "dollar_signs": dollarSigns,
        "pickup_enabled": pickupEnabled,
        "delivery_enabled": deliveryEnabled,
        "is_open": isOpen,
        "logo_photos": logoPhotos == null ? [] : List<dynamic>.from(logoPhotos!.map((x) => x)),
        "offers_first_party_delivery": offersFirstPartyDelivery,
        "offers_third_party_delivery": offersThirdPartyDelivery,
        "miles": miles,
        "weighted_rating_value": weightedRatingValue,
        "aggregated_rating_count": aggregatedRatingCount,
      };
}

class Address {
  final String? streetAddr;
  final String? city;
  final String? state;
  final String? zipcode;
  final String? country;
  final String? streetAddr2;
  final double? latitude;
  final double? longitude;

  Address({
    this.streetAddr,
    this.city,
    this.state,
    this.zipcode,
    this.country,
    this.streetAddr2,
    this.latitude,
    this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        streetAddr: json["street_addr"],
        city: json["city"],
        state: json["state"],
        zipcode: json["zipcode"],
        country: json["country"],
        streetAddr2: json["street_addr_2"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "street_addr": streetAddr,
        "city": city,
        "state": state,
        "zipcode": zipcode,
        "country": country,
        "street_addr_2": streetAddr2,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class LocalHours {
  final Delivery? operational;
  final Delivery? delivery;
  final Delivery? pickup;
  final Delivery? dineIn;

  LocalHours({
    this.operational,
    this.delivery,
    this.pickup,
    this.dineIn,
  });

  factory LocalHours.fromJson(Map<String, dynamic> json) => LocalHours(
        operational: json["operational"] == null ? null : Delivery.fromJson(json["operational"]),
        delivery: json["delivery"] == null ? null : Delivery.fromJson(json["delivery"]),
        pickup: json["pickup"] == null ? null : Delivery.fromJson(json["pickup"]),
        dineIn: json["dine_in"] == null ? null : Delivery.fromJson(json["dine_in"]),
      );

  Map<String, dynamic> toJson() => {
        "operational": operational?.toJson(),
        "delivery": delivery?.toJson(),
        "pickup": pickup?.toJson(),
        "dine_in": dineIn?.toJson(),
      };
}

class Delivery {
  final String? monday;
  final String? tuesday;
  final String? wednesday;
  final String? thursday;
  final String? friday;
  final String? saturday;
  final String? sunday;

  Delivery({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        monday: json["monday"],
        tuesday: json["tuesday"],
        wednesday: json["wednesday"],
        thursday: json["thursday"],
        friday: json["friday"],
        saturday: json["saturday"],
        sunday: json["sunday"],
      );

  Map<String, dynamic> toJson() => {
        "monday": monday,
        "tuesday": tuesday,
        "wednesday": wednesday,
        "thursday": thursday,
        "friday": friday,
        "saturday": saturday,
        "sunday": sunday,
      };
}
