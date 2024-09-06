// To parse this JSON data, do
//
//     final getRestaurantListModel = getRestaurantListModelFromJson(jsonString);

import 'dart:convert';

GetRestaurantListModel getRestaurantListModelFromJson(String str) =>
    GetRestaurantListModel.fromJson(json.decode(str));

String getRestaurantListModelToJson(GetRestaurantListModel data) =>
    json.encode(data.toJson());

class GetRestaurantListModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  List<RestaurantList>? data;

  GetRestaurantListModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetRestaurantListModel.fromJson(Map<String, dynamic> json) =>
      GetRestaurantListModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null
            ? []
            : List<RestaurantList>.from(
                json["data"]!.map((x) => RestaurantList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

List<RestaurantList> restaurantListFromJson(String str) =>
    List<RestaurantList>.from(
        json.decode(str)?.map((x) => RestaurantList.fromJson(x ?? {})) ?? []);

class RestaurantList {
  String? id;
  String? name;
  int? phoneNumber;
  Address? address;
  String? type;
  String? description;
  LocalHours? localHours;
  dynamic utcHours;
  List<String>? cuisines;
  List<String>? foodPhotos;
  List<String>? logoPhotos;
  List<String>? storePhotos;
  int? dollarSigns;
  bool? pickupEnabled;
  bool? deliveryEnabled;
  bool? isOpen;
  Quotes? quotes;
  bool? offersFirstPartyDelivery;
  bool? offersThirdPartyDelivery;
  double? miles;
  double? weightedRatingValue;
  int? aggregatedRatingCount;
  bool? supportsUpcCodes;

  RestaurantList({
    this.id,
    this.name,
    this.phoneNumber,
    this.address,
    this.type,
    this.description,
    this.localHours,
    this.utcHours,
    this.cuisines,
    this.foodPhotos,
    this.logoPhotos,
    this.storePhotos,
    this.dollarSigns,
    this.pickupEnabled,
    this.deliveryEnabled,
    this.isOpen,
    this.quotes,
    this.offersFirstPartyDelivery,
    this.offersThirdPartyDelivery,
    this.miles,
    this.weightedRatingValue,
    this.aggregatedRatingCount,
    this.supportsUpcCodes,
  });

  factory RestaurantList.fromJson(Map<String, dynamic> json) => RestaurantList(
        id: json["_id"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        type: json["type"],
        description: json["description"],
        localHours: json["local_hours"] == null
            ? null
            : LocalHours.fromJson(json["local_hours"]),
        utcHours: json["utc_hours"],
        cuisines: json["cuisines"] == null
            ? []
            : List<String>.from(json["cuisines"]!.map((x) => x)),
        foodPhotos: json["food_photos"] == null
            ? []
            : List<String>.from(json["food_photos"]!.map((x) => x)),
        logoPhotos: json["logo_photos"] == null
            ? []
            : List<String>.from(json["logo_photos"]!.map((x) => x)),
        storePhotos: json["store_photos"] == null
            ? []
            : List<String>.from(json["store_photos"]!.map((x) => x)),
        dollarSigns: json["dollar_signs"],
        pickupEnabled: json["pickup_enabled"],
        deliveryEnabled: json["delivery_enabled"],
        isOpen: json["is_open"],
        quotes: json["quotes"] == null ? null : Quotes.fromJson(json["quotes"]),
        offersFirstPartyDelivery: json["offers_first_party_delivery"],
        offersThirdPartyDelivery: json["offers_third_party_delivery"],
        miles: json["miles"]?.toDouble(),
        weightedRatingValue: json["weighted_rating_value"]?.toDouble(),
        aggregatedRatingCount: json["aggregated_rating_count"],
        supportsUpcCodes: json["supports_upc_codes"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "phone_number": phoneNumber,
        "address": address?.toJson(),
        "type": type,
        "description": description,
        "local_hours": localHours?.toJson(),
        "utc_hours": utcHours,
        "cuisines":
            cuisines == null ? [] : List<dynamic>.from(cuisines!.map((x) => x)),
        "food_photos": foodPhotos == null
            ? []
            : List<dynamic>.from(foodPhotos!.map((x) => x)),
        "logo_photos": logoPhotos == null
            ? []
            : List<dynamic>.from(logoPhotos!.map((x) => x)),
        "store_photos": storePhotos == null
            ? []
            : List<dynamic>.from(storePhotos!.map((x) => x)),
        "dollar_signs": dollarSigns,
        "pickup_enabled": pickupEnabled,
        "delivery_enabled": deliveryEnabled,
        "is_open": isOpen,
        "quotes": quotes?.toJson(),
        "offers_first_party_delivery": offersFirstPartyDelivery,
        "offers_third_party_delivery": offersThirdPartyDelivery,
        "miles": miles,
        "weighted_rating_value": weightedRatingValue,
        "aggregated_rating_count": aggregatedRatingCount,
        "supports_upc_codes": supportsUpcCodes,
      };
}

class Address {
  String? streetAddr;
  String? city;
  String? state;
  String? zipcode;
  String? country;
  String? streetAddr2;
  double? latitude;
  double? longitude;

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
        operational: json["operational"] == null
            ? null
            : Delivery.fromJson(json["operational"]),
        delivery: json["delivery"] == null
            ? null
            : Delivery.fromJson(json["delivery"]),
        pickup:
            json["pickup"] == null ? null : Delivery.fromJson(json["pickup"]),
        dineIn:
            json["dine_in"] == null ? null : Delivery.fromJson(json["dine_in"]),
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

class Quotes {
  EstDelivery? cheapestDelivery;
  EstDelivery? fastestDelivery;

  Quotes({
    this.cheapestDelivery,
    this.fastestDelivery,
  });

  factory Quotes.fromJson(Map<String, dynamic> json) => Quotes(
        cheapestDelivery: json["cheapest_delivery"] == null
            ? null
            : EstDelivery.fromJson(json["cheapest_delivery"]),
        fastestDelivery: json["fastest_delivery"] == null
            ? null
            : EstDelivery.fromJson(json["fastest_delivery"]),
      );

  Map<String, dynamic> toJson() => {
        "cheapest_delivery": cheapestDelivery?.toJson(),
        "fastest_delivery": fastestDelivery?.toJson(),
      };
}

class EstDelivery {
  TimeEstimate? timeEstimate;
  double? salesTaxPercent;
  int? orderMinimum;
  DeliveryFee? deliveryFee;
  ServiceFee? serviceFee;
  SmallOrderFee? smallOrderFee;

  EstDelivery({
    this.timeEstimate,
    this.salesTaxPercent,
    this.orderMinimum,
    this.deliveryFee,
    this.serviceFee,
    this.smallOrderFee,
  });

  factory EstDelivery.fromJson(Map<String, dynamic> json) => EstDelivery(
        timeEstimate: json["time_estimate"] == null
            ? null
            : TimeEstimate.fromJson(json["time_estimate"]),
        salesTaxPercent: json["sales_tax_percent"]?.toDouble(),
        orderMinimum: json["order_minimum"],
        deliveryFee: json["delivery_fee"] == null
            ? null
            : DeliveryFee.fromJson(json["delivery_fee"]),
        serviceFee: json["service_fee"] == null
            ? null
            : ServiceFee.fromJson(json["service_fee"]),
        smallOrderFee: json["small_order_fee"] == null
            ? null
            : SmallOrderFee.fromJson(json["small_order_fee"]),
      );

  Map<String, dynamic> toJson() => {
        "time_estimate": timeEstimate?.toJson(),
        "sales_tax_percent": salesTaxPercent,
        "order_minimum": orderMinimum,
        "delivery_fee": deliveryFee?.toJson(),
        "service_fee": serviceFee?.toJson(),
        "small_order_fee": smallOrderFee?.toJson(),
      };
}

class DeliveryFee {
  int? deliveryFeeFlat;
  int? deliveryFeePercent;
  bool? deliveryFeeTaxable;
  List<dynamic>? thresholdFees;

  DeliveryFee({
    this.deliveryFeeFlat,
    this.deliveryFeePercent,
    this.deliveryFeeTaxable,
    this.thresholdFees,
  });

  factory DeliveryFee.fromJson(Map<String, dynamic> json) => DeliveryFee(
        deliveryFeeFlat: json["delivery_fee_flat"],
        deliveryFeePercent: json["delivery_fee_percent"],
        deliveryFeeTaxable: json["delivery_fee_taxable"],
        thresholdFees: json["threshold_fees"] == null
            ? []
            : List<dynamic>.from(json["threshold_fees"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "delivery_fee_flat": deliveryFeeFlat,
        "delivery_fee_percent": deliveryFeePercent,
        "delivery_fee_taxable": deliveryFeeTaxable,
        "threshold_fees": thresholdFees == null
            ? []
            : List<dynamic>.from(thresholdFees!.map((x) => x)),
      };
}

class ServiceFee {
  int? serviceFeeFlat;
  double? serviceFeePercent;
  int? serviceFeeMin;
  bool? serviceFeeTaxable;

  ServiceFee({
    this.serviceFeeFlat,
    this.serviceFeePercent,
    this.serviceFeeMin,
    this.serviceFeeTaxable,
  });

  factory ServiceFee.fromJson(Map<String, dynamic> json) => ServiceFee(
        serviceFeeFlat: json["service_fee_flat"],
        serviceFeePercent: json["service_fee_percent"]?.toDouble(),
        serviceFeeMin: json["service_fee_min"],
        serviceFeeTaxable: json["service_fee_taxable"],
      );

  Map<String, dynamic> toJson() => {
        "service_fee_flat": serviceFeeFlat,
        "service_fee_percent": serviceFeePercent,
        "service_fee_min": serviceFeeMin,
        "service_fee_taxable": serviceFeeTaxable,
      };
}

class SmallOrderFee {
  int? minimumOrderValue;
  int? smallOrderFeeFlat;
  int? smallOrderFeePercent;

  SmallOrderFee({
    this.minimumOrderValue,
    this.smallOrderFeeFlat,
    this.smallOrderFeePercent,
  });

  factory SmallOrderFee.fromJson(Map<String, dynamic> json) => SmallOrderFee(
        minimumOrderValue: json["minimum_order_value"],
        smallOrderFeeFlat: json["small_order_fee_flat"],
        smallOrderFeePercent: json["small_order_fee_percent"],
      );

  Map<String, dynamic> toJson() => {
        "minimum_order_value": minimumOrderValue,
        "small_order_fee_flat": smallOrderFeeFlat,
        "small_order_fee_percent": smallOrderFeePercent,
      };
}

class TimeEstimate {
  int? minimum;
  int? maximum;

  TimeEstimate({
    this.minimum,
    this.maximum,
  });

  factory TimeEstimate.fromJson(Map<String, dynamic> json) => TimeEstimate(
        minimum: json["minimum"],
        maximum: json["maximum"],
      );

  Map<String, dynamic> toJson() => {
        "minimum": minimum,
        "maximum": maximum,
      };
}
