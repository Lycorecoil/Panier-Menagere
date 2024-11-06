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

class ManageProductParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ManageProductParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> uploadImage(XFile data) async {
    return await apiService.uploadFiles(AppConstants.uploadImage, [MultipartBody('image', data)]);
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

  Future<Response> createProduct(var param) async {
    return await apiService.postPrivate(AppConstants.createProduct, param, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> updateProduct(var param) async {
    return await apiService.postPrivate(AppConstants.updateProduct, param, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getProductInfo(var id) async {
    return await apiService.postPrivate(AppConstants.getProductById, {'id': id}, sharedPreferencesManager.getString('token') ?? '');
  }
}
