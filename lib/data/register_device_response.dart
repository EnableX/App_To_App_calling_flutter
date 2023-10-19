class RegisterDeviceResponse {
  String? message;
  String? result;

  RegisterDeviceResponse({this.message, this.result});

  RegisterDeviceResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['result'] = result;
    return data;
  }
}