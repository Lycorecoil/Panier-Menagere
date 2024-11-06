/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:vendors/app/backend/models/languages_model.dart';
import 'package:vendors/app/backend/models/update_status_model.dart';
import 'package:vendors/app/env.dart';

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
  static const String login = 'api/v1/auth/login';
  static const String verifyPhoneFirebase = 'api/v1/auth/verifyPhoneForFirebase';
  static const String verifyPhone = 'api/v1/otp/verifyPhone';
  static const String verifyOTP = 'api/v1/otp/verifyOTP';
  static const String loginWithMobileToken = 'api/v1/auth/loginWithMobileOtp';
  static const String loginWithPhonePassword = 'api/v1/auth/loginWithPhonePassword';
  static const String openFirebaseVerification = 'api/v1/auth/firebaseauth?';
  static const String verifyPhoneForRegister = 'api/v1/otp/verifyPhoneNew';
  static const String verifyPhoneFirebaseRegister = 'api/v1/auth/verifyPhoneForFirebaseNew';
  static const String verifyEmailForRegister = 'api/v1/join_store/checkEmail';
  static const String uploadImage = 'api/v1/uploadImage';
  static const String thankyouRegisterMail = 'api/v1/join_store/thankyouReply';
  static const String registerStoreRequest = 'api/v1/join_store/saveStore';
  static const String logout = 'api/v1/auth/logout';
  static const String getStoreInfo = 'api/v1/profile/getStoreFromId';
  static const String resetWithEmail = 'api/v1/auth/verifyEmailForReset';
  static const String verifyOTPForReset = 'api/v1/otp/verifyOTPReset';
  static const String updatePasswordWithToken = 'api/v1/password/updateUserPasswordWithEmail';
  static const String updatePasswordWithPhoneToken = 'api/v1/password/updateUserPasswordWithPhone';
  static const String generateTokenFromCreds = 'api/v1/otp/generateTempToken';
  static const String updatePasswordWithFirebase = 'api/v1/password/updatePasswordFromFirebase';
  static const String getStoreOrders = 'api/v1/orders/getByStoreForApps';
  static const String getOrderDetails = 'api/v1/orders/getByOrderId';
  static const String updateOrderStatus = 'api/v1/orders/updateStatusStore';
  static const String getDriversFromCity = 'api/v1/drivers/geyByCity';
  static const String getOrdersDetailsFromStoreId = 'api/v1/orders/getByIdFromStore';
  static const String storeOrderInvoice = 'api/v1/orders/printStoreInvoice?id=';
  static const String updateDriverStatus = 'api/v1/drivers/edit_profile';
  static const String sendNotification = 'api/v1/notification/sendNotification';
  static const String getStoreStats = 'api/v1/orders/getStoreStatsData';
  static const String getStoreStatsWithDate = 'api/v1/orders/getStoreStatsDataWithDates';
  static const String pageContent = 'api/v1/pages/getContent';
  static const String getChatConversionList = 'api/v1/chats/getChatListBUid';
  static const String getChatRooms = 'api/v1/chats/getChatRooms';
  static const String createChatRooms = 'api/v1/chats/createChatRooms';
  static const String getChatList = 'api/v1/chats/getById';
  static const String sendMessage = 'api/v1/chats/sendMessage';
  static const String saveaContacts = 'api/v1/contacts/create';
  static const String sendMailToAdmin = 'api/v1/sendMailToAdmin';
  static const String getProducts = 'api/v1/products/getByStoreIdStoreAll';
  static const String searchQuery = 'api/v1/products/searchQuery';
  static const String getActiveCategory = 'api/v1/categories/getActiveItem';
  static const String getActiveSubCategory = 'api/v1/subcate/getByCId';
  static const String createProduct = 'api/v1/products/saveProduct';
  static const String getProductById = 'api/v1/products/getByIdStore';
  static const String updateProduct = 'api/v1/products/updateProducts';
  static const String reviewsList = 'api/v1/ratings/getWithStoreId';
  static const String getStoreData = 'api/v1/stores/getByIds';
  static const String updateStoreInfo = 'api/v1/stores/updateDetails';
  static const String getDriverInfo = 'api/v1/driverInfo/byId';
  static const String updateProfile = 'api/v1/profile/update';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: '', languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: '', languageName: 'عربي', countryCode: 'AE', languageCode: 'ar'),
    LanguageModel(imageUrl: '', languageName: 'हिन्दी', countryCode: 'IN', languageCode: 'hi'),
    LanguageModel(imageUrl: '', languageName: 'Español', countryCode: 'De', languageCode: 'es'),
  ];

  static List<UpdateStatusModel> updateStatus = [
    UpdateStatusModel(id: 'ongoing', name: 'Ongoing'.tr),
    UpdateStatusModel(id: 'cancelled', name: 'Cancel'.tr),
    UpdateStatusModel(id: 'delivered', name: 'Delivered'.tr),
    UpdateStatusModel(id: 'rejected', name: 'Reject'.tr)
  ];
}
