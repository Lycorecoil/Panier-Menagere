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

class InvoiceListParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  InvoiceListParser({required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getResults(String from, String to) async {
    return await apiService.postPrivate(AppConstants.getStoreStatsWithDate, {'id': sharedPreferencesManager.getString('uid'), 'from': from, 'to': to}, sharedPreferencesManager.getString('token') ?? '');
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

  String storeName() {
    return sharedPreferencesManager.getString('storeName') ?? '';
  }

  String storeAddress() {
    return sharedPreferencesManager.getString('address') ?? '';
  }

  String getMobile() {
    return sharedPreferencesManager.getString('mobile') ?? '';
  }

  String getZipcode() {
    return sharedPreferencesManager.getString('zipcode') ?? '';
  }

  String getEmail() {
    return sharedPreferencesManager.getString('email') ?? '';
  }
}
