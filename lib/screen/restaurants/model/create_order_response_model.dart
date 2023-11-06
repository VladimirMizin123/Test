// To parse this JSON data, do
//
//     final createOrderResponseModel = createOrderResponseModelFromJson(jsonString);

import 'dart:convert';

CreateOrderResponseModel createOrderResponseModelFromJson(String str) =>
    CreateOrderResponseModel.fromJson(json.decode(str));

String createOrderResponseModelToJson(CreateOrderResponseModel data) =>
    json.encode(data.toJson());

class CreateOrderResponseModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  CreateOrderData? data;

  CreateOrderResponseModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory CreateOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateOrderResponseModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null
            ? null
            : CreateOrderData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class CreateOrderData {
  bool? orderPlaced;
  FinalQuote? finalQuote;
  String? orderId;
  String? userId;
  int? totalPrice;
  int? phoneNumber;
  UserAddress? userAddress;

  CreateOrderData({
    this.orderPlaced,
    this.finalQuote,
    this.orderId,
    this.userId,
    this.totalPrice,
    this.phoneNumber,
    this.userAddress,
  });

  factory CreateOrderData.fromJson(Map<String, dynamic> json) =>
      CreateOrderData(
        orderPlaced: json["order_placed"],
        finalQuote: json["final_quote"] == null
            ? null
            : FinalQuote.fromJson(json["final_quote"]),
        orderId: json["order_id"],
        userId: json["user_id"],
        totalPrice: json["total_price"],
        phoneNumber: json["phoneNumber"],
        userAddress: json["userAddress"] == null
            ? null
            : UserAddress.fromJson(json["userAddress"]),
      );

  Map<String, dynamic> toJson() => {
        "order_placed": orderPlaced,
        "final_quote": finalQuote?.toJson(),
        "order_id": orderId,
        "user_id": userId,
        "total_price": totalPrice,
        "phoneNumber": phoneNumber,
        "userAddress": userAddress?.toJson(),
      };
}

class FinalQuote {
  String? store;
  String? storeAddress;
  String? storeId;
  String? quoteId;
  Quote? quote;
  List<Item>? items;
  int? tip;
  int? totalWithTip;
  AddedFees? addedFees;
  List<MiscFee>? miscFees;
  int? markedTotalWithTip;

  FinalQuote({
    this.store,
    this.storeAddress,
    this.storeId,
    this.quoteId,
    this.quote,
    this.items,
    this.tip,
    this.totalWithTip,
    this.addedFees,
    this.miscFees,
    this.markedTotalWithTip,
  });

  factory FinalQuote.fromJson(Map<String, dynamic> json) => FinalQuote(
        store: json["store"],
        storeAddress: json["store_address"],
        storeId: json["store_id"],
        quoteId: json["quote_id"],
        quote: json["quote"] == null ? null : Quote.fromJson(json["quote"]),
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        tip: json["tip"],
        totalWithTip: json["total_with_tip"],
        addedFees: json["added_fees"] == null
            ? null
            : AddedFees.fromJson(json["added_fees"]),
        miscFees: json["misc_fees"] == null
            ? []
            : List<MiscFee>.from(
                json["misc_fees"]!.map((x) => MiscFee.fromJson(x))),
        markedTotalWithTip: json["marked_total_with_tip"],
      );

  Map<String, dynamic> toJson() => {
        "store": store,
        "store_address": storeAddress,
        "store_id": storeId,
        "quote_id": quoteId,
        "quote": quote?.toJson(),
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "tip": tip,
        "total_with_tip": totalWithTip,
        "added_fees": addedFees?.toJson(),
        "misc_fees": miscFees == null
            ? []
            : List<dynamic>.from(miscFees!.map((x) => x.toJson())),
        "marked_total_with_tip": markedTotalWithTip,
      };
}

class AddedFees {
  int? flatFeeCents;
  int? percentFee;
  bool? isFeeTaxable;
  int? totalFeeCents;
  int? salesTaxCents;

  AddedFees({
    this.flatFeeCents,
    this.percentFee,
    this.isFeeTaxable,
    this.totalFeeCents,
    this.salesTaxCents,
  });

  factory AddedFees.fromJson(Map<String, dynamic> json) => AddedFees(
        flatFeeCents: json["flat_fee_cents"],
        percentFee: json["percent_fee"],
        isFeeTaxable: json["is_fee_taxable"],
        totalFeeCents: json["total_fee_cents"],
        salesTaxCents: json["sales_tax_cents"],
      );

  Map<String, dynamic> toJson() => {
        "flat_fee_cents": flatFeeCents,
        "percent_fee": percentFee,
        "is_fee_taxable": isFeeTaxable,
        "total_fee_cents": totalFeeCents,
        "sales_tax_cents": salesTaxCents,
      };
}

