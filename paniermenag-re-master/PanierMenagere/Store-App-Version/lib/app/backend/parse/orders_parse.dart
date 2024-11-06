/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:vendors/app/backend/api/api.dart';
import 'package:vendors/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:vendors/app/util/constant.dart';

class OrdersParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  OrdersParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getOrder(int limit) async {
    limit = limit * 50;
    return await apiService.postPrivate(AppConstants.getStoreOrders, {'limit': limit, 'id': sharedPreferencesManager.getString('uid')}, sharedPreferencesManager.getString('token') ?? '');
  }

  bool haveLoggedIn() {
    return sharedPreferencesManager.getString('uid') != '' && sharedPreferencesManager.getString('uid') != null ? true : false;
  }

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  String getCurrencySide() {
    return sharedPreferencesManager.getString('currencySide') ?? AppConstants.defaultCurrencySide;
  }

  String getCurrencySymbol() {
    return sharedPreferencesManager.getString('currencySymbol') ?? AppConstants.defaultCurrencySymbol;
  }
}
