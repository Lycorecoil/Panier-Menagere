/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:driver/app/backend/models/language_model.dart';
import 'package:driver/app/backend/models/update_status_model.dart';
import 'package:driver/app/env.dart';

class AppConstants {
  static const String appName = Environments.appName;
  static const String companyName = Environments.companyName;
  static const String defaultCurrencyCode = 'USD'; // your currency code in 3 digit
  static const String defaultCurrencySide = 'right'; // default currency position
  static const String defaultCurrencySymbol = '\$'; // default currency symbol
  static const int defaultMakeingOrder = 0; // 0=> from multiple stores // 1 = single store only
  static const String defaultSMSGateway = '1'; // 2 = firebase // 1 = rest
  static const int defaultVerificationForSignup = 0; // 0 = email // 1= phone
  static const int userLogin = 0;
  static const String defaultShippingMethod = 'km';
  static const int driverAssignment = 0; // 0 = manually // 1= auto assign
  static const String defaultLanguageApp = 'en';

  // API Routes
  static const String appSettings = 'api/v1/settings/getDefault';
  static const String activeCities = 'api/v1/cities/getActiveCities';
  static const String login = 'api/v1/auth/loginDrivers';
  static const String uploadImage = 'api/v1/uploadImage';
  static const String verifyPhoneFirebase = 'api/v1/auth/verifyPhoneForFirebaseDriver';
  static const String verifyPhone = 'api/v1/otp/verifyPhoneDriver';
  static const String verifyOTP = 'api/v1/otp/verifyOTP';
  static const String loginWithMobileToken = 'api/v1/auth/loginWithMobileOtpDriver';
  static const String loginWithPhonePassword = 'api/v1/auth/loginWithPhonePasswordDrivers';
  static const String openFirebaseVerification = 'api/v1/auth/firebaseauth?';
  static const String resetWithEmail = 'api/v1/auth/verifyEmailForResetDriver';
  static const String verifyOTPForReset = 'api/v1/otp/verifyOTPResetDriver';
  static const String updatePasswordWithToken = 'api/v1/password/updateUserPasswordWithEmailDriver';
  static const String updatePasswordWithPhoneToken = 'api/v1/password/updateUserPasswordWithPhoneDriver';
  static const String generateTokenFromCreds = 'api/v1/otp/generateTempTokenDriver';
  static const String updatePasswordWithFirebase = 'api/v1/password/updatePasswordFromFirebaseDriver';
  static const String verifyPhoneFirebaseRegister = 'api/v1/auth/verifyPhoneForFirebaseDriverNew';
  static const String verifyEmailForRegister = 'api/v1/join_driver/checkEmail';
  static const String verifyPhoneForRegister = 'api/v1/otp/verifyPhoneDriverNew';
  static const String registerStoreRequest = 'api/v1/join_driver/saveDriver';
  static const String thankyouRegisterMail = 'api/v1/join_store/thankyouReply';
  static const String pageContent = 'api/v1/pages/getContent';
  static const String saveaContacts = 'api/v1/contacts/create';
  static const String sendMailToAdmin = 'api/v1/sendMailToAdmin';
  static const String reviewsList = 'api/v1/ratings/getWithDriverId';
  static const String getMyOrders = 'api/v1/orders/getByDriverIdForApp';
  static const String logout = 'api/v1/driver/logout';
  static const String getOrdersDetailsFromDriverId = 'api/v1/orders/getByIdFromDriver';
  static const String updateOrderStatus = 'api/v1/orders/updateStatusDriver';
  static const String getStoreInfo = 'api/v1/stores/getStoreInfoFromDriver';
  static const String updateDriverStatus = 'api/v1/drivers/edit_myProfile';
  static const String sendNotification = 'api/v1/noti/sendNotification';
  static const String verifyPhoneOTP = 'api/v1/otp/verifyPhone';
  static const String verifyPhoneFirebaseOTP = 'api/v1/auth/verifyPhoneForFirebase';
  static const String getProfileInfo = 'api/v1/driver/byId';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: '', languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: '', languageName: 'عربي', countryCode: 'AE', languageCode: 'ar'),
    LanguageModel(imageUrl: '', languageName: 'हिन्दी', countryCode: 'IN', languageCode: 'hi'),
    LanguageModel(imageUrl: '', languageName: 'Español', countryCode: 'De', languageCode: 'es'),
  ];

  static List<UpdateStatusModel> updateStatus = [UpdateStatusModel(id: 'ongoing', name: 'Ongoing'.tr), UpdateStatusModel(id: 'delivered', name: 'Delivered'.tr)];
}
