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
import 'package:driver/app/backend/api/handler.dart';
import 'package:driver/app/backend/parse/account_parse.dart';
import 'package:driver/app/helper/router.dart';
import 'package:driver/app/util/theme.dart';

class AccountController extends GetxController implements GetxService {
  final AccountParser parser;
  String name = '';
  String email = '';
  String cover = '';
  AccountController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    name = parser.getName();
    email = parser.getEmail();
    cover = parser.getCover();
  }

  void changeInfo() {
    name = parser.getName();
    email = parser.getEmail();
    cover = parser.getCover();
    update();
  }

  Future<void> logout() async {
    Get.dialog(
      SimpleDialog(
        children: [
          Row(
            children: [
              const SizedBox(width: 30),
              const CircularProgressIndicator(color: ThemeProvider.appColor),
              const SizedBox(width: 30),
              SizedBox(child: Text("Please wait".tr, style: const TextStyle(fontFamily: 'bold'))),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );
    Response response = await parser.logout();
    Get.back();
    if (response.statusCode == 200) {
      parser.clearAccount();
      Get.offNamed(AppRouter.getLoginRoute());
      update();
    } else {
      Get.offNamed(AppRouter.getLoginRoute());
      ApiChecker.checkApi(response);
    }
    update();
  }
}
