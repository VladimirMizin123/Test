import 'package:gymeats_mobile/screen/grocery/modal/grocery_multi_search_modal.dart';

class NearByStoreModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  List<Store>? data;

  NearByStoreModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory NearByStoreModel.fromJson(Map<String, dynamic> json) =>
      NearByStoreModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"]?["stores"] == null
            ? []
            : List<Store>.from(
                json["data"]["stores"]!.map(
                  (x) => Store.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
