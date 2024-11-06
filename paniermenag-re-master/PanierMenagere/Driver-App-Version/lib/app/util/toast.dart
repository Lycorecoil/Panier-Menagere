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

void showToast(String message, {bool isError = true}) {
  Get.showSnackbar(
    GetSnackBar(
      backgroundColor: isError ? Colors.red : Colors.black,
      message: message.tr,
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}

void successToast(String message) {
  Get.showSnackbar(
    GetSnackBar(
      backgroundColor: Colors.green,
      message: message.tr,
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}
