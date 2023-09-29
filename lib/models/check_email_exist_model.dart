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
  bool? isEmailExist;

  Data({this.isEmailExist});

  Data.fromJson(Map<String, dynamic> json) {
    isEmailExist = json['isEmailExist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isEmailExist'] = this.isEmailExist;
    return data;
  }
}
