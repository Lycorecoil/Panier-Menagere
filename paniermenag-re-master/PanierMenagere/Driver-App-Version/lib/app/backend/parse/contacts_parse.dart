/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:driver/app/backend/api/api.dart';
import 'package:driver/app/helper/shared_pref.dart';
import 'package:driver/app/util/constant.dart';

class ContactParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ContactParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> saveContact(dynamic param) async {
    return await apiService.postPublic(AppConstants.saveaContacts, param);
  }

  Future<Response> sendToMail(dynamic param) async {
    return await apiService.postPublic(AppConstants.sendMailToAdmin, param);
  }

  String getSupportEmail() {
    return sharedPreferencesManager.getString('supportEmail') ?? '';
  }
}
