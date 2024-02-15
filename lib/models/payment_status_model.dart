import 'dart:convert';

PaymentStatusModel paymentStatusModelFromJson(String str) =>
    PaymentStatusModel.fromJson(json.decode(str));

String paymentStatusModelToJson(PaymentStatusModel data) =>
    json.encode(data.toJson());

class PaymentStatusModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  Data? data;

  PaymentStatusModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory PaymentStatusModel.fromJson(Map<String, dynamic> json) =>
      PaymentStatusModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] != null ? Data.fromJson(json["data"] ?? {}) : null,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class Data {
  String? id;
  String? status;
  String? userId;
  String? orderId;

  Data({
    this.id,
    this.status,
    this.userId,
    this.orderId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        status: json["status"],
        userId: json["userId"],
        orderId: json["orderId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "userId": userId,
        "orderId": orderId,
      };
}
