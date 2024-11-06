/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:driver/app/controller/login_controller.dart';
import 'package:driver/app/helper/router.dart';
import 'package:driver/app/util/toast.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      showToast('Session expired!'.tr);
      Get.find<LoginController>().cleanLoginCreds();
      Get.offAndToNamed(AppRouter.getLoginRoute());
    } else {
      showToast(response.statusText.toString().tr);
    }
  }
}
