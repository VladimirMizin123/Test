class SignUpModel {
  bool? success;
  String? message;
  dynamic errorMessage;
  UserData? data;

  SignUpModel({
    this.success,
    this.message,
    this.errorMessage,
    this.data,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
    success: json["success"],
    message: json["message"],
    errorMessage: json["errorMessage"],
    data: json["data"] == null ? null : UserData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "errorMessage": errorMessage,
    "data": data?.toJson(),
  };
}

class UserData {
  DateTime? createdOn;
  dynamic uniqueToken;
  dynamic passwordResetToken;
  dynamic resetTokenExpirationTime;
  String? firstName;
  String? lastName;
  String? email;
  bool? isActive;
  bool? isBan;
  String? emailConfirmationToken;
  String? userId;

  UserData({
    this.createdOn,
    this.uniqueToken,
    this.passwordResetToken,
    this.resetTokenExpirationTime,
    this.firstName,
    this.lastName,
    this.email,
    this.isActive,
    this.isBan,
    this.emailConfirmationToken,
    this.userId,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
    uniqueToken: json["uniqueToken"],
    passwordResetToken: json["passwordResetToken"],
    resetTokenExpirationTime: json["resetTokenExirationTime"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    isActive: json["isActive"],
    isBan: json["isBan"],
    emailConfirmationToken: json["emailConfirmatiomToken"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "createdOn": createdOn?.toIso8601String(),
    "uniqueToken": uniqueToken,
    "passwordResetToken": passwordResetToken,
    "resetTokenExirationTime": resetTokenExpirationTime,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "isActive": isActive,
    "isBan": isBan,
    "emailConfirmatiomToken": emailConfirmationToken,
    "userId": userId,
  };
}
