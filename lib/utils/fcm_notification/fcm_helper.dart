import 'dart:convert';

import 'package:enxcalling/controllers/call_controller.dart';
import 'package:enxcalling/controllers/user_list_controller.dart';
import 'package:enxcalling/data/notification_response.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logger/logger.dart';

import '../../main.dart';
import '../../screens/call_screen.dart';
import '../app_shared_pref.dart';
import 'local_notification_helper.dart';

class FcmHelper {
  // prevent making instance
  FcmHelper._();

  // FCM Messaging
  static late FirebaseMessaging messaging;
  /// this function will initialize firebase and fcm instance
  static Future<void> initFcm() async {
    try {
      // initialize fcm and firebase core
      await Firebase.initializeApp(
        // TODO: uncomment this line if you connected to firebase via cli
        // options: DefaultFirebaseOptions.currentPlatform,
      );

      // initialize firebase
      messaging = FirebaseMessaging.instance;

      // notification settings handler
      await _setupFcmNotificationSettings();

      // generate token if it not already generated and store it on shared pref
      await _generateFcmToken();

      // background and foreground handlers
      FirebaseMessaging.onMessage.listen(fcmForegroundHandler);
      //FirebaseMessaging.onMessageOpenedApp.listen(fcmBackgroundHandler);
      FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
    } catch (error) {
      Logger().e(error);
    }
  }

  ///handle fcm notification settings (sound,badge..etc)
  static Future<void> _setupFcmNotificationSettings() async {
    //show notification with sound and badge
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );

    //NotificationSettings settings
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );
  }

  /// generate and save fcm token if its not already generated (generate only for 1 time)
  static Future<void> _generateFcmToken() async {
    try {
      var token = await messaging.getToken();
      if (token != null) {
        print("token $token");
       AppSharedPref.setFcmToken(token);
        _sendFcmTokenToServer();
      } else {
        // retry generating token
        await Future.delayed(const Duration(seconds: 5));
        _generateFcmToken();
      }
    } catch (error) {
      Logger().e(error.toString());
    }
  }

  static _sendFcmTokenToServer() {
   // var token = MySharedPref.getFcmToken();
    // TODO SEND FCM TOKEN TO SERVER
  }


  @pragma('vm:entry-point')
  static Future<void> fcmOpenAppHandler(RemoteMessage message) async {
    // Put here your logic //
    // ex: you can call any function that fetch all notification to display in UI

    Logger().i("aswd${message.data}");
  }
  @pragma('vm:entry-point')
  static Future<void> fcmBackgroundHandler(RemoteMessage message) async {
    // Put here your logic //
    // ex: you can call any function that fetch all notification to display in UI
    //end//
    CallController enxController;
    bool isRegister = Get.isRegistered<CallController>();
    if(isRegister){
      enxController = Get.find<CallController>();
    }else{
      enxController = Get.put(CallController());
    }
    UserListController enxUserController = Get.put(UserListController());
    var notificationData=  NotificationResponse.fromJson(message.data);
     enxController.notificationData.value=notificationData;

    LocalNotificationHelper.showNotification(
        title: message.notification?.title ?? 'Incoming Call',
        body: message.notification?.body ?? '${enxController.notificationData.value?.localPhoneNumber}',
        payload: json.encode(message.data)
    );

    if(enxController.notificationData.value?.message=="call rejected"){
      Get.back();
      enxController.refresh();    }


  }

  //handle fcm notification when app is open
  static Future<void> fcmForegroundHandler(RemoteMessage message) async {
    // Put here your logic //
    // ex: you can call any function that fetch all notification to display in UI
    //end//
    print("object${message.data}");
    CallController enxController;
    bool isRegister = Get.isRegistered<CallController>();
    if(isRegister){
      enxController = Get.find<CallController>();
    }else{
      enxController = Get.put(CallController());
    }

    var notificationData=  NotificationResponse.fromJson(message.data);

    enxController.notificationData.value=notificationData;
    enxController.token.value=notificationData.roomToken!;
    Logger().i(enxController.token.value);
    if(enxController.notificationData.value?.message=="call-initiated") {
      AppSharedPref.nativeCall?.invokeMethod('initCallKit');
    }
    if(enxController.notificationData.value?.message=="call rejected"){
      Get.back();
      enxController.refresh();

    }

  }
}