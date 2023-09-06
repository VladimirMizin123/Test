// To parse this JSON data, do
//
//     final nutritionixGetNxMealInfoByNameModel = nutritionixGetNxMealInfoByNameModelFromJson(jsonString);

import 'dart:convert';

NutritionixGetNxMealInfoByNameModel nutritionixGetNxMealInfoByNameModelFromJson(String str) => NutritionixGetNxMealInfoByNameModel.fromJson(json.decode(str));

String nutritionixGetNxMealInfoByNameModelToJson(NutritionixGetNxMealInfoByNameModel data) => json.encode(data.toJson());

class NutritionixGetNxMealInfoByNameModel {
  final bool? success;
  final dynamic message;
  final dynamic errorMessage;
  final NutritionixGetNxMealInfoByNameModelData? data;

  NutritionixGetNxMealInfoByNameModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory NutritionixGetNxMealInfoByNameModel.fromJson(Map<String, dynamic> json) => NutritionixGetNxMealInfoByNameModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null ? null : NutritionixGetNxMealInfoByNameModelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data?.toJson(),
      };
}

class NutritionixGetNxMealInfoByNameModelData {
  final String? foodName;
  final String? brandName;
  final int? servingQty;
  final String? servingUnit;
  final int? servingWeightGrams;
  final int? nfMetricQty;
  final String? nfMetricUom;
  final int? nfCalories;
  final int? nfTotalFat;
  final double? nfSaturatedFat;
  final double? nfCholesterol;
  final int? nfSodium;
  final int? nfTotalCarbohydrate;
  final int? nfDietaryFiber;
  final int? nfSugars;
  final int? nfProtein;
  final dynamic nfPotassium;
  final dynamic nfP;
  final List<FullNutrient>? fullNutrients;
  final String? nixBrandName;
  final String? nixBrandId;
  final String? nixItemName;
  final String? nixItemId;
  final Metadata? metadata;
  final int? source;
  final dynamic ndbNo;
  final dynamic tags;
  final dynamic altMeasures;
  final dynamic lat;
  final dynamic lng;
  final Photo? photo;
  final dynamic note;
  final dynamic classCode;
  final dynamic brickCode;
  final dynamic tagId;
  final DateTime? updatedAt;
  final String? nfIngredientStatement;

  NutritionixGetNxMealInfoByNameModelData({
    this.foodName,
    this.brandName,
    this.servingQty,
    this.servingUnit,
    this.servingWeightGrams,
    this.nfMetricQty,
    this.nfMetricUom,
    this.nfCalories,
    this.nfTotalFat,
    this.nfSaturatedFat,
    this.nfCholesterol,
    this.nfSodium,
    this.nfTotalCarbohydrate,
    this.nfDietaryFiber,
    this.nfSugars,
    this.nfProtein,
    this.nfPotassium,
    this.nfP,
    this.fullNutrients,
    this.nixBrandName,
    this.nixBrandId,
    this.nixItemName,
    this.nixItemId,
    this.metadata,
    this.source,
    this.ndbNo,
    this.tags,
    this.altMeasures,
    this.lat,
    this.lng,
    this.photo,
    this.note,
    this.classCode,
    this.brickCode,
    this.tagId,
    this.updatedAt,
    this.nfIngredientStatement,
  });

