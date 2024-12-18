import 'dart:convert';

StripeCardModel stripeCardModelFromJson(String str) =>
    StripeCardModel.fromJson(json.decode(str));

String stripeCardModelToJson(StripeCardModel data) =>
    json.encode(data.toJson());

class StripeCardModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  List<StripeCard>? data;

  StripeCardModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory StripeCardModel.fromJson(Map<String, dynamic> json) =>
      StripeCardModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] != null
            ? List<StripeCard>.from(
                json["data"].map((x) => StripeCard.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
      };
}

class StripeCard {
  String? id;
  String? object;
  dynamic accountId;
  dynamic account;
  String? addressCity;
  String? addressCountry;
  String? addressLine1;
  String? addressLine1Check;
  String? addressLine2;
  String? addressState;
  String? addressZip;
  String? addressZipCheck;
  dynamic availablePayoutMethods;
  String? brand;
  String? country;
  dynamic currency;
  String? customerId;
  dynamic customer;
  String? cvcCheck;
  dynamic defaultForCurrency;
  dynamic deleted;
  dynamic description;
  dynamic dynamicLast4;
  int? expMonth;
  int? expYear;
  String? fingerprint;
  String? funding;
  dynamic iin;
  dynamic issuer;
  String? last4;
  bool? isPrimary;
  // Metadata? metadata;
  String? name;
  dynamic status;
  dynamic tokenizationMethod;
  // Map<String, List<dynamic>>? rawJObject;
  dynamic stripeResponse;

  StripeCard({
    this.id,
    this.object,
    this.accountId,
    this.account,
    this.addressCity,
    this.addressCountry,
    this.addressLine1,
    this.addressLine1Check,
    this.addressLine2,
    this.addressState,
    this.addressZip,
    this.addressZipCheck,
    this.availablePayoutMethods,
    this.brand,
    this.country,
    this.currency,
    this.customerId,
    this.customer,
    this.cvcCheck,
    this.defaultForCurrency,
    this.deleted,
    this.description,
    this.dynamicLast4,
    this.expMonth,
    this.expYear,
    this.fingerprint,
    this.funding,
    this.iin,
    this.issuer,
    this.last4,
    this.isPrimary,
    // this.metadata,
    this.name,
    this.status,
    this.tokenizationMethod,
    // this.rawJObject,
    this.stripeResponse,
  });

  factory StripeCard.fromJson(Map<String, dynamic> json) => StripeCard(
        id: json["id"],
        object: json["object"],
        accountId: json["accountId"],
        account: json["account"],
        addressCity: json["addressCity"],
        addressCountry: json["addressCountry"],
        addressLine1: json["addressLine1"],
        addressLine1Check: json["addressLine1Check"],
        addressLine2: json["addressLine2"],
        addressState: json["addressState"],
        addressZip: json["addressZip"],
        addressZipCheck: json["addressZipCheck"],
        availablePayoutMethods: json["availablePayoutMethods"],
        brand: json["brand"],
        country: json["country"],
        currency: json["currency"],
        customerId: json["customerId"],
        customer: json["customer"],
        cvcCheck: json["cvcCheck"],
        defaultForCurrency: json["defaultForCurrency"],
        deleted: json["deleted"],
        description: json["description"],
        dynamicLast4: json["dynamicLast4"],
        expMonth: json["expMonth"],
        expYear: json["expYear"],
        fingerprint: json["fingerprint"],
        funding: json["funding"],
        iin: json["iin"],
        issuer: json["issuer"],
        last4: json["last4"],
        // metadata: json["metadata"] != null
        //     ? Metadata.fromJson(json["metadata"])
        //     : null,
        name: json["name"],
        status: json["status"],
        tokenizationMethod: json["tokenizationMethod"],
        // rawJObject: json["rawJObject"] != null
        //     ? Map.from(json["rawJObject"]).map((k, v) =>
        //         MapEntry<String, List<dynamic>>(
        //             k, List<dynamic>.from(v.map((x) => x))))
        //     : {},
        stripeResponse: json["stripeResponse"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "accountId": accountId,
        "account": account,
        "addressCity": addressCity,
        "addressCountry": addressCountry,
        "addressLine1": addressLine1,
        "addressLine1Check": addressLine1Check,
        "addressLine2": addressLine2,
        "addressState": addressState,
        "addressZip": addressZip,
        "addressZipCheck": addressZipCheck,
        "availablePayoutMethods": availablePayoutMethods,
        "brand": brand,
        "country": country,
        "currency": currency,
        "customerId": customerId,
        "customer": customer,
        "cvcCheck": cvcCheck,
        "defaultForCurrency": defaultForCurrency,
        "deleted": deleted,
        "description": description,
        "dynamicLast4": dynamicLast4,
        "expMonth": expMonth,
        "expYear": expYear,
        "fingerprint": fingerprint,
        "funding": funding,
        "iin": iin,
        "issuer": issuer,
        "last4": last4,
        // "metadata": metadata?.toJson(),
        "name": name,
        "status": status,
        "tokenizationMethod": tokenizationMethod,
        // "rawJObject": Map.from(rawJObject ?? {}).map((k, v) =>
        //     MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
        "stripeResponse": stripeResponse,
      };
}

// class Metadata {
//   Metadata();

//   factory Metadata.fromJson(Map<String, dynamic> json) => Metadata();

//   Map<String, dynamic> toJson() => {};
// }
