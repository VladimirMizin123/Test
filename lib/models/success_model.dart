class SuccessModel {
  bool? success;
  String? message;
  String? errorMessage;
  dynamic data;

  SuccessModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory SuccessModel.fromJson(Map<String, dynamic> json) => SuccessModel(
    success: json["success"],
    message: json["message"] ?? '',
    errorMessage: json["errorMessage"] ?? '',
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "errorMessage": errorMessage,
    "data": data,
  };
}
