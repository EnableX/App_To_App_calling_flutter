class UserListResponse {
  String? message;
  List<Result>? result;

  UserListResponse({this.message, this.result});

  UserListResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Result {
  String? sId;
  String? name;
  String? phoneNumber;
  String? token;
  String? platform;

  Result({this.sId, this.name, this.phoneNumber, this.token, this.platform});

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    token = json['token'];
    platform = json['platform'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['phone_number'] = this.phoneNumber;
    data['token'] = this.token;
    data['platform'] = this.platform;
    return data;
  }
}



