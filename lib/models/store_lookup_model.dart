import 'dart:convert';

StoreLookUpModel storeLookUpModelFromJson(String str) =>
    StoreLookUpModel.fromJson(json.decode(str));

String storeLookUpModelToJson(StoreLookUpModel data) =>
    json.encode(data.toJson());

class StoreLookUpModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  Data? data;

  StoreLookUpModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory StoreLookUpModel.fromJson(Map<String, dynamic> json) =>
      StoreLookUpModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class Data {
  Store? store;

  Data({
    this.store,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        store: json["store"] != null ? Store.fromJson(json["store"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "store": store?.toJson(),
      };
}

class Store {
  String? id;
  String? name;
  int? phoneNumber;
  Address? address;
  String? description;
  LocalHours? localHours;
  List<String>? cuisines;
  List<String>? foodPhotos;
  List<String>? logoPhotos;
  List<dynamic>? storePhotos;
  int? dollarSigns;
  bool? pickupEnabled;
  bool? deliveryEnabled;
  bool? offersFirstPartyDelivery;
  bool? offersThirdPartyDelivery;
  List<String>? quoteIds;
  num? weightedRatingValue;
  num? aggregatedRatingCount;
  bool? supportsUpcCodes;
  String? type;
  bool? isOpen;

  Store({
    this.id,
    this.name,
    this.phoneNumber,
    this.address,
    this.description,
    this.localHours,
    this.cuisines,
    this.foodPhotos,
    this.logoPhotos,
    this.storePhotos,
    this.dollarSigns,
    this.pickupEnabled,
    this.deliveryEnabled,
    this.offersFirstPartyDelivery,
    this.offersThirdPartyDelivery,
    this.quoteIds,
    this.weightedRatingValue,
    this.aggregatedRatingCount,
    this.supportsUpcCodes,
    this.type,
    this.isOpen,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json["_id"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        address:
            json["address"] != null ? Address.fromJson(json["address"]) : null,
        description: json["description"],
        localHours: json["local_hours"] != null
            ? LocalHours.fromJson(json["local_hours"])
            : null,
        cuisines: json["cuisines"] != null
            ? List<String>.from(json["cuisines"].map((x) => x))
            : [],
        foodPhotos: json["food_photos"] != null
            ? List<String>.from(json["food_photos"].map((x) => x))
            : [],
        logoPhotos: json["logo_photos"] != null
            ? List<String>.from(json["logo_photos"].map((x) => x))
            : [],
        storePhotos: json["store_photos"] != null
            ? List<dynamic>.from(json["store_photos"].map((x) => x))
            : [],
        dollarSigns: json["dollar_signs"],
        pickupEnabled: json["pickup_enabled"],
        deliveryEnabled: json["delivery_enabled"],
        offersFirstPartyDelivery: json["offers_first_party_delivery"],
        offersThirdPartyDelivery: json["offers_third_party_delivery"],
        quoteIds: json["quote_ids"] != null
            ? List<String>.from(json["quote_ids"].map((x) => x))
            : [],
        weightedRatingValue:
            num.tryParse(json["weighted_rating_value"]?.toString() ?? ""),
        aggregatedRatingCount:
            num.tryParse(json["aggregated_rating_count"]?.toString() ?? ""),
        supportsUpcCodes: json["supports_upc_codes"],
        type: json["type"],
        isOpen: json["is_open"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "phone_number": phoneNumber,
        "address": address?.toJson(),
        "description": description,
        "local_hours": localHours?.toJson(),
        "cuisines": List<dynamic>.from(cuisines?.map((x) => x) ?? []),
        "food_photos": List<dynamic>.from(foodPhotos?.map((x) => x) ?? []),
        "logo_photos": List<dynamic>.from(logoPhotos?.map((x) => x) ?? []),
        "store_photos": List<dynamic>.from(storePhotos?.map((x) => x) ?? []),
        "dollar_signs": dollarSigns,
        "pickup_enabled": pickupEnabled,
        "delivery_enabled": deliveryEnabled,
        "offers_first_party_delivery": offersFirstPartyDelivery,
        "offers_third_party_delivery": offersThirdPartyDelivery,
        "quote_ids": List<dynamic>.from(quoteIds?.map((x) => x) ?? []),
        "weighted_rating_value": weightedRatingValue,
        "aggregated_rating_count": aggregatedRatingCount,
        "supports_upc_codes": supportsUpcCodes,
        "type": type,
        "is_open": isOpen,
      };
}

class Address {
  String? streetAddr;
  String? city;
  String? state;
  String? zipCode;
  String? country;
  String? streetAddr2;
  double? latitude;
  double? longitude;

  Address({
    this.streetAddr,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.streetAddr2,
    this.latitude,
    this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        streetAddr: json["street_addr"],
        city: json["city"],
        state: json["state"],
        zipCode: json["zipCode"],
        country: json["country"],
        streetAddr2: json["street_addr_2"],
        latitude: double.tryParse(json["latitude"]?.toString() ?? "0"),
        longitude: double.tryParse(json["longitude"]?.toString() ?? "0"),
      );

  Map<String, dynamic> toJson() => {
        "street_addr": streetAddr,
        "city": city,
        "state": state,
        "zipCode": zipCode,
        "country": country,
        "street_addr_2": streetAddr2,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class LocalHours {
  Delivery? operational;
  Delivery? delivery;
  Delivery? pickup;
  Delivery? dineIn;

  LocalHours({
    this.operational,
    this.delivery,
    this.pickup,
    this.dineIn,
  });

  factory LocalHours.fromJson(Map<String, dynamic> json) => LocalHours(
        operational: json["operational"] != null
            ? Delivery.fromJson(json["operational"])
            : null,
        delivery: json["delivery"] != null
            ? Delivery.fromJson(json["delivery"])
            : null,
        pickup:
            json["pickup"] != null ? Delivery.fromJson(json["pickup"]) : null,
        dineIn:
            json["dine_in"] != null ? Delivery.fromJson(json["dine_in"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "operational": operational?.toJson(),
        "delivery": delivery?.toJson(),
        "pickup": pickup?.toJson(),
        "dine_in": dineIn?.toJson(),
      };
}

class Delivery {
  String? monday;
  String? tuesday;
  String? wednesday;
  String? thursday;
  String? friday;
  String? saturday;
  String? sunday;

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
