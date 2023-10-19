// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPref {
  // prevent making instance
  AppSharedPref._();

  // shared pref init
  static SharedPreferences? _sharedPreferences;
  static   MethodChannel? nativeCall;


  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
        nativeCall = const MethodChannel('flutter.native/helper');

  }

  // STORING KEYS
  static const String _fcmTokenKey = 'fcm_token';

  static const String _localNumber = 'local_num';
  static const String _remoteNumber = 'remote_num';
  static const String _callId = 'callId';

  static const String _lightThemeKey = 'is_theme_light';

  /// set theme current type as light theme
  static Future<void> setThemeIsLight(bool lightTheme) =>
      _sharedPreferences!.setBool(_lightThemeKey, lightTheme);

  /// get if the current theme type is light
  static bool getThemeIsLight() =>
      _sharedPreferences!.getBool(_lightThemeKey) ?? true;

  /// save local number
  static void setLocalNumber(String number) =>
      _sharedPreferences!.setString(_localNumber, number);

  static void setRemoteNumber(String number) =>
      _sharedPreferences!.setString(_remoteNumber, number);
  static void setCallId(String number) =>
      _sharedPreferences!.setString(_callId, number);
  /// save generated fcm token
  static Future<void> setFcmToken(String token) =>
      _sharedPreferences!.setString(_fcmTokenKey, token);

  /// get generated fcm token
  static String? getFcmToken() => _sharedPreferences!.getString(_fcmTokenKey);

  static String getLocalNumber()=>_sharedPreferences?.getString(_localNumber)??"";
  static String getRemoteNumber()=>_sharedPreferences?.getString(_remoteNumber)??"";
  static String getCallId()=>_sharedPreferences?.getString(_callId)??"";

  /// clear all data from shared pref except the current language
  // static Future<void> clearExceptLanguage() async {
  //   // Step 1: Retrieve the current language from shared preferences
  //   final currentLanguage = _sharedPreferences!.getString(_currentLocalKey);
  //
  //   // Step 2: Clear all the shared preferences
  //   await _sharedPreferences!.clear();
  //
  //   // Step 3: Set the current language back to the shared preferences
  //   if (currentLanguage != null) {
  //     setCurrentLanguage(currentLanguage);
  //   }
 // }

  /// clear all data from shared pref
  static Future<void> clear() async => await _sharedPreferences!.clear();
}
