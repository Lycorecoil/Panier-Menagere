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

class OrderDetailsParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  OrderDetailsParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getOrderDetails(var id) async {
    return await apiService.postPrivate(AppConstants.getOrdersDetailsFromStoreId, {'id': id}, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getDriverInfo(var id) async {
    return await apiService.postPrivate(AppConstants.getDriverInfo, {'id': id}, sharedPreferencesManager.getString('token') ?? '');
  }

  String getCurrencyCode() {
    return sharedPreferencesManager.getString('currencyCode') ?? AppConstants.defaultCurrencyCode;
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

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? '';
  }

  int getAdminId() {
    return sharedPreferencesManager.getInt('supportUID') ?? 0;
  }

  String getAdminName() {
    return sharedPreferencesManager.getString('supportName') ?? '';
  }

  String getStoreName() {
    return sharedPreferencesManager.getString('storeName') ?? '';
  }

  int getDriverAssignment() {
    return sharedPreferencesManager.getInt('driver_assign') ?? 0;
  }

  Future<Response> updateOrderStatus(var param) async {
    return await apiService.postPrivate(AppConstants.updateOrderStatus, param, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> sendNotification(var param) async {
    return await apiService.postPrivate(AppConstants.sendNotification, param, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getDrivers() async {
    return await apiService.postPrivate(AppConstants.getDriversFromCity, {'id': sharedPreferencesManager.getInt('servedIn')}, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> updateDriver(var param) async {
    return await apiService.postPrivate(AppConstants.updateDriverStatus, param, sharedPreferencesManager.getString('token') ?? '');
  }
}
