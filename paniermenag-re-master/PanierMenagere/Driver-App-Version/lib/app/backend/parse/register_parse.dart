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
import 'package:driver/app/util/constant.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  RegisterParser({required this.apiService, required this.sharedPreferencesManager});

  String getSMSName() {
    return sharedPreferencesManager.getString('smsName') ?? AppConstants.defaultSMSGateway;
  }

  Future<Response> uploadImage(XFile data) async {
    return await apiService.uploadFiles(AppConstants.uploadImage, [MultipartBody('image', data)]);
  }

  Future<Response> getActiveCities() async {
    return await apiService.getPublic(AppConstants.activeCities);
  }

  Future<Response> verifyPhoneWithFirebase(dynamic param) async {
    return await apiService.postPublic(AppConstants.verifyPhoneFirebaseRegister, param);
  }

  Future<Response> verifyEmailForRegister(dynamic param) async {
    return await apiService.postPublic(AppConstants.verifyEmailForRegister, param);
  }

  Future<Response> verifyPhone(dynamic param) async {
    return await apiService.postPublic(AppConstants.verifyPhoneForRegister, param);
  }

  Future<Response> verifyOTP(dynamic param) async {
    return await apiService.postPublic(AppConstants.verifyOTP, param);
  }

  Future<Response> registerStoreRequest(dynamic param) async {
    return await apiService.postPublic(AppConstants.registerStoreRequest, param);
  }

  Future<Response> thankyouMail(dynamic param) async {
    return await apiService.postPublic(AppConstants.thankyouRegisterMail, param);
  }
}
