class CreateCheckOutRequestModel {
  String? userId;
  String? mealmeOrderId;
  String? priceId;
  List<MealmeItems>? mealmeItems;
  int? phoneNumber;
  int? totalPrice;
  UserCardDetails? userCardDetails;

  CreateCheckOutRequestModel(
      {this.userId,
      this.mealmeOrderId,
      this.priceId,
      this.mealmeItems,
      this.phoneNumber,
      this.totalPrice,
      this.userCardDetails});

  CreateCheckOutRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    mealmeOrderId = json['mealmeOrderId'];
    priceId = json['priceId'];
    if (json['mealmeItems'] != null) {
      mealmeItems = <MealmeItems>[];
      json['mealmeItems'].forEach((v) {
        mealmeItems!.add(MealmeItems.fromJson(v));
      });
    }
    phoneNumber = json['phoneNumber'];
    totalPrice = json['totalPrice'];
    userCardDetails = json['userCardDetails'] != null
        ? UserCardDetails.fromJson(json['userCardDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['mealmeOrderId'] = mealmeOrderId;
    data['priceId'] = priceId;
    if (mealmeItems != null) {
      data['mealmeItems'] = mealmeItems!.map((v) => v.toJson()).toList();
    }
    data['phoneNumber'] = phoneNumber;
    data['totalPrice'] = totalPrice;
    if (userCardDetails != null) {
      data['userCardDetails'] = userCardDetails!.toJson();
    }
    return data;
  }
}

class MealmeItems {
  String? name;
  int? basePrice;
  int? quantity;
  String? image;
  int? markedPrice;
  String? productId;
  String? productType;

  MealmeItems(
      {this.name,
      this.basePrice,
      this.quantity,
      this.image,
      this.markedPrice,
      this.productId,
      this.productType});

  MealmeItems.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    basePrice = json['base_price'];
    quantity = json['quantity'];
    image = json['image'];
    markedPrice = json['marked_price'];
    productId = json['product_id'];
    productType = json['productType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['base_price'] = basePrice;
    data['quantity'] = quantity;
    data['image'] = image;
    data['marked_price'] = markedPrice;
    data['product_id'] = productId;
    data['productType'] = productType;
    return data;
  }
}

class UserCardDetails {
  String? cardNumer;
  int? expirationYear;
  int? expirationMonth;
  String? cvc;

  UserCardDetails(
      {this.cardNumer, this.expirationYear, this.expirationMonth, this.cvc});

  UserCardDetails.fromJson(Map<String, dynamic> json) {
    cardNumer = json['cardNumer'];
    expirationYear = json['expirationYear'];
    expirationMonth = json['expirationMonth'];
    cvc = json['cvc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cardNumer'] = cardNumer;
    data['expirationYear'] = expirationYear;
    data['expirationMonth'] = expirationMonth;
    data['cvc'] = cvc;
    return data;
  }
}
