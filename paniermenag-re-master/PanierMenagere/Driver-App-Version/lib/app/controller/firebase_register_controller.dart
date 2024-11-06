/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:driver/app/backend/parse/firebase_register_parse.dart';
import 'package:driver/app/controller/register_controller.dart';

class FirebaseRegisterController extends GetxController implements GetxService {
  final FirebaseRegisterParser parser;
  String countryCode = '';
  String phoneNumber = '';
  String apiURL = '';
  bool haveClicked = false;
  FirebaseRegisterController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    apiURL = parser.apiService.appBaseUrl;
    countryCode = Get.arguments[0];
    phoneNumber = Get.arguments[1];
  }

  Future<void> onLogin() async {
    var context = Get.context as BuildContext;
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    Get.find<RegisterController>().verifiedFirebaseCode();
    Navigator.of(context).pop(true);
  }
}
