// To parse this JSON data, do
//
//     final getOrderDetails = getOrderDetailsFromJson(jsonString);

import 'dart:convert';

GetOrderDetails getOrderDetailsFromJson(String str) =>
    GetOrderDetails.fromJson(json.decode(str));

String getOrderDetailsToJson(GetOrderDetails data) =>
    json.encode(data.toJson());

class GetOrderDetails {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  OrderData? data;

  GetOrderDetails({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetOrderDetails.fromJson(Map<String, dynamic> json) =>
      GetOrderDetails(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: OrderData.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class OrderData {
  String? userId;
  String? orderId;
  String? productId;
  String? productName;
  int? quantity;
  int? price;
  String? type;
  String? purchaseDate;
  double? generatedProfit;
  dynamic partnerGeneratedProfit;
  double? deliveryFee;
  double? serviceFee;
  double? serviceTaxFee;
  int? deliveryTimeMin;
  int? deliveryTimeMax;
  String? trackLink;
  dynamic optionId;
  bool? isPickUp;
  dynamic pickUpTime;
  dynamic expectedTimeOfArrival;
  dynamic storeId;
  String? storeName;
  dynamic storeLogo;
  dynamic storeAddress;
  List<OrderedItems>? orderedItems;

  OrderData({
    this.userId,
    this.orderId,
    this.productId,
    this.productName,
    this.quantity,
    this.price,
    this.type,
    this.purchaseDate,
    this.generatedProfit,
    this.partnerGeneratedProfit,
    this.deliveryFee,
    this.serviceFee,
    this.serviceTaxFee,
    this.deliveryTimeMin,
    this.deliveryTimeMax,
    this.trackLink,
    this.optionId,
    this.isPickUp,
    this.pickUpTime,
    this.expectedTimeOfArrival,
    this.storeId,
    this.storeName,
    this.storeLogo,
    this.storeAddress,
    this.orderedItems,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        userId: json["userId"],
        orderId: json["orderId"],
        productId: json["productId"],
        productName: json["productName"],
        quantity: json["quantity"],
        price: json["price"],
        type: json["type"],
        purchaseDate: json["purchaseDate"],
        generatedProfit: json["generatedProfit"]?.toDouble(),
        partnerGeneratedProfit: json["partnerGeneratedProfit"],
        deliveryFee: json["deliveryFee"]?.toDouble(),
        serviceFee: json["serviceFee"]?.toDouble(),
        serviceTaxFee: json["serviceTaxFee"]?.toDouble(),
        deliveryTimeMin: json["deliveryTimeMin"],
        deliveryTimeMax: json["deliveryTimeMax"],
        trackLink: json["trackLink"],
        optionId: json["optionId"],
        isPickUp: json["isPickUp"],
        pickUpTime: json["pickUpTime"],
        expectedTimeOfArrival: json["expectedTimeOfArrival"],
        storeId: json["storeId"],
        storeName: json["storeName"],
        storeLogo: json["storeLogo"],
        storeAddress: json["storeAddress"],
        orderedItems: List<OrderedItems>.from(
            json["orderedItems"].map((x) => OrderedItems.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "orderId": orderId,
        "productId": productId,
        "productName": productName,
        "quantity": quantity,
        "price": price,
        "type": type,
        "purchaseDate": purchaseDate,
        "generatedProfit": generatedProfit,
        "partnerGeneratedProfit": partnerGeneratedProfit,
        "deliveryFee": deliveryFee,
        "serviceFee": serviceFee,
        "serviceTaxFee": serviceTaxFee,
        "deliveryTimeMin": deliveryTimeMin,
        "deliveryTimeMax": deliveryTimeMax,
        "trackLink": trackLink,
        "optionId": optionId,
        "isPickUp": isPickUp,
        "pickUpTime": pickUpTime,
        "expectedTimeOfArrival": expectedTimeOfArrival,
        "storeId": storeId,
        "storeName": storeName,
        "storeLogo": storeLogo,
        "storeAddress": storeAddress,
        "orderedItems":
            List<dynamic>.from(orderedItems?.map((x) => x.toJson()) ?? []),
      };
}

class OrderedItems {
  String? productId;
  String? productName;
  int? quantity;
  int? price;
  List<Option>? options;

  OrderedItems({
    this.productId,
    this.productName,
    this.quantity,
    this.price,
    this.options,
  });

  factory OrderedItems.fromJson(Map<String, dynamic> json) => OrderedItems(
        productId: json["productId"],
        productName: json["productName"],
        quantity: json["quantity"],
        price: json["price"],
        options:
            List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "quantity": quantity,
        "price": price,
        "options": List<dynamic>.from(options?.map((x) => x.toJson()) ?? []),
      };
}

class Option {
  String? optionId;
  String? optionName;
  int? optionPrice;
  int? quantity;

  Option({
    this.optionId,
    this.optionName,
    this.optionPrice,
    this.quantity,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        optionId: json["optionId"],
        optionName: json["optionName"],
        optionPrice: json["optionPrice"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "optionId": optionId,
        "optionName": optionName,
        "optionPrice": optionPrice,
        "quantity": quantity,
      };
}
