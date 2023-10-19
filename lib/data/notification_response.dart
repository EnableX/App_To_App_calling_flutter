class NotificationResponse {
  String? remotePhoneNumber;
  String? localPhoneNumber;
  String? message;
  String? roomToken;
  String? uuid;
  String? roomId;

  NotificationResponse(
      {this.remotePhoneNumber,
        this.localPhoneNumber,
        this.message,
        this.roomToken,
        this.uuid,
        this.roomId});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    remotePhoneNumber = json['remotePhoneNumber'];
    localPhoneNumber = json['localPhoneNumber'];
    message = json['message'];
    roomToken = json['roomToken'];
    uuid = json['uuid'];
    roomId = json['roomId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['remotePhoneNumber'] = this.remotePhoneNumber;
    data['localPhoneNumber'] = this.localPhoneNumber;
    data['message'] = this.message;
    data['roomToken'] = this.roomToken;
    data['uuid'] = this.uuid;
    data['roomId'] = this.roomId;
    return data;
  }
}