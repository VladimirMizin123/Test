class ErrorModel {
  bool? success;
  String? message;
  String? errorMessage;
  dynamic data;

  ErrorModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
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