  factory NutritionixGetNxMealInfoByNameModelData.fromJson(Map<String, dynamic> json) => NutritionixGetNxMealInfoByNameModelData(
        foodName: json["food_name"],
        brandName: json["brand_name"],
        servingQty: json["serving_qty"],
        servingUnit: json["serving_unit"],
        servingWeightGrams: json["serving_weight_grams"],
        nfMetricQty: json["nf_metric_qty"],
        nfMetricUom: json["nf_metric_uom"],
        nfCalories: json["nf_calories"],
        nfTotalFat: json["nf_total_fat"],
        nfSaturatedFat: json["nf_saturated_fat"]?.toDouble(),
        nfCholesterol: json["nf_cholesterol"]?.toDouble(),
        nfSodium: json["nf_sodium"],
        nfTotalCarbohydrate: json["nf_total_carbohydrate"],
        nfDietaryFiber: json["nf_dietary_fiber"],
        nfSugars: json["nf_sugars"],
        nfProtein: json["nf_protein"],
        nfPotassium: json["nf_potassium"],
        nfP: json["nf_p"],
        fullNutrients: json["full_nutrients"] == null ? [] : List<FullNutrient>.from(json["full_nutrients"]!.map((x) => FullNutrient.fromJson(x))),
        nixBrandName: json["nix_brand_name"],
        nixBrandId: json["nix_brand_id"],
        nixItemName: json["nix_item_name"],
        nixItemId: json["nix_item_id"],
        metadata: json["metadata"] == null ? null : Metadata.fromJson(json["metadata"]),
        source: json["source"],
        ndbNo: json["ndb_no"],
        tags: json["tags"],
        altMeasures: json["alt_measures"],
        lat: json["lat"],
        lng: json["lng"],
        photo: json["photo"] == null ? null : Photo.fromJson(json["photo"]),
        note: json["note"],
        classCode: json["class_code"],
        brickCode: json["brick_code"],
        tagId: json["tag_id"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        nfIngredientStatement: json["nf_ingredient_statement"],
      );

  Map<String, dynamic> toJson() => {
        "food_name": foodName,
        "brand_name": brandName,
        "serving_qty": servingQty,
        "serving_unit": servingUnit,
        "serving_weight_grams": servingWeightGrams,
        "nf_metric_qty": nfMetricQty,
        "nf_metric_uom": nfMetricUom,
        "nf_calories": nfCalories,
        "nf_total_fat": nfTotalFat,
        "nf_saturated_fat": nfSaturatedFat,
        "nf_cholesterol": nfCholesterol,
        "nf_sodium": nfSodium,
        "nf_total_carbohydrate": nfTotalCarbohydrate,
        "nf_dietary_fiber": nfDietaryFiber,
        "nf_sugars": nfSugars,
        "nf_protein": nfProtein,
        "nf_potassium": nfPotassium,
        "nf_p": nfP,
        "full_nutrients": fullNutrients == null ? [] : List<dynamic>.from(fullNutrients!.map((x) => x.toJson())),
        "nix_brand_name": nixBrandName,
        "nix_brand_id": nixBrandId,
        "nix_item_name": nixItemName,
        "nix_item_id": nixItemId,
        "metadata": metadata?.toJson(),
        "source": source,
        "ndb_no": ndbNo,
        "tags": tags,
        "alt_measures": altMeasures,
        "lat": lat,
        "lng": lng,
        "photo": photo?.toJson(),
        "note": note,
        "class_code": classCode,
        "brick_code": brickCode,
        "tag_id": tagId,
        "updated_at": updatedAt?.toIso8601String(),
        "nf_ingredient_statement": nfIngredientStatement,
      };
}

class FullNutrient {
  final int? attrId;
  final double? value;

  FullNutrient({
    this.attrId,
    this.value,
  });

  factory FullNutrient.fromJson(Map<String, dynamic> json) => FullNutrient(
        attrId: json["attr_id"],
        value: json["value"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "attr_id": attrId,
        "value": value,
      };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata();

  Map<String, dynamic> toJson() => {};
}

class Photo {
  final String? thumb;
  final dynamic highres;
  final bool? isUserUploaded;

  Photo({
    this.thumb,
    this.highres,
    this.isUserUploaded,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        thumb: json["thumb"],
        highres: json["highres"],
        isUserUploaded: json["is_user_uploaded"],
      );

  Map<String, dynamic> toJson() => {
        "thumb": thumb,
        "highres": highres,
        "is_user_uploaded": isUserUploaded,
      };
}
