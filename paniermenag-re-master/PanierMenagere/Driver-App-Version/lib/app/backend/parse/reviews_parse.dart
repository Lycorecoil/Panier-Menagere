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
import 'package:get/get.dart';
import 'package:driver/app/util/constant.dart';

class ReviewsParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ReviewsParser({required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getReviews() async {
    return await apiService.postPrivate(AppConstants.reviewsList, {'id': sharedPreferencesManager.getString('uid')}, sharedPreferencesManager.getString('token') ?? '');
  }
}
