class GetMealLogByDate {
  bool? success;
  dynamic message;
  dynamic errorMessage;
  List<MealDataByDate>? data;

  GetMealLogByDate({this.success, this.message, this.errorMessage, this.data});

  GetMealLogByDate.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    errorMessage = json['errorMessage'];
    if (json['data'] != null) {
      data = <MealDataByDate>[];
      json['data'].forEach((v) {
        data!.add(MealDataByDate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['errorMessage'] = errorMessage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MealDataByDate {
  String? mealName;
  dynamic mealId;
  double? calorie;
  String? mealType;
  int? noOfServing;
  String? recipeId;
  double? protein;
  double? fat;
  double? carbs;
  String? value;
  String? userId;
  User? user;
  String? id;
  dynamic createdBy;
  String? createdOn;
  dynamic updatedBy;
  dynamic updatedOn;
  bool? isActive;
  bool? isDeleted;
  dynamic userCreatedBy;
  dynamic userUpdatedBy;

  MealDataByDate(
      {this.mealName,
      this.mealId,
      this.calorie,
      this.mealType,
      this.noOfServing,
      this.recipeId,
      this.protein,
      this.fat,
      this.carbs,
      this.value,
      this.userId,
      this.user,
      this.id,
      this.createdBy,
      this.createdOn,
      this.updatedBy,
      this.updatedOn,
      this.isActive,
      this.isDeleted,
      this.userCreatedBy,
      this.userUpdatedBy});

  MealDataByDate.fromJson(Map<String, dynamic> json) {
    mealName = json['mealName'];
    mealId = json['mealId'];
    calorie = json['calorie'];
    mealType = json['mealType'];
    noOfServing = json['noOfServing'];
    recipeId = json['recipeId'];
    protein = json['protein'];
    fat = json['fat'];
    carbs = json['carbs'];
    value = json['value'];
    userId = json['userId'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    id = json['id'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    updatedBy = json['updatedBy'];
    updatedOn = json['updatedOn'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    userCreatedBy = json['userCreatedBy'];
    userUpdatedBy = json['userUpdatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['mealName'] = mealName;
    data['mealId'] = mealId;
    data['calorie'] = calorie;
    data['mealType'] = mealType;
    data['noOfServing'] = noOfServing;
    data['recipeId'] = recipeId;
    data['protein'] = protein;
    data['fat'] = fat;
    data['carbs'] = carbs;
    data['value'] = value;
    data['userId'] = userId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['id'] = id;
    data['createdBy'] = createdBy;
    data['createdOn'] = createdOn;
    data['updatedBy'] = updatedBy;
    data['updatedOn'] = updatedOn;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    data['userCreatedBy'] = userCreatedBy;
    data['userUpdatedBy'] = userUpdatedBy;
    return data;
  }
}

class User {
  String? firstName;
  String? lastName;
  dynamic uniqueToken;
  dynamic passwordResetToken;
  dynamic resetTokenExirationTime;
  String? profileImage;
  String? createdOn;
  bool? isActive;
  dynamic createdBy;
  dynamic updatedBy;
  String? suggesticId;
  String? mealPlanEndDate;
  String? lastLogin;
  dynamic referralCode;
  dynamic stripeCustomerId;
  String? userDetailsId;
  dynamic userDetails;
  String? userAddressId;
  dynamic userAddress;
  String? id;
  String? userName;
  String? normalizedUserName;
  String? email;
  String? normalizedEmail;
  bool? emailConfirmed;
  String? passwordHash;
  String? securityStamp;
  String? concurrencyStamp;
  dynamic phoneNumber;
  bool? phoneNumberConfirmed;
  bool? twoFactorEnabled;
  dynamic lockoutEnd;
  bool? lockoutEnabled;
  int? accessFailedCount;

  User(
      {this.firstName,
      this.lastName,
      this.uniqueToken,
      this.passwordResetToken,
      this.resetTokenExirationTime,
      this.profileImage,
      this.createdOn,
      this.isActive,
      this.createdBy,
      this.updatedBy,
      this.suggesticId,
      this.mealPlanEndDate,
      this.lastLogin,
      this.referralCode,
      this.stripeCustomerId,
      this.userDetailsId,
      this.userDetails,
      this.userAddressId,
      this.userAddress,
      this.id,
      this.userName,
      this.normalizedUserName,
      this.email,
      this.normalizedEmail,
      this.emailConfirmed,
      this.passwordHash,
      this.securityStamp,
      this.concurrencyStamp,
      this.phoneNumber,
      this.phoneNumberConfirmed,
      this.twoFactorEnabled,
      this.lockoutEnd,
      this.lockoutEnabled,
      this.accessFailedCount});

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    uniqueToken = json['uniqueToken'];
    passwordResetToken = json['passwordResetToken'];
    resetTokenExirationTime = json['resetTokenExirationTime'];
    profileImage = json['profileImage'];
    createdOn = json['createdOn'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    suggesticId = json['suggesticId'];
    mealPlanEndDate = json['mealPlanEndDate'];
    lastLogin = json['lastLogin'];
    referralCode = json['referralCode'];
    stripeCustomerId = json['stripeCustomerId'];
    userDetailsId = json['userDetailsId'];
    userDetails = json['userDetails'];
    userAddressId = json['userAddressId'];
    userAddress = json['userAddress'];
    id = json['id'];
    userName = json['userName'];
    normalizedUserName = json['normalizedUserName'];
    email = json['email'];
    normalizedEmail = json['normalizedEmail'];
    emailConfirmed = json['emailConfirmed'];
    passwordHash = json['passwordHash'];
    securityStamp = json['securityStamp'];
    concurrencyStamp = json['concurrencyStamp'];
    phoneNumber = json['phoneNumber'];
    phoneNumberConfirmed = json['phoneNumberConfirmed'];
    twoFactorEnabled = json['twoFactorEnabled'];
    lockoutEnd = json['lockoutEnd'];
    lockoutEnabled = json['lockoutEnabled'];
    accessFailedCount = json['accessFailedCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['uniqueToken'] = uniqueToken;
    data['passwordResetToken'] = passwordResetToken;
    data['resetTokenExirationTime'] = resetTokenExirationTime;
    data['profileImage'] = profileImage;
    data['createdOn'] = createdOn;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['suggesticId'] = suggesticId;
    data['mealPlanEndDate'] = mealPlanEndDate;
    data['lastLogin'] = lastLogin;
    data['referralCode'] = referralCode;
    data['stripeCustomerId'] = stripeCustomerId;
    data['userDetailsId'] = userDetailsId;
    data['userDetails'] = userDetails;
    data['userAddressId'] = userAddressId;
    data['userAddress'] = userAddress;
    data['id'] = id;
    data['userName'] = userName;
    data['normalizedUserName'] = normalizedUserName;
    data['email'] = email;
    data['normalizedEmail'] = normalizedEmail;
    data['emailConfirmed'] = emailConfirmed;
    data['passwordHash'] = passwordHash;
    data['securityStamp'] = securityStamp;
    data['concurrencyStamp'] = concurrencyStamp;
    data['phoneNumber'] = phoneNumber;
    data['phoneNumberConfirmed'] = phoneNumberConfirmed;
    data['twoFactorEnabled'] = twoFactorEnabled;
    data['lockoutEnd'] = lockoutEnd;
    data['lockoutEnabled'] = lockoutEnabled;
    data['accessFailedCount'] = accessFailedCount;
    return data;
  }
}
