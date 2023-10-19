class CallResponse {
  String? message;
  String? result;
  String? callId;

  CallResponse({this.message, this.result,this.callId});

  CallResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    result = json['result'];
    callId = json['call_id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['result'] = result;
    data['call_id'] = callId;

    return data;
  }
}