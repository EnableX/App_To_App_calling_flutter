import 'dart:convert';
import 'dart:io';

import 'package:enx_uikit_flutter/utilities/enx_setting.dart';
import 'package:enxcalling/controllers/user_list_controller.dart';
import 'package:enxcalling/data/notification_response.dart';
import 'package:enxcalling/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../screens/call_screen.dart';
import '../screens/user_list_screen.dart';
import '../utils/app_shared_pref.dart';
import '../utils/device_info_helper.dart';
import '../utils/request.dart';

class CallController extends GetxController{
  static const EventChannel eventChannel =
  EventChannel('flutter.native/helperCallBacks');
  final notificationData = Rxn<NotificationResponse>();
  var token = "".obs;
var role="".obs;

  @override
  void onInit() {

    eventChannel.receiveBroadcastStream().listen((event) {
      if(event!=null) {
        _onEvent(event);
      }
    });
    super.onInit();

  }
  void _onEvent(Object event) {
    print("Test Callback${event.toString()}");
    if (Platform.isIOS) {
      String eventData = event.toString();
      final eventList = eventData.split("-Body:");
      var eventName=eventList.first;
      var data=jsonDecode(eventList.last);
      var remoteNumber=data['remoteNumber'];
      if(eventName=='callAnswer'){
        callAnswersApi(remoteNumber);
      }else if(eventName=='callReject'){
        callRejectApi(localNumber: AppSharedPref.getLocalNumber(),remoteNumber:remoteNumber,callId:AppSharedPref.getCallId());
      }else if(eventName=='callTimeOut'){
      }else if(eventName=='callEnd'){
      }
    }else{
      if(event=="callAnswer"){
        callAnswersApi();
      }else if(event=="callEnd"){
      }else if(event=="callReject"){
        callRejectApi();
      }else if(event=="callTimeOut"){
    }
    }

  }
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void callTimeOutApi(){
    Requests request = Requests(url:"call/:${notificationData.value?.uuid}/$kUnavailable", body: {
      'local_number': notificationData.value?.remotePhoneNumber,
      'remote_number':notificationData.value?.localPhoneNumber
    });
    print(request);
    request.put().then((value) {
      final parsedJson = jsonDecode(value.body);
      Get.back();

    }).catchError((onError) {});
  }
  void callRejectApi({String localNumber="",String remoteNumber="",String callId=""}){
    var callerId= callId.isNotEmpty?callId:notificationData.value?.uuid;
    Requests request = Requests(url:"call/:$callerId/$kReject", body: {
      'local_number': localNumber.isNotEmpty?localNumber:notificationData.value?.remotePhoneNumber,
      'remote_number':remoteNumber.isNotEmpty?remoteNumber:notificationData.value?.localPhoneNumber
    });
    print(request);
    request.put().then((value) {
      final parsedJson = jsonDecode(value.body);
      print(parsedJson);
      Get.offAll(() => const UserListScreen());
      Get.delete<UserListController>(force: true);
      Get.delete<CallController>(force: true);

    }).catchError((onError) {});
  }
  void callAnswersApi([remoteNumber]){
    role.value='participants';
    Requests request;
    if(Platform.isIOS){
      AppSharedPref.getLocalNumber();
      AppSharedPref.getCallId();
      request = Requests(url:"call/:${AppSharedPref.getCallId()}/$kAnswer", body: {
        'local_number': remoteNumber,
        'remote_number':AppSharedPref.getLocalNumber()
      });
    }else{
       request = Requests(url:"call/:${notificationData.value?.uuid}/$kAnswer", body: {
        'local_number': notificationData.value?.remotePhoneNumber,
        'remote_number':notificationData.value?.localPhoneNumber
      });
    }

    print("Answer$request");
    Get.to(() => const CallScreen());
    request.put().then((value) {
    final parsedJson = jsonDecode(value.body);
    print("object$parsedJson");
    token.value=parsedJson['token'];

    }).catchError((onError) {});
  }
  void endCall(){
    AppSharedPref.getRemoteNumber();
    AppSharedPref.getLocalNumber();
    AppSharedPref.getCallId();
    Get.delete<UserListController>(force: true);
    Get.delete<CallController>(force: true);
    Get.offAll(() => const UserListScreen());
  }


}

