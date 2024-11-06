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
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:driver/app/util/constant.dart';

class EditProfileParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  EditProfileParser({required this.apiService, required this.sharedPreferencesManager});

  Future<Response> uploadImage(XFile data) async {
    return await apiService.uploadFiles(AppConstants.uploadImage, [MultipartBody('image', data)]);
  }

  Future<Response> updateProfile(dynamic param) async {
    return await apiService.postPrivate(AppConstants.updateDriverStatus, param, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getProfile() async {
    return await apiService.postPrivate(AppConstants.getProfileInfo, {'id': sharedPreferencesManager.getString('uid')}, sharedPreferencesManager.getString('token') ?? '');
  }

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  void saveInfo(String firstName, String lastName, String cover, String phone) {
    sharedPreferencesManager.putString('firstName', firstName);
    sharedPreferencesManager.putString('lastName', lastName);
    sharedPreferencesManager.putString('cover', cover);
    sharedPreferencesManager.putString('phone', phone);
  }
}
