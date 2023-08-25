class LoginModel {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  LoginData? data;

  LoginModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    success: json["success"],
    message: json["message"],
    errorMessage: json["errorMessage"],
    data: json["data"] == null ? null : LoginData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "errorMessage": errorMessage,
    "data": data?.toJson(),
  };
}

class LoginData {
  Token? token;
  String? userId;
  LoginData({
    this.token,
    this.userId,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    token: json["token"] == null ? null : Token.fromJson(json["token"]),
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "token": token?.toJson(),
    "userId": userId,
  };
}

class Token {
  String? accessToken;
  DateTime? expiresIn;

  Token({
    this.accessToken,
    this.expiresIn,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    accessToken: json["access_token"],
    expiresIn: json["expires_in"] == null ? null : DateTime.parse(json["expires_in"]),
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "expires_in": expiresIn?.toIso8601String(),
  };
}
