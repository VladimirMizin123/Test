class SubscriptionStatusModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  String? data;

  SubscriptionStatusModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory SubscriptionStatusModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionStatusModel(
        success: json["success"],
        message: json["message"],
        errorMessage: json["errorMessage"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "errorMessage": errorMessage,
        "data": data,
      };
}
