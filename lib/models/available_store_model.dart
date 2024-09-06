class AvailableStoreModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  Data? data;

  AvailableStoreModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory AvailableStoreModel.fromJson(Map<String, dynamic> json) =>
      AvailableStoreModel(
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
  List<Store>? stores;

  Data({
    this.stores,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        stores: List<Store>.from(
            json["stores"]?.map((x) => Store.fromJson(x ?? {})) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "stores": List<dynamic>.from(stores?.map((x) => x.toJson()) ?? []),
      };
}

class Store {
  String? storeId;

  Store({
    this.storeId,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        storeId: json["storeId"],
      );

  Map<String, dynamic> toJson() => {
        "storeId": storeId,
      };
}
