class GetUserDetailsById {
  bool? success;
  String? message;
  String? errorMessage;
  Data? data;

  GetUserDetailsById(
      {this.success, this.message, this.errorMessage, this.data});

  GetUserDetailsById.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    errorMessage = json['errorMessage'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['errorMessage'] = errorMessage;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? firstName;
  String? lastName;
  String? phoneNumber;
  dynamic goal;
  String? id;
  String? userId;
  num? weightInLb;
  num? targetWeightInLb;
  String? birthDate;
  num? heightInCm;
  String? gender;

  Data(
      {this.firstName,
      this.lastName,
      this.phoneNumber,
      this.goal,
      this.id,
      this.userId,
      this.weightInLb,
      this.targetWeightInLb,
      this.heightInCm,
      this.birthDate,
      this.gender});

  Data.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    goal = json['goal'];
    id = json['id'];
    userId = json['userId'];
    weightInLb = json['weightInLb'];
    targetWeightInLb = json['targetWeightInLb'];
    heightInCm = json['heightInCm'];
    birthDate = json['birthDate'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phoneNumber'] = phoneNumber;
    data['goal'] = goal;
    data['id'] = id;
    data['userId'] = userId;
    data['weightInLb'] = weightInLb;
    data['targetWeightInLb'] = targetWeightInLb;
    data['heightInCm'] = heightInCm;
    data['birthDate'] = birthDate;
    data['gender'] = gender;
    return data;
  }
}
