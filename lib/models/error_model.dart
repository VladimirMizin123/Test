class ErrorModel {
  bool? success;
  String? title;
  String? message;
  String? errorMessage;
  int? statusCode;
  dynamic data;

  ErrorModel({
    this.success,
    this.title,
    this.message,
    this.errorMessage,
    this.statusCode,
    this.data,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        success: json["success"],
        title: json["title"],
        message: json["message"] ?? '',
        errorMessage: json["errorMessage"] ?? '',
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "title": title,
        "message": message,
        "errorMessage": errorMessage,
        "data": data,
      };
}
