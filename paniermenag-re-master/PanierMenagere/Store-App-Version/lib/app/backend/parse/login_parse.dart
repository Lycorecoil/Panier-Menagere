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

class LoginParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  LoginParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> loginPost(dynamic param) async {
    return await apiService.postPublic(AppConstants.login, param);
  }

  Future<Response> verifyPhoneWithFirebase(dynamic param) async {
    return await apiService.postPublic(AppConstants.verifyPhoneFirebase, param);
  }

  Future<Response> verifyPhone(dynamic param) async {
    return await apiService.postPublic(AppConstants.verifyPhone, param);
  }

  Future<Response> verifyOTP(dynamic param) async {
    return await apiService.postPublic(AppConstants.verifyOTP, param);
  }

  Future<Response> loginWithPhoneToken(dynamic param) async {
    return await apiService.postPublic(AppConstants.loginWithMobileToken, param);
  }

  Future<Response> loginWithPhonePasswordPost(dynamic param) async {
    return await apiService.postPublic(AppConstants.loginWithPhonePassword, param);
  }

  Future<Response> getStoreInfo() async {
    return await apiService.postPrivate(AppConstants.getStoreInfo, {'id': sharedPreferencesManager.getString('uid')}, sharedPreferencesManager.getString('token') ?? '');
  }

  String getSMSName() {
    return sharedPreferencesManager.getString('smsName') ?? AppConstants.defaultSMSGateway;
  }

  int getUserLoginMethod() {
    return sharedPreferencesManager.getInt('userLogin') ?? AppConstants.userLogin;
  }

  void saveStoreInfo(int id, String storeName, String cover, int storeServiceCity, String address, String zipcode, String mobile) {
    sharedPreferencesManager.putInt('storeID', id);
    sharedPreferencesManager.putString('storeName', storeName);
    sharedPreferencesManager.putString('storeCover', cover);
    sharedPreferencesManager.putInt('servedIn', storeServiceCity);
    sharedPreferencesManager.putString('address', address);
    sharedPreferencesManager.putString('mobile', mobile);
    sharedPreferencesManager.putString('zipcode', zipcode);
  }
  //

  void saveInfo(String token, String uid, String firstName, String lastName, String email, String cover, String phone) {
    sharedPreferencesManager.putString('token', token);
    sharedPreferencesManager.putString('uid', uid);
    sharedPreferencesManager.putString('firstName', firstName);
    sharedPreferencesManager.putString('lastName', lastName);
    sharedPreferencesManager.putString('email', email);
    sharedPreferencesManager.putString('cover', cover);
    sharedPreferencesManager.putString('phone', phone);
  }

  Future<Response> updateProfile(dynamic param) async {
    return await apiService.postPrivate(AppConstants.updateProfile, param, sharedPreferencesManager.getString('token') ?? '');
  }

  String getFcmToken() {
    return sharedPreferencesManager.getString('fcm_token') ?? 'NA';
  }
}
