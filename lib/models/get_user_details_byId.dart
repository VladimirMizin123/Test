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
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['errorMessage'] = this.errorMessage;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? firstName;
  String? lastName;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['goal'] = this.goal;
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['weightInLb'] = this.weightInLb;
    data['targetWeightInLb'] = this.targetWeightInLb;
    data['heightInCm'] = this.heightInCm;
    data['birthDate'] = this.birthDate;
    data['gender'] = this.gender;
    return data;
  }
}
