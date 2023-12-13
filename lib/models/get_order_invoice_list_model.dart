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
  Data? data;

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
  String? userId;
  List<OrderedItem>? orderedItems;

  Data({
    this.userId,
    this.orderedItems,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["userId"],
        orderedItems: json["orderedItems"] == null
            ? []
            : List<OrderedItem>.from(
                json["orderedItems"]!.map((x) => OrderedItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "orderedItems": orderedItems == null
            ? []
            : List<dynamic>.from(orderedItems!.map((x) => x.toJson())),
      };
}

class OrderedItem {
  String? orderId;
  String? trackLink;
  List<Item>? items;

  OrderedItem({
    this.orderId,
    this.trackLink,
    this.items,
  });

  factory OrderedItem.fromJson(Map<String, dynamic> json) => OrderedItem(
        orderId: json["orderId"],
        trackLink: json["trackLink"],
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "trackLink": trackLink,
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Item {
  String? productId;
  String? productName;
  int? quantity;
  int? price;
  String? type;
  DateTime? purchaseDate;
  double? generatedProfit;
  dynamic partnerGeneratedProfit;
  dynamic userId;
  int? deliveryTimeMin;
  int? deliveryTimeMax;
  String? optionId;
  bool? isPickUp;
  String? pickUpTime;
  String? expectedTimeOfArrival;
  String? orderStatus;
  Stores? stores;

  Item({
    this.productId,
    this.productName,
    this.quantity,
    this.price,
    this.type,
    this.purchaseDate,
    this.generatedProfit,
    this.partnerGeneratedProfit,
    this.userId,
    this.deliveryTimeMin,
    this.deliveryTimeMax,
    this.optionId,
    this.isPickUp,
    this.pickUpTime,
    this.expectedTimeOfArrival,
    this.orderStatus,
    this.stores,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        productId: json["productId"],
        productName: json["productName"],
        quantity: json["quantity"],
        price: json["price"],
        type: json["type"],
        purchaseDate: json["purchaseDate"] == null
            ? null
            : DateTime.parse(json["purchaseDate"]),
        generatedProfit: json["generatedProfit"]?.toDouble(),
        partnerGeneratedProfit: json["partnerGeneratedProfit"],
        userId: json["userId"],
        deliveryTimeMin: json["deliveryTimeMin"],
        deliveryTimeMax: json["deliveryTimeMax"],
        optionId: json["optionId"],
        isPickUp: json["isPickUp"],
        pickUpTime: json["pickUpTime"],
        expectedTimeOfArrival: json["expectedTimeOfArrival"],
        orderStatus: json["orderStatus"],
        stores: json["stores"] == null ? null : Stores.fromJson(json["stores"]),
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "quantity": quantity,
        "price": price,
        "type": type,
        "purchaseDate": purchaseDate?.toIso8601String(),
        "generatedProfit": generatedProfit,
        "partnerGeneratedProfit": partnerGeneratedProfit,
        "userId": userId,
        "deliveryTimeMin": deliveryTimeMin,
        "deliveryTimeMax": deliveryTimeMax,
        "optionId": optionId,
        "isPickUp": isPickUp,
        "pickUpTime": pickUpTime,
        "expectedTimeOfArrival": expectedTimeOfArrival,
        "orderStatus": orderStatus,
        "stores": stores?.toJson(),
      };
}

class Stores {
  String? id;
  String? orderInvoiceId;
  String? storeId;
  String? storeName;
  dynamic storeLogo;
  dynamic storeAddress;

  Stores({
    this.id,
    this.orderInvoiceId,
    this.storeId,
    this.storeName,
    this.storeLogo,
    this.storeAddress,
  });

  factory Stores.fromJson(Map<String, dynamic> json) => Stores(
        id: json["id"],
        orderInvoiceId: json["orderInvoiceId"],
        storeId: json["storeId"],
        storeName: json["storeName"],
        storeLogo: json["storeLogo"],
        storeAddress: json["storeAddress"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderInvoiceId": orderInvoiceId,
        "storeId": storeId,
        "storeName": storeName,
        "storeLogo": storeLogo,
        "storeAddress": storeAddress,
      };
}
