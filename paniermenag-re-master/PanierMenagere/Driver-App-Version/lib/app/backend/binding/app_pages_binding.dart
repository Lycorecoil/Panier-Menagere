/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:driver/app/controller/app_pages_controller.dart';

class AppPagesBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => AppPagesController(parser: Get.find()));
  }
}
