/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendors/app/backend/api/handler.dart';
import 'package:vendors/app/backend/models/general_model.dart';
import 'package:vendors/app/backend/models/languages_model.dart';
import 'package:vendors/app/backend/models/settings_model.dart';
import 'package:vendors/app/backend/models/support_model.dart';
import 'package:vendors/app/backend/parse/splash_parse.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SplashController extends GetxController implements GetxService {
  final SplashParser parser;

  late LanguageModel _defaultLanguage;
  LanguageModel get defaultLanguage => _defaultLanguage;

  late SettingsModel _settingsModel;
  SettingsModel get settinsModel => _settingsModel;

  late SupportModel _supportModel;
  SupportModel get supportModel => _supportModel;

  bool _firstTimeConnectionCheck = true;
  var defaultCode = 'en';
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

  SplashController({required this.parser});

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  @override
  void onInit() {
    super.onInit();
    if (!kIsWeb) {
      checkNotificationPermission();
      // FirebaseMessaging.instance.getToken().then((value) {
      //   debugPrint(value.toString());
      //   parser.saveDeviceToken(value.toString());
      // });
    }
  }

  Future<void> checkNotificationPermission() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    firebaseMessaging.getToken().then((value) async {
      String? token = value;
      parser.saveDeviceToken(value.toString());
      // Response response = await parser.saveDeviceToken(token);
      // debugPrint(response.bodyString);
      debugPrint('/////////////////////////');
      debugPrint(token);
      debugPrint('/////////////////////////');
    });
  }

  Future<bool> getConfigData() async {
    Response response = await parser.getAppSettings();
    bool isSuccess = false;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['data'] != null) {
        dynamic body = myMap["data"];
        SettingsModel appSettingsInfo = SettingsModel.fromJson(body['settings']);
        GeneralModel generalModelInfo = GeneralModel.fromJson(body['general']);
        _settingsModel = appSettingsInfo;

        SupportModel supportModelInfo = SupportModel.fromJson(body['support']);
        _supportModel = supportModelInfo;

        parser.saveBasicInfo(
            appSettingsInfo.findType,
            appSettingsInfo.currencyCode,
            appSettingsInfo.currencySide,
            appSettingsInfo.currencySymbol,
            appSettingsInfo.makeOrders,
            appSettingsInfo.smsName,
            appSettingsInfo.userVerifyWith,
            appSettingsInfo.storeLogin,
            generalModelInfo.email,
            generalModelInfo.name,
            generalModelInfo.min,
            generalModelInfo.shipping,
            generalModelInfo.shippingPrice,
            generalModelInfo.tax,
            generalModelInfo.free,
            appSettingsInfo.logo,
            '${supportModelInfo.firstName!} ${supportModelInfo.lastName!}',
            supportModelInfo.id,
            appSettingsInfo.resetPwd,
            appSettingsInfo.driverAssign);
      }
      isSuccess = true;
    } else {
      ApiChecker.checkApi(response);
      isSuccess = false;
    }
    update();
    return isSuccess;
  }

  Future<bool> initSharedData() {
    return parser.initAppSettings();
  }

  bool showIntro() {
    return parser.showSplash();
  }

  void setIntro(bool intro) {
    parser.setIntro(intro);
  }

  String getLanguageCode() {
    return parser.getLanguagesCode();
  }
}
