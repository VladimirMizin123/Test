class SignUpModel {
  bool? success;
  String? message;
  String? errorMessage;
  Data? data;

  SignUpModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
    success: json["success"],
    message: json["message"]?? '',
    errorMessage: json["errorMessage"] ?? '',
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "errorMessage": errorMessage,
    "data": data?.toJson(),
  };
}

class Data {
  Token? token;

  Data({
    this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"] == null ? null : Token.fromJson(json["token"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token?.toJson(),
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
