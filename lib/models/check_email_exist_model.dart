class CheckEmailExist {
  bool? success;
  String? message;
  String? errorMessage;
  Data? data;

  CheckEmailExist({this.success, this.message, this.errorMessage, this.data});

  CheckEmailExist.fromJson(Map<String, dynamic> json) {
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
  bool? isEmailExist;

  Data({this.isEmailExist});

  Data.fromJson(Map<String, dynamic> json) {
    isEmailExist = json['isEmailExist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isEmailExist'] = isEmailExist;
    return data;
  }
}
