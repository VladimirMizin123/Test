import 'dart:convert';
import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:get/utils.dart';
import 'package:gymeats_mobile/app/sharedPrefrence.dart';
import 'package:gymeats_mobile/constant/constant.dart';
import 'package:gymeats_mobile/models/available_store_model.dart';
import 'package:gymeats_mobile/models/check_store_model.dart';
import 'package:gymeats_mobile/models/error_model.dart';
import 'package:gymeats_mobile/models/payment_status_model.dart';
import 'package:gymeats_mobile/models/success_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/add_items_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/create_checkout_request_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/create_order_request_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/create_order_response_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/create_product_request_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/create_product_response_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_cousines_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_order_details.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_restaurant_menu_list.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_shopping_list_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/get_user_address_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/near_by_store_model.dart';
import 'package:gymeats_mobile/screen/restaurants/model/update_cart_items_model.dart';
import 'package:gymeats_mobile/service/api_urls.dart';
import 'package:gymeats_mobile/service/apis.dart';
import 'package:gymeats_mobile/widget/app_widget.dart';
import 'package:http/http.dart';

class RestaurantRepository {
  final ApiServices apiServices = ApiServices();

  String userID = PreferenceUtils.getString(prefUserData);

  /// GetUserGroceryList ====================================================================

  Future<Either<ErrorModel, GetUserAddressModel>> getUserAddressData() async {
    log('${ApiUrls.getUserAddress}/$userID');

    final response = await apiServices.get(
      '${ApiUrls.getUserAddress}/$userID',
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetUserAddressModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(GetUserAddressModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Get Restaurant List ====================================================================

  Future<Either<ErrorModel, GetRestaurantListModel>> getRestaurantListData({
    required double? latitude,
    required double? longitude,
    required bool pickup,
    String? mealName,
    required int maximumMiles,
    required List categoriesData,
  }) async {
    (double?, double?) pos = await Constant.i.position;

    double? lat = latitude;
    double? lng = longitude;

    if (latitude == null &&
        longitude == null &&
        pos.$1 == null &&
        pos.$2 == null) {
      Either<ErrorModel, GetUserAddressModel> res = await getUserAddressData();
      if (res.isRight) {
        var add = res.right.data
            ?.firstWhereOrNull((element) => element.isPrimary ?? false);
        if (add != null) {
          lat = add.latitude;
          lng = add.longitude;
        }
        if ((res.right.data?.isNotEmpty ?? false) && add == null) {
          lat = res.right.data?.first.latitude;
          lng = res.right.data?.first.longitude;
        }
      }
    }

    Map<String, dynamic> data = {
      "latitude": pos.$1 ?? lat,
      "longitude": pos.$2 ?? lng,
      "pickup": pickup,
      "maximum_miles": maximumMiles,
      "categories": categoriesData,
    };
    if (mealName != null) {
      data["mealName"] = mealName;
    }
    log("Api Url : ${ApiUrls.getRestaurantList}");
    log('data---------->>>>>> ${jsonEncode(data)}');

    final response = await apiServices.post(ApiUrls.getRestaurantList, data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetRestaurantListModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(GetRestaurantListModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, NearByStoreModel>> getStoreByName({
    required String latitude,
    required String longitude,
    required bool pickup,
    required List<String> cuisine,
    String? name,
  }) async {
    String apiURL = "${ApiUrls.getStoreByName}/$name";
    log(apiURL);

    (double?, double?) pos = await Constant.i.position;

    Map<String, dynamic> data = {
      "latitude": pos.$1?.toString() ?? latitude,
      "longitude": pos.$2?.toString() ?? longitude,
      "pickup": pickup,
      "StoreType": 'restaurant',
      "maximum_miles": PreferenceUtils.getRestaurantsRadius(),
      "cuisine": cuisine,
    };

    log("Req : ${jsonEncode(data)}");

    final response = await apiServices.get(apiURL, queryParams: data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      NearByStoreModel searchModel = NearByStoreModel.fromJson(
          jsonDecode(response.body)['data'] == null
              ? {}
              : jsonDecode(response.body));
      for (int i = 0; i < (searchModel.data?.length ?? 0); i++) {
        if (searchModel.data?[i].logoPhotos?.isNotEmpty ?? false) {
          PreferenceUtils.setString("${searchModel.data?[i].id}_img",
              searchModel.data?[i].logoPhotos?[0] ?? "");
        }
      }

      return Right(searchModel);
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, AvailableStoreModel>> getAvailableStoreList({
    required dynamic latitude,
    required dynamic longitude,
    required String userStreetNum,
    required String userStreetName,
    required String userCity,
    required String userState,
    required String userCountry,
    required String userZipcode,
    required bool pickup,
    required int maximumMiles,
    required List categoriesData,
    List<String>? storeId,
  }) async {
    (double?, double?) pos = await Constant.i.position;
    Map<String, dynamic> data = {
      "latitude": pos.$1 ?? latitude.toStringAsFixed(6),
      "longitude": pos.$2 ?? longitude.toStringAsFixed(6),
      "user_street_num": userStreetNum,
      "user_street_name": userStreetName,
      "user_city": userCity,
      "user_state": userState,
      "user_country": userCountry,
      "user_zipcode": userZipcode,
      "pickup": pickup,
      "maximum_miles": maximumMiles,
      "categories": categoriesData,
      "store_Id": storeId ?? [],
      "page": 1,
    };
    log("Api : ${ApiUrls.getAvailableStoreList}");
    log("Data : $data");

    final response =
        await apiServices.post(ApiUrls.getAvailableStoreList, data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(AvailableStoreModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(AvailableStoreModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, CheckStoreModel>> checkAvailableStore({
    required String storeType,
    required dynamic latitude,
    required dynamic longitude,
    required bool pickup,
    required String storeId,
    bool addDelay = false,
    (double?, double?)? position,
  }) async {
    if (addDelay) {
      await Future.delayed(const Duration(milliseconds: 10));
    } else {}
    (double?, double?) pos = position ?? await Constant.i.position;
    Map<String, dynamic> data = {
      "storeType": storeType,
      "latitude": double.tryParse(
              (pos.$1?.toString()) ?? (latitude?.toString() ?? "")) ??
          0.0,
      "longitude": double.tryParse(
              (pos.$2?.toString()) ?? (longitude?.toString() ?? "")) ??
          0.0,
      "pickup": pickup,
      "storeId": storeId,
    };
    log("Api : ${ApiUrls.checkAvailableStore}");
    log("Req Data : $data");
    final response =
        await apiServices.get(ApiUrls.checkAvailableStore, queryParams: data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(CheckStoreModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(CheckStoreModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Get Restaurant Menu List ====================================================================

  Future<Either<ErrorModel, GetRestaurantMenuListModel>> getRestaurantMenuList({
    String? restaurantId,
    bool? pickup,
    String? mealType,
    required double? latitude,
    required double? longitude,
    (double?, double?)? position,
  }) async {
    try {
      (double?, double?) pos = position ?? await Constant.i.position;
      Map<String, dynamic> data = {
        "userId": userId,
        "mealType": mealType,
        "restaurantId": restaurantId,
        "latitude": pos.$1 ?? latitude,
        "longitude": pos.$2 ?? longitude,
        "pickup": pickup,
      };
      log("Api Url : ${ApiUrls.getRestaurantMenuList}");
      log("Request Data : $data");

      final response = await apiServices
          .post(ApiUrls.getRestaurantMenuList, data, customToast: true);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(
            GetRestaurantMenuListModel.fromJson(jsonDecode(response.body)));
      } else if (response.statusCode == 400) {
        return Right(
            GetRestaurantMenuListModel.fromJson(jsonDecode(response.body)));
      } else {
        showToast(
          message: Left(ErrorModel.fromJson(jsonDecode(response.body)))
              .value
              .errorMessage
              .toString(),
          isSuccess: false,
        );
        return Left(ErrorModel.fromJson(jsonDecode(response.body)));
      }
    } catch (e) {
      showToast(message: e.toString(), isSuccess: false);
      return Left(ErrorModel(errorMessage: e.toString()));
    }
  }

  /// Get Cousines List ====================================================================

  Future<Either<ErrorModel, GetCousinesListModel>> getCousinesListData({
    required dynamic latitude,
    required dynamic longitude,
    required String userStreetNum,
    required String userStreetName,
    required String userCity,
    required String userState,
    required String userCountry,
    required String userZipcode,
    required bool pickup,
    required int maximumMiles,
  }) async {
    Map<String, dynamic> data = {
      "latitude": latitude.toStringAsFixed(6),
      "longitude": longitude.toStringAsFixed(6),
      "user_street_num": userStreetNum,
      "user_street_name": userStreetName,
      "user_city": userCity,
      "user_state": userState,
      "user_country": userCountry,
      "user_zipcode": userZipcode,
      "pickup": pickup,
      "maximum_miles": maximumMiles
    };

    log(ApiUrls.getCousinesList);

    final response = await apiServices.post(
      ApiUrls.getCousinesList,
      data,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetCousinesListModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(GetCousinesListModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Add Shopping List ====================================================================

  Future<Either<ErrorModel, SuccessModel>> addMenuToCartRestaurant(
      {required List<AddRestaurantItemsToShoppingListModel>
          addItemsToShoppingList}) async {
    final response = await apiServices.post(
      ApiUrls.addItemsToShoppingList,
      {"userId": userID, "itemList": addItemsToShoppingList},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Get Shopping List ====================================================================

  Future<Either<ErrorModel, GetShoppingListData>> getShoppingList() async {
    log('${ApiUrls.getShoppingList}/$userID');
    final response =
        await apiServices.get('${ApiUrls.getShoppingList}/$userID');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetShoppingListData.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(GetShoppingListData.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Update Shopping List ====================================================================

  Future<Either<ErrorModel, SuccessModel>> updateMenuToCartRestaurant(
      {required UpdateRestaurantItemsToShoppingListModel
          updateItemsToShoppingList}) async {
    final response = await apiServices.put(
      ApiUrls.updateShoppingList,
      updateItemsToShoppingList,
    );

    log('updateItemsToShoppingList---------->>>>>> ${updateItemsToShoppingList.itemOptions}');

    log('response.statusCode---------->>>>>> ${response.statusCode}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Remove Shopping List Item====================================================================

  Future<Either<ErrorModel, SuccessModel>> removeShoppingListItem(
      {String? productID}) async {
    final response = await apiServices
        .delete('${ApiUrls.removeProduct}?userId=$userID&productId=$productID');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    }
    // else if (response.statusCode == 400) {
    //   log('GetRestaurantMenuListErrorState---------->>>>>>}');
    //
    //   return Right(
    //       GetRestaurantMenuListModel.fromJson(jsonDecode(response.body)));
    // }
    else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Create Order ====================================================================

  Future<Either<ErrorModel, CreateOrderResponseModel>> createOrder(
      {required CreateOrderModel createOrderModel}) async {
    Response? response;
    try {
      Map<String, dynamic> req = createOrderModel.toJson();
      log(ApiUrls.createOrder);
      log("Req : ${jsonEncode(req)}");
      response = await apiServices.post(ApiUrls.createOrder, req);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(
            CreateOrderResponseModel.fromJson(jsonDecode(response.body)));
      } else {
        return Left(
          ErrorModel.fromJson(jsonDecode(response.body))
            ..statusCode = response.statusCode,
        );
      }
    } catch (e) {
      return Left(
        ErrorModel(message: e.toString(), errorMessage: e.toString())
          ..statusCode = 500,
      );
    }
  }

  /// Create Product ====================================================================

  Future<Either<ErrorModel, CreateProductResponseModel>> createProduct(
      {required CreateProductRequestModel createProductRequestModel}) async {
    // log("Api : ${ApiUrls.createProduct}");
    // log("Request Data ; ${jsonEncode(createProductRequestModel.toJson())}")
    Map<String, dynamic> req = createProductRequestModel.toJson();
    log(ApiUrls.createProduct);
    log("Req : ${jsonEncode(req)}");

    final response = await apiServices.post(ApiUrls.createProduct, req);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // log("Response :${response.body}");
      return Right(
          CreateProductResponseModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Create Checkout====================================================================

  Future<Either<ErrorModel, SuccessModel>> createCheckout(
      {required CreateCheckOutRequestModel createCheckOutRequestModel}) async {
    log("Create Check Out: ${ApiUrls.createCheckout}");
    log("Req: ${jsonEncode(createCheckOutRequestModel.toJson())}");
    final response = await apiServices.post(
      ApiUrls.createCheckout,
      createCheckOutRequestModel.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Get Order Details====================================================================

  Future<Either<ErrorModel, GetOrderDetails>> getOrderDetails(
      {required String mealmeId}) async {
    log('${ApiUrls.getOrderDetails}/$mealmeId?userId=$userId');

    final response = await apiServices
        .get('${ApiUrls.getOrderDetails}/$mealmeId?userId=$userId');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(GetOrderDetails.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(GetOrderDetails.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Get Delivery Status ====================================================================

  Future<Either<ErrorModel, SuccessModel>> getDeliveryStatus() async {
    log('${ApiUrls.getDeliveryStatus}/$userId');
    final response =
        await apiServices.get('${ApiUrls.getDeliveryStatus}/$userId');

    if (response.statusCode == 200 || response.statusCode == 201) {
      log('response.body---------->>>>>> ${response.body}');

      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, MenuItemList>> fetchCustomization(String productId,
      {double? latitude, double? longitude}) async {
    Map<String, dynamic> query = {};
    if (latitude != null && longitude != null) {
      query["latitude"] = latitude;
      query["longitude"] = longitude;
    }

    log("${ApiUrls.fetchCustomization}/$productId");
    log("Query Params : $query");
    final response = await apiServices
        .get("${ApiUrls.fetchCustomization}/$productId", queryParams: query);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(
          MenuItemList.fromJson(jsonDecode(response.body)?["data"] ?? {}));
    } else if (response.statusCode == 400) {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, MenuItemList>> getProductCustomization(
      String productId) async {
    final response = await apiServices.post(
        "${ApiUrls.getProductCustomization}/$productId", null);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(
          MenuItemList.fromJson(jsonDecode(response.body)?["data"] ?? {}));
    } else if (response.statusCode == 400) {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  /// Update Delivery Status ====================================================================

  Future<Either<ErrorModel, SuccessModel>> updateDeliveryStatus(
      {bool? pickup}) async {
    final response = await apiServices
        .put('${ApiUrls.updateDeliveryStatus}/$userId?isPickUp=$pickup', {});

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400) {
      return Right(SuccessModel.fromJson(jsonDecode(response.body)));
    } else {
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }

  Future<Either<ErrorModel, PaymentStatusModel>> checkPaymentStatus(
      {String? userId, String? orderId}) async {
    log("Api : ${ApiUrls.checkPaymentStatus}");
    log("Request Data :${jsonEncode({"userId": userId, "orderId": orderId})}");
    final response = await apiServices.get(
      ApiUrls.checkPaymentStatus,
      body: {"userId": userId, "orderId": orderId},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      log(response.body.toString());
      return Right(PaymentStatusModel.fromJson(jsonDecode(response.body)));
    } else {
      log("error  : ========== ==== ============ response : ${response.body.toString()}");
      return Left(ErrorModel.fromJson(jsonDecode(response.body)));
    }
  }
}
