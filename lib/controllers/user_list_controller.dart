import 'dart:convert';

import 'package:enxcalling/data/call_response.dart';
import 'package:enxcalling/data/user_list_response.dart';
import 'package:enxcalling/utils/app_shared_pref.dart';
import 'package:flutter/material.dart';

import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../screens/call_screen.dart';
import '../utils/constants.dart';
import '../utils/device_info_helper.dart';
import '../utils/request.dart';

class UserListController extends GetxController{
  List<Contact>? _contacts;
  var permissionDenied = false.obs;
  var deviceContacts = <Result>[].obs;
  var position=0.obs;
  var callType=0.obs;
  var uuid;
  var isNotification=false;
 var data={}.obs;

  void getUserList() async {
    Requests request = Requests(url: userUrl);
    request.get().then((value) {
      final parsedJson = jsonDecode(value.body);
      var registerData=  UserListResponse.fromJson(parsedJson);
      deviceContacts.value=registerData.result!;
      deviceContacts.value.removeWhere(((item)=>item.phoneNumber == AppSharedPref.getLocalNumber()));
      deviceContacts.refresh();

    }).catchError((onError) {});
  }

void initCallKit() async{
   await AppSharedPref.nativeCall?.invokeMethod('initCallKit');
}
  void callStartApi(int i, int type){
    position.value=i;
    callType.value=type;
    String? remoteNumber=deviceContacts[i].phoneNumber;
    String callId=uuid.v1();
    var deviceId= DeviceInfoHelper.deviceID;
    Requests request = Requests(url: kCall, body: {
      'call_id':deviceId,
      'local_number': AppSharedPref.getLocalNumber(),
      'remote_number':remoteNumber
    });

    request.post().then((value) {
      final parsedJson = jsonDecode(value.body);
     // print("object$parsedJson");
      var registerData=  CallResponse.fromJson(parsedJson);
     if(registerData.message =="call-initiated") {
       AppSharedPref.setRemoteNumber(remoteNumber!);
       AppSharedPref.setCallId(deviceId!);
       Get.to(() => CallScreen());
     }else{
       Fluttertoast.showToast(
           msg: "${registerData.message}",
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.CENTER,
           backgroundColor: Colors.red,
           textColor: Colors.white,
           fontSize: 16.0);
     }
    }).catchError((onError) {

    });
  }

  @override
  void onInit() {
     uuid = Uuid();
  //  _fetchContacts();
    getUserList();
  }

  @override
  void onReady() {

    super.onReady();
  }
  @override
  void onClose() {
    super.onClose();
  }


}
