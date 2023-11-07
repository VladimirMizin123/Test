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
  List<OrderData>? data;

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
        data: json["data"] == null
            ? []
            : List<OrderData>.from(
                json["data"]!.map((x) => OrderData.fromJson(x))),
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

class OrderData {
  String? id;
  String? productId;
  String? productName;
  int? quantity;
  int? price;
  String? type;
  String? purchaseDate;
  double? generatedProfit;
  dynamic partnerGeneratedProfit;
  String? orderId;
  String? userId;
  String? trackLink;
  int? deliveryTimeMin;
  int? deliveryTimeMax;
  String? storeName;
  dynamic storeLogo;

  OrderData({
    this.id,
    this.productId,
    this.productName,
    this.quantity,
    this.price,
    this.type,
    this.purchaseDate,
    this.generatedProfit,
    this.partnerGeneratedProfit,
    this.orderId,
    this.userId,
    this.trackLink,
    this.deliveryTimeMin,
    this.deliveryTimeMax,
    this.storeName,
    this.storeLogo,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        id: json["id"],
        productId: json["productId"],
        productName: json["productName"],
        quantity: json["quantity"],
        price: json["price"],
        type: json["type"],
        purchaseDate: json["purchaseDate"],
        generatedProfit: json["generatedProfit"]?.toDouble(),
        partnerGeneratedProfit: json["partnerGeneratedProfit"],
        orderId: json["orderId"],
        userId: json["userId"],
        trackLink: json["trackLink"],
        deliveryTimeMin: json["deliveryTimeMin"],
        deliveryTimeMax: json["deliveryTimeMax"],
        storeName: json["storeName"],
        storeLogo: json["storeLogo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "productName": productName,
        "quantity": quantity,
        "price": price,
        "type": type,
        "purchaseDate": purchaseDate,
        "generatedProfit": generatedProfit,
        "partnerGeneratedProfit": partnerGeneratedProfit,
        "orderId": orderId,
        "userId": userId,
        "trackLink": trackLink,
        "deliveryTimeMin": deliveryTimeMin,
        "deliveryTimeMax": deliveryTimeMax,
        "storeName": storeName,
        "storeLogo": storeLogo,
      };
}
