
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:enxcalling/data/register_device_response.dart';
import 'package:enxcalling/screens/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../utils/app_shared_pref.dart';
import '../utils/constants.dart';
import '../utils/device_info_helper.dart';
import '../utils/fcm_notification/fcm_helper.dart';
import '../utils/request.dart';

class RegistrationController extends GetxController {

  late TextEditingController mobileTextController;
  late TextEditingController nameTextController;
  static const platform = MethodChannel('flutter.native/helper');
  static const EventChannel eventChannel =
  EventChannel('flutter.native/helperCallBacks');
  var tokenValue;
  @override
  void onInit() {
    mobileTextController = TextEditingController();
    nameTextController = TextEditingController();
      super.onInit();

    if (Platform.isIOS) {
      _getTokenFromiOS();
    }
  }

  void _onEvent(Object event) {
    print("");




  }
  Future<void> _getTokenFromiOS() async {

    try {
    var result = await platform.invokeMethod('needToken');
      tokenValue = result;
    } on PlatformException catch (e) {
      tokenValue = "Failed to get token: '${e.message}'.";
    }
    print(tokenValue);
  }
  void apiRegister() async {
    if(Platform.isAndroid) {
      tokenValue = AppSharedPref.getFcmToken();
    }
   var deviceType= DeviceInfoHelper.deviceType;
    Get.dialog(const Center(child: CircularProgressIndicator()),
        barrierDismissible: false);
    Requests request = Requests(url: userUrl, body: {
      'name':nameTextController.text,
      'phone_number': mobileTextController.text,
     'device_token':tokenValue,
     'platform':deviceType

    });
    request.post().then((value) {
      print(value.body);
      Get.back();
      final parsedJson = jsonDecode(value.body);
     var registerData=  RegisterDeviceResponse.fromJson(parsedJson);
      if(registerData.message =="Device already registered"){
        AppSharedPref.setLocalNumber(mobileTextController.text);
        Get.off(() => const UserListScreen());

      }

      else{
        AppSharedPref.setLocalNumber(mobileTextController.text);
        Get.off(() => const UserListScreen());

      }


    }).catchError((onError) {});
  }

  @override
  void onClose() {
    mobileTextController.dispose();
    nameTextController.dispose();
    super.onClose();
  }


}