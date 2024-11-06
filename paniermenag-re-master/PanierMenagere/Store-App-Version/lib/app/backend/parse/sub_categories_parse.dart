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

class SubCategoriesParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  SubCategoriesParser({required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getCategory(var id) async {
    return await apiService.postPrivate(AppConstants.getActiveSubCategory, {'id': id}, sharedPreferencesManager.getString('token') ?? '');
  }
}
