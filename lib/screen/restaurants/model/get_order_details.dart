// To parse this JSON data, do
//
//     final getOrderDetails = getOrderDetailsFromJson(jsonString);

import 'dart:convert';

GetOrderDetails getOrderDetailsFromJson(String str) => GetOrderDetails.fromJson(json.decode(str));

String getOrderDetailsToJson(GetOrderDetails data) => json.encode(data.toJson());

class GetOrderDetails {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  List<OrderData>? data;

  GetOrderDetails({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetOrderDetails.fromJson(Map<String, dynamic> json) => GetOrderDetails(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null ? [] : List<OrderData>.from(json["data"]!.map((x) => OrderData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
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
      };
}
