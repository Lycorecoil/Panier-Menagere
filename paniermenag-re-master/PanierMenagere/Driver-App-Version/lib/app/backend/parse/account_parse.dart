/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:driver/app/backend/api/api.dart';
import 'package:driver/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:driver/app/util/constant.dart';

class AccountParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  AccountParser({required this.apiService, required this.sharedPreferencesManager});

  String getName() {
    String firstName = sharedPreferencesManager.getString('firstName') ?? '';
    String lastName = sharedPreferencesManager.getString('lastName') ?? '';
    return '$firstName $lastName';
  }

  String getEmail() {
    return sharedPreferencesManager.getString('email') ?? '';
  }

  String getCover() {
    return sharedPreferencesManager.getString('storeCover') ?? '';
  }

  Future<Response> logout() async {
    return await apiService.logout(AppConstants.logout, sharedPreferencesManager.getString('token') ?? '');
  }

  void clearAccount() {
    sharedPreferencesManager.clearKey('firstName');
    sharedPreferencesManager.clearKey('lastName');
    sharedPreferencesManager.clearKey('token');
    sharedPreferencesManager.clearKey('uid');
    sharedPreferencesManager.clearKey('email');
    sharedPreferencesManager.clearKey('storeID');
    sharedPreferencesManager.clearKey('storeName');
    sharedPreferencesManager.clearKey('storeCover');
    sharedPreferencesManager.clearKey('servedIn');
  }
}
