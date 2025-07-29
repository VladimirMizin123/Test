import 'dart:convert';
import 'package:gymeats_mobile/screen/grocery/modal/create_order_request_model.dart';
import 'package:gymeats_mobile/screen/grocery/modal/nutritionix_get_nx_meal_info_by_name_modal.dart';
import 'package:gymeats_mobile/models/check_store_model.dart' as qu;

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
  qu.Quote? quote;
  String? menuId;
  double? breakfastCalorie;
  double? lunchCalorie;
  double? snackCalorie;
  double? dinnerCalorie;
  List<Category>? categories;
  bool hasShopRestaurant;

  RestaurantMenu({
    this.quote,
    this.menuId,
    this.categories,
    this.breakfastCalorie,
    this.lunchCalorie,
    this.snackCalorie,
    this.dinnerCalorie,
    this.hasShopRestaurant = false,
  });

  factory RestaurantMenu.fromJson(Map<String, dynamic> json) => RestaurantMenu(
        quote: json["quote"] != null && json["quote"] is Map
            ? qu.Quote.fromJson(json["quote"])
            : null,
        menuId: json["menu_id"],
        breakfastCalorie:
            num.tryParse(json["breakfastCalorie"]?.toString() ?? "")
                ?.toDouble(),
        lunchCalorie:
            num.tryParse(json["lunchCalorie"]?.toString() ?? "")?.toDouble(),
        snackCalorie:
            num.tryParse(json["snackCalorie"]?.toString() ?? "")?.toDouble(),
        dinnerCalorie:
            num.tryParse(json["dinnerCalorie"]?.toString() ?? "")?.toDouble(),
        categories: json["categories"] == null
            ? []
            : List<Category>.from(
                json["categories"]!.map((x) => Category.fromJson(x))),
        hasShopRestaurant: json["hasShopRestaurant"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "menu_id": menuId,
        "breakfastCalorie": breakfastCalorie,
        "lunchCalorie": lunchCalorie,
        "snackCalorie": snackCalorie,
        "dinnerCalorie": dinnerCalorie,
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "hasShopRestaurant": hasShopRestaurant,
      };
}

class Category {
  String? name;
  String? subcategoryId;
  List<MenuItemList>? menuItemList;
  List<Category>? subcategories;

  Category({
    this.name,
    this.subcategoryId,
    this.menuItemList,
    this.subcategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        subcategoryId: json["subcategory_id"],
        menuItemList: json["menu_item_list"] == null
            ? []
            : List<MenuItemList>.from(
                json["menu_item_list"]!.map((x) => MenuItemList.fromJson(x))),
        subcategories: json["subcategories"] == null
            ? []
            : List<Category>.from(
                json["subcategories"]!.map((x) {
                  final subcategory = Category.fromJson(x);
                  subcategory.subcategoryId = null;
                  return subcategory;
                })),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "subcategory_id": subcategoryId,
        "menu_item_list": menuItemList == null
            ? []
            : List<dynamic>.from(menuItemList!.map((x) => x.toJson())),
        "subcategories": subcategories == null
            ? []
            : List<dynamic>.from(subcategories!.map((x) {
                final sub = x.toJson();
                sub.remove("subcategory_id");
                return sub;
              })),
      };
}

class MenuItemList {
  String? name;
  int? price;
  int? totalPrice;
  dynamic qtyAvailable;
  dynamic unitSize;
  String? unitOfMeasurement;
  String? description;
  bool? isAvailable;
  int? minPrice;
  String? image;
  List<Customization>? customizations;
  int? originalPrice;
  String? formattedPrice;
  List<dynamic>? attributes;
  String? productId;
  String? thumbnailImage;
  bool? shouldFetchCustomizations;
  bool? supportsImageScaling;
  String? highLightedColor;
  int? cartQuantity;
  dynamic cartPrice;
  bool isAdded;
  bool isAddUpdated;
  bool isRemoveUpdated;
  NutritionixGetNxMealInfoByNameModelData? mealInfoData;
  List<SelectedOptions>? selectedOptions;
  bool? eatableType;
  String? itemUrl;

  MenuItemList({
    this.name,
    this.price,
    this.totalPrice,
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
    this.highLightedColor,
    this.cartQuantity = 0,
    this.cartPrice = 0,
    this.isAdded = false,
    this.isAddUpdated = false,
    this.isRemoveUpdated = false,
    this.mealInfoData,
    this.selectedOptions,
    this.eatableType,
    this.itemUrl,
  });

