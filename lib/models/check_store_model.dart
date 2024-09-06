class CheckStoreModel {
  bool? success;
  dynamic message;
  String? errorMessage;
  Data? data;

  CheckStoreModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory CheckStoreModel.fromJson(Map<String, dynamic> json) =>
      CheckStoreModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class Data {
  Quote? quote;

  Data({
    this.quote,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        quote: json["quote"] != null ? Quote.fromJson(json["quote"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "quote": quote?.toJson(),
      };
}

class Quote {
  TimeEstimate? timeEstimate;
  double? salesTaxPercent;
  int? orderMinimum;
  dynamic orderMaximum;
  DeliveryFee? deliveryFee;
  ServiceFee? serviceFee;
  SmallOrderFee? smallOrderFee;
  dynamic thresholdFees;
  bool? asapAvailable;
  dynamic error;

  Quote({
    this.timeEstimate,
    this.salesTaxPercent,
    this.orderMinimum,
    this.orderMaximum,
    this.deliveryFee,
    this.serviceFee,
    this.smallOrderFee,
    this.thresholdFees,
    this.asapAvailable,
    this.error,
  });

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        timeEstimate: json["time_estimate"] != null
            ? TimeEstimate.fromJson(json["time_estimate"])
            : null,
        salesTaxPercent: json["sales_tax_percent"]?.toDouble(),
        orderMinimum: json["order_minimum"],
        orderMaximum: json["order_maximum"],
        deliveryFee: json["delivery_fee"] != null
            ? DeliveryFee.fromJson(json["delivery_fee"])
            : null,
        serviceFee: json["service_fee"] != null
            ? ServiceFee.fromJson(json["service_fee"])
            : null,
        smallOrderFee: json["small_order_fee"] != null
            ? SmallOrderFee.fromJson(json["small_order_fee"])
            : null,
        thresholdFees: json["threshold_fees"],
        asapAvailable: json["asap_available"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "time_estimate": timeEstimate?.toJson(),
        "sales_tax_percent": salesTaxPercent,
        "order_minimum": orderMinimum,
        "order_maximum": orderMaximum,
        "delivery_fee": deliveryFee?.toJson(),
        "service_fee": serviceFee?.toJson(),
        "small_order_fee": smallOrderFee?.toJson(),
        "threshold_fees": thresholdFees,
        "asap_available": asapAvailable,
        "error": error,
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
        thresholdFees: List<dynamic>.from(json["threshold_fees"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "delivery_fee_flat": deliveryFeeFlat,
        "delivery_fee_percent": deliveryFeePercent,
        "delivery_fee_taxable": deliveryFeeTaxable,
        "threshold_fees":
            List<dynamic>.from(thresholdFees?.map((x) => x) ?? []),
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
