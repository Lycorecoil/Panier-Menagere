/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:vendors/app/controller/account_controller.dart';
import 'package:vendors/app/controller/orders_controller.dart';
import 'package:vendors/app/controller/products_controller.dart';
import 'package:vendors/app/controller/store_stats_controller.dart';
import 'package:vendors/app/controller/tabs_controller.dart';

class TabsBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => TabsBottomController(parser: Get.find()));
    Get.lazyPut(() => AccountController(parser: Get.find()));
    Get.lazyPut(() => OrdersController(parser: Get.find()));
    Get.lazyPut(() => StoreStatsController(parser: Get.find()));
    Get.lazyPut(() => ProductsController(parser: Get.find()));
  }
}