  factory MenuItemList.fromJson(Map<String, dynamic> json) => MenuItemList(
        name: json["name"],
        price: json["price"],
        totalPrice: json["totalPrice"],
        qtyAvailable: json["qty_available"],
        unitSize: json["unit_size"],
        unitOfMeasurement: json["unit_of_measurement"],
        description: json["description"],
        isAvailable: json["is_available"],
        minPrice: json["min_price"],
        image: json["image"],
        customizations: json["customizations"] == null
            ? []
            : List<Customization>.from(
                json["customizations"]!.map((x) => Customization.fromJson(x))),
        originalPrice: json["original_price"],
        formattedPrice: json["formatted_price"],
        attributes: json["attributes"] == null
            ? []
            : List<dynamic>.from(json["attributes"]!.map((x) => x)),
        productId: json["product_id"],
        thumbnailImage: json["thumbnail_image"],
        shouldFetchCustomizations: json["should_fetch_customizations"],
        supportsImageScaling: json["supports_image_scaling"],
        highLightedColor: json["highLightedColor"],
        cartQuantity: json['cartQuantity'],
        selectedOptions: json["selectedOptions"] != null
            ? List<SelectedOptions>.from(json["selectedOptions"]
                    ?.map((x) => SelectedOptions.fromJson(x ?? {})) ??
                [])
            : [],
        eatableType: json["eatableType"],
        itemUrl: json["item_url"],
      );

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "price": price ?? 0,
      "totalPrice": totalPrice ?? 0,
      "qty_available": qtyAvailable ?? 0,
      "unit_size": unitSize ?? 0,
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
      "highLightedColor": highLightedColor,
      "mealInfoData": mealInfoData?.toJson(),
      "cartQuantity": cartQuantity,
      "selectedOptions": selectedOptions?.map((e) => e.toJson()).toList(),
      "eatableType": eatableType,
      "item_url": itemUrl,
    };
  }
}

class Customization {
  String? name;
  String? text;
  int? minChoiceOptions;
  int? maxChoiceOptions;
  List<Option>? options;
  String? customizationId;
  int level;

  Customization({
    this.name,
    this.text,
    this.minChoiceOptions,
    this.maxChoiceOptions,
    this.options,
    this.customizationId,
    this.level = 1,
  });

  factory Customization.fromJson(Map<String, dynamic> json) => Customization(
        name: json["name"],
        minChoiceOptions: json["min_choice_options"],
        maxChoiceOptions: json["max_choice_options"],
        text: json['text'],
        options: json["options"] == null
            ? []
            : List<Option>.from(
                json["options"]!.map((x) => Option.fromJson(x))),
        customizationId: json["customization_id"],
        level: json["level"] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "min_choice_options": minChoiceOptions,
        "max_choice_options": maxChoiceOptions,
        "text": text,
        "options": options == null
            ? []
            : List<dynamic>.from(options!.map((x) => x.toJson())),
        "customization_id": customizationId,
        "level": level,
      };
}

class Option {
  String? name;
  int? price;
  int? minQty;
  int? maxQty;
  bool? isRequired;
  String? formattedPrice;
  int? defaultQty;
  String? optionId;
  List<Customization>? customizations;
  bool isNestedSelection;
  bool hasQuantityControl;
  bool isSelected;

  Option({
    this.name,
    this.price,
    this.minQty,
    this.maxQty,
    this.isRequired,
    this.formattedPrice,
    this.defaultQty,
    this.optionId,
    this.customizations,
    this.isNestedSelection = false,
    this.hasQuantityControl = false,
    this.isSelected = false,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        name: json["name"],
        price: json["price"],
        minQty: json["min_qty"],
        maxQty: json["max_qty"],
        isRequired: json["is_required"],
        formattedPrice: json["formatted_price"],
        defaultQty: json["default_qty"],
        optionId: json["option_id"],
        isNestedSelection: json["is_nested_selection"] ?? false,
        hasQuantityControl: json["has_quantity_control"] ?? false,
        isSelected: json["is_selected"] ?? false,
        customizations: json["customizations"] != null
            ? List<Customization>.from(json["customizations"]!.map((x) => Customization.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "min_qty": minQty,
        "max_qty": maxQty,
        "is_required": isRequired,
        "formatted_price": formattedPrice,
        "default_qty": defaultQty,
        "option_id": optionId,
        "is_nested_selection": isNestedSelection,
        "is_selected": isSelected,
        "has_quantity_control": hasQuantityControl,
        "customizations": customizations?.map((e) => e.toJson()).toList(),
      };
}
