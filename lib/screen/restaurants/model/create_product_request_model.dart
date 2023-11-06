class CreateProductRequestModel {
  String? userId;
  List<ProductMealmeItems>? mealmeItems;
  String? orderId;
  int? totalAmount;

  CreateProductRequestModel(
      {this.userId, this.mealmeItems, this.orderId, this.totalAmount});

  CreateProductRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    if (json['mealmeItems'] != null) {
      mealmeItems = <ProductMealmeItems>[];
      json['mealmeItems'].forEach((v) {
        mealmeItems!.add(ProductMealmeItems.fromJson(v));
      });
    }
    orderId = json['orderId'];
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    if (mealmeItems != null) {
      data['mealmeItems'] = mealmeItems!.map((v) => v.toJson()).toList();
    }
    data['orderId'] = orderId;
    data['totalAmount'] = totalAmount;
    return data;
  }
}

class ProductMealmeItems {
  String? name;
  int? basePrice;
  int? quantity;
  String? image;
  int? markedPrice;
  String? productId;
  String? productType;

  ProductMealmeItems(
      {this.name,
      this.basePrice,
      this.quantity,
      this.image,
      this.markedPrice,
      this.productId,
      this.productType});

  ProductMealmeItems.fromJson(Map<String, dynamic> json) {
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
