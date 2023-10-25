// To parse this JSON data, do
//
//     final getRestaurantMenuListModel = getRestaurantMenuListModelFromJson(jsonString);

import 'dart:convert';

GetRestaurantMenuListModel getRestaurantMenuListModelFromJson(String str) =>
    GetRestaurantMenuListModel.fromJson(json.decode(str));

String getRestaurantMenuListModelToJson(GetRestaurantMenuListModel data) =>
    json.encode(data.toJson());

class GetRestaurantMenuListModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  RestaurantMenu? data;

  GetRestaurantMenuListModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory GetRestaurantMenuListModel.fromJson(Map<String, dynamic> json) =>
      GetRestaurantMenuListModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data:
            json["data"] == null ? null : RestaurantMenu.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class RestaurantMenu {
  String? menuId;
  List<Category>? categories;

  RestaurantMenu({
    this.menuId,
    this.categories,
  });

  factory RestaurantMenu.fromJson(Map<String, dynamic> json) => RestaurantMenu(
        menuId: json["menu_id"],
        categories: json["categories"] == null
            ? []
            : List<Category>.from(
                json["categories"]!.map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "menu_id": menuId,
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
      };
}

class Category {
  String? name;
  String? subcategoryId;
  List<MenuItemList>? menuItemList;

  Category({
    this.name,
    this.subcategoryId,
    this.menuItemList,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        subcategoryId: json["subcategory_id"],
        menuItemList: json["menu_item_list"] == null
            ? []
            : List<MenuItemList>.from(
                json["menu_item_list"]!.map((x) => MenuItemList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "subcategory_id": subcategoryId,
        "menu_item_list": menuItemList == null
            ? []
            : List<dynamic>.from(menuItemList!.map((x) => x.toJson())),
      };
}

class MenuItemList {
  String? name;
  int? price;
  dynamic qtyAvailable;
  dynamic unitSize;
  String? unitOfMeasurement;
  String? description;
  bool? isAvailable;
  int? minPrice;
  String? image;
  List<MenuItemListCustomization>? customizations;
  int? originalPrice;
  String? formattedPrice;
  List<dynamic>? attributes;
  String? productId;
  String? thumbnailImage;
  bool? shouldFetchCustomizations;
  bool? supportsImageScaling;

  MenuItemList({
    this.name,
    this.price,
    this.qtyAvailable,
    this.unitSize,
    this.unitOfMeasurement,
    this.description,
    this.isAvailable,
    this.minPrice,
    this.image,
    this.customizations,
    this.originalPrice,
    this.formattedPrice,
    this.attributes,
    this.productId,
    this.thumbnailImage,
    this.shouldFetchCustomizations,
    this.supportsImageScaling,
  });

  factory MenuItemList.fromJson(Map<String, dynamic> json) => MenuItemList(
        name: json["name"],
        price: json["price"],
        qtyAvailable: json["qty_available"],
        unitSize: json["unit_size"],
        unitOfMeasurement: json["unit_of_measurement"],
        description: json["description"],
        isAvailable: json["is_available"],
        minPrice: json["min_price"],
        image: json["image"],
        customizations: json["customizations"] == null
            ? []
            : List<MenuItemListCustomization>.from(json["customizations"]!
                .map((x) => MenuItemListCustomization.fromJson(x))),
        originalPrice: json["original_price"],
        formattedPrice: json["formatted_price"],
        attributes: json["attributes"] == null
            ? []
            : List<dynamic>.from(json["attributes"]!.map((x) => x)),
        productId: json["product_id"],
        thumbnailImage: json["thumbnail_image"],
        shouldFetchCustomizations: json["should_fetch_customizations"],
        supportsImageScaling: json["supports_image_scaling"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "qty_available": qtyAvailable,
        "unit_size": unitSize,
        "unit_of_measurement": unitOfMeasurement,
        "description": description,
        "is_available": isAvailable,
        "min_price": minPrice,
        "image": image,
        "customizations": customizations == null
            ? []
            : List<dynamic>.from(customizations!.map((x) => x.toJson())),
        "original_price": originalPrice,
        "formatted_price": formattedPrice,
        "attributes": attributes == null
            ? []
            : List<dynamic>.from(attributes!.map((x) => x)),
        "product_id": productId,
        "thumbnail_image": thumbnailImage,
        "should_fetch_customizations": shouldFetchCustomizations,
        "supports_image_scaling": supportsImageScaling,
      };
}

class MenuItemListCustomization {
  String? name;
  int? minChoiceOptions;
  int? maxChoiceOptions;
  List<PurpleOption>? options;
  String? customizationId;

  MenuItemListCustomization({
    this.name,
    this.minChoiceOptions,
    this.maxChoiceOptions,
    this.options,
    this.customizationId,
  });

  factory MenuItemListCustomization.fromJson(Map<String, dynamic> json) =>
      MenuItemListCustomization(
        name: json["name"],
        minChoiceOptions: json["min_choice_options"],
        maxChoiceOptions: json["max_choice_options"],
        options: json["options"] == null
            ? []
            : List<PurpleOption>.from(
                json["options"]!.map((x) => PurpleOption.fromJson(x))),
        customizationId: json["customization_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "min_choice_options": minChoiceOptions,
        "max_choice_options": maxChoiceOptions,
        "options": options == null
            ? []
            : List<dynamic>.from(options!.map((x) => x.toJson())),
        "customization_id": customizationId,
      };
}

class PurpleOption {
  String? name;
  int? price;
  List<PurpleCustomization>? customizations;
  int? minQty;
  int? maxQty;
  ConditionalPrice? conditionalPrice;
  String? formattedPrice;
  int? defaultQty;
  String? optionId;

  PurpleOption({
    this.name,
    this.price,
    this.customizations,
    this.minQty,
    this.maxQty,
    this.conditionalPrice,
    this.formattedPrice,
    this.defaultQty,
    this.optionId,
  });

  factory PurpleOption.fromJson(Map<String, dynamic> json) => PurpleOption(
        name: json["name"],
        price: json["price"],
        customizations: json["customizations"] == null
            ? []
            : List<PurpleCustomization>.from(json["customizations"]!
                .map((x) => PurpleCustomization.fromJson(x))),
        minQty: json["min_qty"],
        maxQty: json["max_qty"],
        conditionalPrice: json["conditional_price"] == null
            ? null
            : ConditionalPrice.fromJson(json["conditional_price"]),
        formattedPrice: json["formatted_price"],
        defaultQty: json["default_qty"],
        optionId: json["option_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "customizations": customizations == null
            ? []
            : List<dynamic>.from(customizations!.map((x) => x.toJson())),
        "min_qty": minQty,
        "max_qty": maxQty,
        "conditional_price": conditionalPrice?.toJson(),
        "formatted_price": formattedPrice,
        "default_qty": defaultQty,
        "option_id": optionId,
      };
}

class ConditionalPrice {
  ConditionalPrice();

  factory ConditionalPrice.fromJson(Map<String, dynamic> json) =>
      ConditionalPrice();

  Map<String, dynamic> toJson() => {};
}

class PurpleCustomization {
  String? name;
  int? minChoiceOptions;
  int? maxChoiceOptions;
  List<FluffyOption>? options;
  String? customizationId;

  PurpleCustomization({
    this.name,
    this.minChoiceOptions,
    this.maxChoiceOptions,
    this.options,
    this.customizationId,
  });

  factory PurpleCustomization.fromJson(Map<String, dynamic> json) =>
      PurpleCustomization(
        name: json["name"],
        minChoiceOptions: json["min_choice_options"],
        maxChoiceOptions: json["max_choice_options"],
        options: json["options"] == null
            ? []
            : List<FluffyOption>.from(
                json["options"]!.map((x) => FluffyOption.fromJson(x))),
        customizationId: json["customization_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "min_choice_options": minChoiceOptions,
        "max_choice_options": maxChoiceOptions,
        "options": options == null
            ? []
            : List<dynamic>.from(options!.map((x) => x.toJson())),
        "customization_id": customizationId,
      };
}

class FluffyOption {
  String? name;
  int? price;
  List<FluffyCustomization>? customizations;
  int? minQty;
  int? maxQty;
  ConditionalPrice? conditionalPrice;
  String? formattedPrice;
  int? defaultQty;
  String? optionId;

  FluffyOption({
    this.name,
    this.price,
    this.customizations,
    this.minQty,
    this.maxQty,
    this.conditionalPrice,
    this.formattedPrice,
    this.defaultQty,
    this.optionId,
  });

  factory FluffyOption.fromJson(Map<String, dynamic> json) => FluffyOption(
        name: json["name"],
        price: json["price"],
        customizations: json["customizations"] == null
            ? []
            : List<FluffyCustomization>.from(json["customizations"]!
                .map((x) => FluffyCustomization.fromJson(x))),
        minQty: json["min_qty"],
        maxQty: json["max_qty"],
        conditionalPrice: json["conditional_price"] == null
            ? null
            : ConditionalPrice.fromJson(json["conditional_price"]),
        formattedPrice: json["formatted_price"],
        defaultQty: json["default_qty"],
        optionId: json["option_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "customizations": customizations == null
            ? []
            : List<dynamic>.from(customizations!.map((x) => x.toJson())),
        "min_qty": minQty,
        "max_qty": maxQty,
        "conditional_price": conditionalPrice?.toJson(),
        "formatted_price": formattedPrice,
        "default_qty": defaultQty,
        "option_id": optionId,
      };
}

class FluffyCustomization {
  String? name;
  int? minChoiceOptions;
  int? maxChoiceOptions;
  List<TentacledOption>? options;
  String? customizationId;

  FluffyCustomization({
    this.name,
    this.minChoiceOptions,
    this.maxChoiceOptions,
    this.options,
    this.customizationId,
  });

  factory FluffyCustomization.fromJson(Map<String, dynamic> json) =>
      FluffyCustomization(
        name: json["name"],
        minChoiceOptions: json["min_choice_options"],
        maxChoiceOptions: json["max_choice_options"],
        options: json["options"] == null
            ? []
            : List<TentacledOption>.from(
                json["options"]!.map((x) => TentacledOption.fromJson(x))),
        customizationId: json["customization_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "min_choice_options": minChoiceOptions,
        "max_choice_options": maxChoiceOptions,
        "options": options == null
            ? []
            : List<dynamic>.from(options!.map((x) => x.toJson())),
        "customization_id": customizationId,
      };
}

class TentacledOption {
  String? name;
  int? price;
  List<dynamic>? customizations;
  int? minQty;
  int? maxQty;
  ConditionalPrice? conditionalPrice;
  String? formattedPrice;
  int? defaultQty;
  String? optionId;

  TentacledOption({
    this.name,
    this.price,
    this.customizations,
    this.minQty,
    this.maxQty,
    this.conditionalPrice,
    this.formattedPrice,
    this.defaultQty,
    this.optionId,
  });

  factory TentacledOption.fromJson(Map<String, dynamic> json) =>
      TentacledOption(
        name: json["name"],
        price: json["price"],
        customizations: json["customizations"] == null
            ? []
            : List<dynamic>.from(json["customizations"]!.map((x) => x)),
        minQty: json["min_qty"],
        maxQty: json["max_qty"],
        conditionalPrice: json["conditional_price"] == null
            ? null
            : ConditionalPrice.fromJson(json["conditional_price"]),
        formattedPrice: json["formatted_price"],
        defaultQty: json["default_qty"],
        optionId: json["option_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "customizations": customizations == null
            ? []
            : List<dynamic>.from(customizations!.map((x) => x)),
        "min_qty": minQty,
        "max_qty": maxQty,
        "conditional_price": conditionalPrice?.toJson(),
        "formatted_price": formattedPrice,
        "default_qty": defaultQty,
        "option_id": optionId,
      };
}
