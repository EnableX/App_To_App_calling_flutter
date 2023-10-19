import 'dart:convert';

import 'package:enxcalling/controllers/user_list_controller.dart';
import 'package:enxcalling/screens/registration_screen.dart';
import 'package:enxcalling/screens/user_list_screen.dart';
import 'package:enxcalling/utils/app_shared_pref.dart';
import 'package:enxcalling/utils/device_info_helper.dart';
import 'package:enxcalling/utils/fcm_notification/fcm_helper.dart';
import 'package:enxcalling/utils/fcm_notification/local_notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'controllers/call_controller.dart';
import 'data/notification_response.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppSharedPref.init();
  DeviceInfoHelper.initializeDeviceInfo();
  FcmHelper.initFcm();
  LocalNotificationHelper.initializeNotifications();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final obj = Get.put(CallController());
  final userObj = Get.put(UserListController());
  // LocalNotificationHelper.selectNotificationStream.stream.listen((event) {
  //   print('first didsubscription:bg$event');
  //   final obj = Get.put(CallController());
  //   final userObj = Get.put(UserListController());
  //     print('first didsubscription:bg1$event');
  //
  //     var data=json.decode(event!);
  //     userObj.data.value=data;
  //     var notificationData=  NotificationResponse.fromJson(data);
  //     obj.notificationData.value=notificationData;
  //     obj.token.value=notificationData.roomToken!;
  //
  // });

  LocalNotificationHelper.flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails().asStream().listen((event) {
    print('first didsubscription: ${event?.notificationResponse?.payload.toString()}');
    if(event?.notificationResponse?.payload.toString()!=null){
      var data=json.decode("${event?.notificationResponse?.payload}");
      userObj.data.value=data;
      var notificationData=  NotificationResponse.fromJson(data);
      obj.notificationData.value=notificationData;
      obj.token.value=notificationData.roomToken!;
    }
  });
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   String localNumber= AppSharedPref.getLocalNumber() ?? "";
    return GetMaterialApp(
      navigatorKey: Get.key,
      debugShowCheckedModeBanner: false,
      title: 'Flutter GetX Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SafeArea(child: localNumber.isNotEmpty? const UserListScreen():RegistrationScreen()),
    );
  }
}


