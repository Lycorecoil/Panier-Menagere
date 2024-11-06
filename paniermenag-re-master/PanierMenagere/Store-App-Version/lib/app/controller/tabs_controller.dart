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
import 'package:vendors/app/backend/parse/tabs_parse.dart';

class TabsBottomController extends GetxController with GetSingleTickerProviderStateMixin implements GetxService {
  final TabsParser parser;

  int tabId = 0;
  late TabController tabController;
  TabsBottomController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this, initialIndex: tabId);
  }

  void updateTabId(int id) {
    tabId = id;
    tabController.animateTo(tabId);
    update();
  }

  void cleanLoginCreds() {
    parser.cleanLoginData();
  }
}
