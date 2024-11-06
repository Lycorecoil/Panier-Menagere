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

class OrderDetailsParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  OrderDetailsParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getOrderDetails(var id) async {
    return await apiService.postPrivate(AppConstants.getOrdersDetailsFromDriverId, {'id': id}, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getStorInfo(var id) async {
    return await apiService.postPrivate(AppConstants.getStoreInfo, {'id': id}, sharedPreferencesManager.getString('token') ?? '');
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

  int getDelivery() {
    return sharedPreferencesManager.getInt('delivery') ?? 0;
  }

  String getAdminName() {
    return sharedPreferencesManager.getString('supportName') ?? '';
  }

  String getDriverName() {
    String firstName = sharedPreferencesManager.getString('firstName') ?? '';
    String lastName = sharedPreferencesManager.getString('lastName') ?? '';
    return '$firstName $lastName';
  }

  int getDriverAssignment() {
    return sharedPreferencesManager.getInt('driver_assign') ?? 0;
  }

  String getSMSName() {
    return sharedPreferencesManager.getString('smsName') ?? AppConstants.defaultSMSGateway;
  }

  Future<Response> updateOrderStatus(var param) async {
    return await apiService.postPrivate(AppConstants.updateOrderStatus, param, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> sendNotification(var param) async {
    return await apiService.postPrivate(AppConstants.sendNotification, param, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> updateDriver(var param) async {
    return await apiService.postPrivate(AppConstants.updateDriverStatus, param, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> verifyPhoneWithFirebase(dynamic param) async {
    return await apiService.postPublic(AppConstants.verifyPhoneFirebaseOTP, param);
  }

  Future<Response> verifyPhone(dynamic param) async {
    return await apiService.postPublic(AppConstants.verifyPhoneOTP, param);
  }

  Future<Response> verifyOTP(dynamic param) async {
    return await apiService.postPublic(AppConstants.verifyOTP, param);
  }
}
