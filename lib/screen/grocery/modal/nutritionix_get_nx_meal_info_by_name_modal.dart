// To parse this JSON data, do
//
//     final nutritionixGetNxMealInfoByNameModel = nutritionixGetNxMealInfoByNameModelFromJson(jsonString);

import 'dart:convert';

NutritionixGetNxMealInfoByNameModel nutritionixGetNxMealInfoByNameModelFromJson(
        String str) =>
    NutritionixGetNxMealInfoByNameModel.fromJson(json.decode(str));

String nutritionixGetNxMealInfoByNameModelToJson(
        NutritionixGetNxMealInfoByNameModel data) =>
    json.encode(data.toJson());

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

  factory NutritionixGetNxMealInfoByNameModel.fromJson(
          Map<String, dynamic> json) =>
      NutritionixGetNxMealInfoByNameModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"] == null
            ? null
            : NutritionixGetNxMealInfoByNameModelData.fromJson(json["data"]),
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
  final num? servingQty;
  final String? servingUnit;
  final String? servingWeightGrams;
  final num? nfMetricQty;
  final String? nfMetricUom;
  final num? nfCalories;
  final dynamic nfTotalFat;
  final dynamic nfSaturatedFat;
  final num? nfCholesterol;
  final num? nfSodium;
  final num? nfTotalCarbohydrate;
  final num? nfDietaryFiber;
  final num? nfSugars;
  final num? nfProtein;
  final num? nfPotassium;
  final dynamic nfP;
  final List<FullNutrient>? fullNutrients;
  final String? nixBrandName;
  final String? nixBrandId;
  final String? nixItemName;
  final String? nixItemId;
  final Metadata? metadata;
  final num? source;
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

  factory NutritionixGetNxMealInfoByNameModelData.fromJson(
          Map<dynamic, dynamic> json) =>
      NutritionixGetNxMealInfoByNameModelData(
        foodName: json["foodName"],
        brandName: json["brandName"],
        servingQty: json["servingQuantity"],
        servingUnit: json["servingUnit"],
        servingWeightGrams: json["servingWeightInGram"],
        //nfMetricQty: json["nfMetricQuantity"],
        nfMetricUom: json["nfMetricUom"],
        nfCalories: json["nfCalories"],
        nfTotalFat: json["nfTotalFat"],
        nfSaturatedFat: json["nfSaturatedFat"],
        nfCholesterol: json["nfCholesterol"],
        nfSodium: json["nfSodium"],
        nfTotalCarbohydrate: json["nfTotalCabohydrate"],
        nfDietaryFiber: json["nfDietaryFiber"],
        nfSugars: json["nfSugar"],
        nfProtein: json["nfProtein"],
        nfPotassium: json["nfPotassium"],
        nfP: json["nf_P"],
        // fullNutrients: json["nfFullNutrients"] == null
        //     ? []
        //     : List<FullNutrient>.from(
        //         json["nfFullNutrients"]!.map((x) => FullNutrient.fromJson(x))),
        nixBrandName: json["nxBrandname"],
        nixBrandId: json["nxBrandId"],
        nixItemName: json["nxItemName"],
        nixItemId: json["nxItemId"],
        // metadata: json["metadata"] == null
        //     ? null
        //     : Metadata.fromJson(json["metadata"]),
        source: json["source"],
        ndbNo: json["ndb_No"],
        tags: json["tags"],
        altMeasures: json["alt_Measure"],
        lat: json["lat"],
        lng: json["lng"],
        //photo: json["photo"] == null ? null : Photo.fromJson(json["photo"]),
        note: json["note"],
        classCode: json["class_Code"],
        brickCode: json["brick_Code"],
        tagId: json["tag_Id"],
        updatedAt: json["updated_At"] == null
            ? null
            : DateTime.parse(json["updated_At"]),
        nfIngredientStatement: json["nf_Ingredient_Statement"],
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
        "full_nutrients": fullNutrients == null
            ? []
            : List<dynamic>.from(fullNutrients!.map((x) => x.toJson())),
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
  final num? attrId;
  final num? value;

  FullNutrient({
    this.attrId,
    this.value,
  });

  factory FullNutrient.fromJson(Map<String, dynamic> json) => FullNutrient(
        attrId: json["attr_id"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "attr_id": attrId,
        "value": value,
      };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<dynamic, dynamic> json) => Metadata();

  Map<dynamic, dynamic> toJson() => {};
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

  factory Photo.fromJson(Map<dynamic, dynamic> json) => Photo(
        thumb: json["thumb"],
        highres: json["highres"],
        isUserUploaded: json["is_user_uploaded"],
      );

  Map<dynamic, dynamic> toJson() => {
        "thumb": thumb,
        "highres": highres,
        "is_user_uploaded": isUserUploaded,
      };
}
