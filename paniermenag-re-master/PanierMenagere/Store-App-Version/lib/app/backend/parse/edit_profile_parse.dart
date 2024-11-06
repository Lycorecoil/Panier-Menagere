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
import 'package:image_picker/image_picker.dart';

class EditProfileParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  EditProfileParser({required this.apiService, required this.sharedPreferencesManager});

  Future<Response> uploadImage(XFile data) async {
    return await apiService.uploadFiles(AppConstants.uploadImage, [MultipartBody('image', data)]);
  }

  int getStoreId() {
    return sharedPreferencesManager.getInt('storeID') ?? 0;
  }

  Future<Response> getStoreInfo() async {
    return await apiService.postPrivate(AppConstants.getStoreData, {'id': sharedPreferencesManager.getInt('storeID')}, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> updateStoreData(var param) async {
    return await apiService.postPrivate(AppConstants.updateStoreInfo, param, sharedPreferencesManager.getString('token') ?? '');
  }

  void saveStoreInfo(String storeName, String cover, String address, String zipcode) {
    sharedPreferencesManager.putString('storeName', storeName);
    sharedPreferencesManager.putString('storeCover', cover);
    sharedPreferencesManager.putString('address', address);
    sharedPreferencesManager.putString('zipcode', zipcode);
  }
}
