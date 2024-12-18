// To parse this JSON data, do
//
//     final defaultCardModel = defaultCardModelFromJson(jsonString);

import 'dart:convert';

DefaultCardModel defaultCardModelFromJson(String str) =>
    DefaultCardModel.fromJson(json.decode(str));

String defaultCardModelToJson(DefaultCardModel data) =>
    json.encode(data.toJson());

class DefaultCardModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  Data? data;

  DefaultCardModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory DefaultCardModel.fromJson(Map<String, dynamic> json) =>
      DefaultCardModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: Data.fromJson(json["data"] ?? {}),
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
  String? object;
  int? balance;
  dynamic cashBalance;
  DateTime? created;
  dynamic currency;
  String? defaultSourceId;
  dynamic defaultSource;
  dynamic deleted;
  bool? delinquent;
  dynamic description;
  dynamic discount;
  String? email;
  dynamic invoiceCreditBalance;
  String? invoicePrefix;
  bool? livemode;
  String? name;
  int? nextInvoiceSequence;
  dynamic phone;
  List<dynamic>? preferredLocales;
  dynamic shipping;
  dynamic sources;
  dynamic subscriptions;
  dynamic tax;
  String? taxExempt;
  dynamic taxIds;
  dynamic testClockId;
  dynamic testClock;

  Data({
    this.id,
    this.object,
    this.balance,
    this.cashBalance,
    this.created,
    this.currency,
    this.defaultSourceId,
    this.defaultSource,
    this.deleted,
    this.delinquent,
    this.description,
    this.discount,
    this.email,
    this.invoiceCreditBalance,
    this.invoicePrefix,
    this.livemode,
    this.name,
    this.nextInvoiceSequence,
    this.phone,
    this.preferredLocales,
    this.shipping,
    this.sources,
    this.subscriptions,
    this.tax,
    this.taxExempt,
    this.taxIds,
    this.testClockId,
    this.testClock,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        object: json["object"],
        balance: json["balance"],
        cashBalance: json["cashBalance"],
        created: DateTime.parse(json["created"]),
        currency: json["currency"],
        defaultSourceId: json["defaultSourceId"],
        defaultSource: json["defaultSource"],
        deleted: json["deleted"],
        delinquent: json["delinquent"],
        description: json["description"],
        discount: json["discount"],
        email: json["email"],
        invoiceCreditBalance: json["invoiceCreditBalance"],
        invoicePrefix: json["invoicePrefix"],
        livemode: json["livemode"],
        name: json["name"],
        nextInvoiceSequence: json["nextInvoiceSequence"],
        phone: json["phone"],
        preferredLocales:
            List<dynamic>.from(json["preferredLocales"].map((x) => x)),
        shipping: json["shipping"],
        sources: json["sources"],
        subscriptions: json["subscriptions"],
        tax: json["tax"],
        taxExempt: json["taxExempt"],
        taxIds: json["taxIds"],
        testClockId: json["testClockId"],
        testClock: json["testClock"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "balance": balance,
        "cashBalance": cashBalance,
        "created": created?.toIso8601String(),
        "currency": currency,
        "defaultSourceId": defaultSourceId,
        "defaultSource": defaultSource,
        "deleted": deleted,
        "delinquent": delinquent,
        "description": description,
        "discount": discount,
        "email": email,
        "invoiceCreditBalance": invoiceCreditBalance,
        "invoicePrefix": invoicePrefix,
        "livemode": livemode,
        "name": name,
        "nextInvoiceSequence": nextInvoiceSequence,
        "phone": phone,
        "preferredLocales":
            List<dynamic>.from(preferredLocales?.map((x) => x) ?? []),
        "shipping": shipping,
        "sources": sources,
        "subscriptions": subscriptions,
        "tax": tax,
        "taxExempt": taxExempt,
        "taxIds": taxIds,
        "testClockId": testClockId,
        "testClock": testClock,
      };
}
