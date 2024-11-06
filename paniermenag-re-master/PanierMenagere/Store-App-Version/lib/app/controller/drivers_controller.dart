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
import 'package:vendors/app/backend/models/user_model.dart';
import 'package:vendors/app/backend/parse/driver_parse.dart';
import 'package:vendors/app/controller/order_details_controller.dart';

class DriversController extends GetxController implements GetxService {
  final DriversParser parser;

  List<UserDetailsModel> _driversList = <UserDetailsModel>[];
  List<UserDetailsModel> get driversList => _driversList;

  String selectedDriverId = '';
  DriversController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    _driversList = [];
    _driversList = Get.find<OrderDetailsController>().driversList;
    debugPrint(_driversList.length.toString());
  }

  void saveDriverId(String id) {
    selectedDriverId = id;
    update();
  }

  void onStoreID() {
    var context = Get.context as BuildContext;
    Get.find<OrderDetailsController>().onDriverSave(int.parse(selectedDriverId));
    Navigator.of(context).pop(true);
  }
}
