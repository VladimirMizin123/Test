import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';

class CategorieModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  Data? data;

  CategorieModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory CategorieModel.fromJson(Map<String, dynamic> json) => CategorieModel(
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
  String? menuId;
  List<Category>? categories;
  Quote? quote;

  Data({
    this.menuId,
    this.categories,
    this.quote,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        menuId: json["menu_id"],
        categories: json["categories"] == null
            ? []
            : List<Category>.from(
                json["categories"].map((x) => Category.fromJson(x))),
        quote: json["quote"] != null ? Quote.fromJson(json["quote"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "menu_id": menuId,
        "categories":
            List<dynamic>.from(categories?.map((x) => x.toJson()) ?? []),
        "quote": quote?.toJson(),
      };
}

class Category {
  String? name;
  String? image;
  String? subcategoryId;
  List<MenuItemList>? menuItemList;
  List<Category>? subcategoryList;

  Category({
    this.name,
    this.image,
    this.subcategoryId,
    this.menuItemList,
    this.subcategoryList,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        image: json["image"],
        subcategoryId: json["subcategory_id"],
        menuItemList: List<MenuItemList>.from(
          json["menu_item_list"]?.map((x) => MenuItemList.fromJson(x ?? {})) ??
              [],
        ),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "subcategory_id": subcategoryId,
        "menu_item_list":
            List<dynamic>.from(menuItemList?.map((x) => x.toJson()) ?? []),
      };
}

// class MenuItemList {
//   String? name;
//   int? price;
//   dynamic qtyAvailable;
//   num? unitSize;
//   String? unitOfMeasurement;
//   String? description;
//   bool? isAvailable;
//   int? minPrice;
//   String? image;
//   List<dynamic>? customizations;
//   int? originalPrice;
//   String? formattedPrice;
//   List<dynamic>? attributes;
//   String? productId;
//   String? thumbnailImage;
//   bool? shouldFetchCustomizations;
//   bool? supportsImageScaling;
//   final List<SelectedOptions>? selectedOptions;
//   int? quantity;

//   MenuItemList({
//     this.name,
//     this.price,
//     this.qtyAvailable,
//     this.unitSize,
//     this.unitOfMeasurement,
//     this.description,
//     this.isAvailable,
//     this.minPrice,
//     this.image,
//     this.customizations,
//     this.originalPrice,
//     this.formattedPrice,
//     this.attributes,
//     this.productId,
//     this.thumbnailImage,
//     this.shouldFetchCustomizations,
//     this.supportsImageScaling,
//     this.selectedOptions,
//     this.quantity,
//   });

//   factory MenuItemList.fromJson(Map<String, dynamic> json) => MenuItemList(
//         name: json["name"],
//         price: json["price"],
//         qtyAvailable: json["qty_available"],
//         unitSize: json["unit_size"],
//         unitOfMeasurement: json["unit_of_measurement"],
//         description: json["description"],
//         isAvailable: json["is_available"],
//         minPrice: json["min_price"],
//         image: json["image"],
//         customizations:
//             List<dynamic>.from(json["customizations"]?.map((x) => x) ?? []),
//         originalPrice: json["original_price"],
//         formattedPrice: json["formatted_price"],
//         attributes: List<dynamic>.from(json["attributes"]?.map((x) => x) ?? []),
//         productId: json["product_id"],
//         thumbnailImage: json["thumbnail_image"],
//         shouldFetchCustomizations: json["should_fetch_customizations"],
//         supportsImageScaling: json["supports_image_scaling"],
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "price": price,
//         "qty_available": qtyAvailable,
//         "unit_size": unitSize,
//         "unit_of_measurement": unitOfMeasurement,
//         "description": description,
//         "is_available": isAvailable,
//         "min_price": minPrice,
//         "image": image,
//         "customizations":
//             List<dynamic>.from(customizations?.map((x) => x) ?? []),
//         "original_price": originalPrice,
//         "formatted_price": formattedPrice,
//         "attributes": List<dynamic>.from(attributes?.map((x) => x) ?? []),
//         "product_id": productId,
//         "thumbnail_image": thumbnailImage,
//         "should_fetch_customizations": shouldFetchCustomizations,
//         "supports_image_scaling": supportsImageScaling,
//       };
// }

class Quote {
  TimeEstimate? timeEstimate;
  num? salesTaxPercent;
  num? orderMinimum;
  num? orderMaximum;
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
        timeEstimate: TimeEstimate.fromJson(json["time_estimate"] ?? {}),
        salesTaxPercent: json["sales_tax_percent"],
        orderMinimum: json["order_minimum"],
        orderMaximum: json["order_maximum"],
        deliveryFee: DeliveryFee.fromJson(json["delivery_fee"] ?? {}),
        serviceFee: ServiceFee.fromJson(json["service_fee"] ?? {}),
        smallOrderFee: SmallOrderFee.fromJson(json["small_order_fee"] ?? {}),
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
  num? deliveryFeeFlat;
  num? deliveryFeePercent;
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
        thresholdFees:
            List<dynamic>.from(json["threshold_fees"]?.map((x) => x) ?? []),
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
  num? serviceFeeFlat;
  num? serviceFeePercent;
  num? serviceFeeMin;
  bool? serviceFeeTaxable;

  ServiceFee({
    this.serviceFeeFlat,
    this.serviceFeePercent,
    this.serviceFeeMin,
    this.serviceFeeTaxable,
  });

  factory ServiceFee.fromJson(Map<String, dynamic> json) => ServiceFee(
        serviceFeeFlat: json["service_fee_flat"],
        serviceFeePercent: json["service_fee_percent"],
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
  num? minimumOrderValue;
  num? smallOrderFeeFlat;
  num? smallOrderFeePercent;

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
  num? minimum;
  num? maximum;

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

// class SelectedOptions {
//   String? optionId;
//   int? quantity;
//   int? markedPrice;

//   SelectedOptions({this.optionId, this.quantity, this.markedPrice});

//   SelectedOptions.fromJson(Map<String, dynamic> json) {
//     optionId = json['option_id'];
//     quantity = json['quantity'];
//     markedPrice = json['marked_price'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['option_id'] = optionId;
//     data['quantity'] = quantity;
//     data['marked_price'] = markedPrice;
//     return data;
//   }
// }