class Item {
  String? name;
  int? basePrice;
  int? quantity;
  String? image;
  int? markedPrice;
  String? productId;
  List<dynamic>? customizations;

  Item({
    this.name,
    this.basePrice,
    this.quantity,
    this.image,
    this.markedPrice,
    this.productId,
    this.customizations,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        name: json["name"],
        basePrice: json["base_price"],
        quantity: json["quantity"],
        image: json["image"],
        markedPrice: json["marked_price"],
        productId: json["product_id"],
        customizations: json["customizations"] == null
            ? []
            : List<dynamic>.from(json["customizations"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "base_price": basePrice,
        "quantity": quantity,
        "image": image,
        "marked_price": markedPrice,
        "product_id": productId,
        "customizations": customizations == null
            ? []
            : List<dynamic>.from(customizations!.map((x) => x)),
      };
}

class MiscFee {
  String? feeName;
  int? feeAmount;
  bool? unifyServiceFee;
  bool? unifyDeliveryFee;

  MiscFee({
    this.feeName,
    this.feeAmount,
    this.unifyServiceFee,
    this.unifyDeliveryFee,
  });

  factory MiscFee.fromJson(Map<String, dynamic> json) => MiscFee(
        feeName: json["fee_name"],
        feeAmount: json["fee_amount"],
        unifyServiceFee: json["unify_service_fee"],
        unifyDeliveryFee: json["unify_delivery_fee"],
      );

  Map<String, dynamic> toJson() => {
        "fee_name": feeName,
        "fee_amount": feeAmount,
        "unify_service_fee": unifyServiceFee,
        "unify_delivery_fee": unifyDeliveryFee,
      };
}

class Quote {
  int? subtotal;
  int? deliveryFeeCents;
  int? serviceFeeCents;
  int? smallOrderFeeCents;
  int? salesTaxCents;
  int? deliveryTimeMin;
  int? deliveryTimeMax;
  int? totalWithoutTips;
  String? expectedTimeOfArrival;
  Scheduled? scheduled;
  int? markedSubtotal;
  int? markedTotalWithoutTips;

  Quote({
    this.subtotal,
    this.deliveryFeeCents,
    this.serviceFeeCents,
    this.smallOrderFeeCents,
    this.salesTaxCents,
    this.deliveryTimeMin,
    this.deliveryTimeMax,
    this.totalWithoutTips,
    this.expectedTimeOfArrival,
    this.scheduled,
    this.markedSubtotal,
    this.markedTotalWithoutTips,
  });

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        subtotal: json["subtotal"],
        deliveryFeeCents: json["delivery_fee_cents"],
        serviceFeeCents: json["service_fee_cents"],
        smallOrderFeeCents: json["small_order_fee_cents"],
        salesTaxCents: json["sales_tax_cents"],
        deliveryTimeMin: json["delivery_time_min"],
        deliveryTimeMax: json["delivery_time_max"],
        totalWithoutTips: json["total_without_tips"],
        expectedTimeOfArrival: json["expected_time_of_arrival"],
        scheduled: json["scheduled"] == null
            ? null
            : Scheduled.fromJson(json["scheduled"]),
        markedSubtotal: json["marked_subtotal"],
        markedTotalWithoutTips: json["marked_total_without_tips"],
      );

  Map<String, dynamic> toJson() => {
        "subtotal": subtotal,
        "delivery_fee_cents": deliveryFeeCents,
        "service_fee_cents": serviceFeeCents,
        "small_order_fee_cents": smallOrderFeeCents,
        "sales_tax_cents": salesTaxCents,
        "delivery_time_min": deliveryTimeMin,
        "delivery_time_max": deliveryTimeMax,
        "total_without_tips": totalWithoutTips,
        "expected_time_of_arrival": expectedTimeOfArrival,
        "scheduled": scheduled?.toJson(),
        "marked_subtotal": markedSubtotal,
        "marked_total_without_tips": markedTotalWithoutTips,
      };
}

class Scheduled {
  Scheduled();

  factory Scheduled.fromJson(Map<String, dynamic> json) => Scheduled();

  Map<String, dynamic> toJson() => {};
}

class UserAddress {
  double? latitude;
  double? longitude;
  String? streetNum;
  String? streetName;
  String? city;
  String? state;
  String? country;
  String? zipcode;

  UserAddress({
    this.latitude,
    this.longitude,
    this.streetNum,
    this.streetName,
    this.city,
    this.state,
    this.country,
    this.zipcode,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        streetNum: json["street_Num"],
        streetName: json["street_Name"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        zipcode: json["zipcode"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "street_Num": streetNum,
        "street_Name": streetName,
        "city": city,
        "state": state,
        "country": country,
        "zipcode": zipcode,
      };
}
