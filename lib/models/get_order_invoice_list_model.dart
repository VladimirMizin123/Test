// To parse this JSON data, do
//
//     final getOrderInvoiceListModel = getOrderInvoiceListModelFromJson(jsonString);

import 'dart:convert';

GetOrderInvoiceListModel getOrderInvoiceListModelFromJson(String str) =>
    GetOrderInvoiceListModel.fromJson(json.decode(str));

String getOrderInvoiceListModelToJson(GetOrderInvoiceListModel data) =>
    json.encode(data.toJson());

class GetOrderInvoiceListModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  List<InvoiceList>? data;

  GetOrderInvoiceListModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetOrderInvoiceListModel.fromJson(Map<String, dynamic> json) =>
      GetOrderInvoiceListModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null
            ? []
            : List<InvoiceList>.from(
                json["data"]!.map((x) => InvoiceList.fromJson(x))),
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

class InvoiceList {
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

  InvoiceList({
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

  factory InvoiceList.fromJson(Map<String, dynamic> json) => InvoiceList(
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
