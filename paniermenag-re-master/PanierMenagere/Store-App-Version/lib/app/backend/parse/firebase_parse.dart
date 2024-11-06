/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:vendors/app/backend/api/api.dart';
import 'package:vendors/app/helper/shared_pref.dart';
import 'package:vendors/app/util/constant.dart';

class FirebaseParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  FirebaseParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> loginWithPhoneToken(dynamic param) async {
    return await apiService.postPublic(AppConstants.loginWithMobileToken, param);
  }

  void saveInfo(String token, String uid, String firstName, String lastName, String email, String cover, String phone) {
    sharedPreferencesManager.putString('token', token);
    sharedPreferencesManager.putString('uid', uid);
    sharedPreferencesManager.putString('firstName', firstName);
    sharedPreferencesManager.putString('lastName', lastName);
    sharedPreferencesManager.putString('email', email);
    sharedPreferencesManager.putString('cover', cover);
    sharedPreferencesManager.putString('phone', phone);
  }

  void saveStoreInfo(int id, String storeName, String cover, int storeServiceCity) {
    sharedPreferencesManager.putInt('storeID', id);
    sharedPreferencesManager.putString('storeName', storeName);
    sharedPreferencesManager.putString('storeCover', cover);
    sharedPreferencesManager.putInt('servedIn', storeServiceCity);
  }

  Future<Response> getStoreInfo() async {
    return await apiService.postPrivate(AppConstants.getStoreInfo, {'id': sharedPreferencesManager.getString('uid')}, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> updateProfile(dynamic param) async {
    return await apiService.postPrivate(AppConstants.updateProfile, param, sharedPreferencesManager.getString('token') ?? '');
  }

  String getFcmToken() {
    return sharedPreferencesManager.getString('fcm_token') ?? 'NA';
  }
}
