/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:driver/app/backend/binding/account_binding.dart';
import 'package:driver/app/backend/binding/app_pages_binding.dart';
import 'package:driver/app/backend/binding/contact_binding.dart';
import 'package:driver/app/backend/binding/edit_profile_binding.dart';
import 'package:driver/app/backend/binding/firebase_biding.dart';
import 'package:driver/app/backend/binding/firebase_delivery_binding.dart';
import 'package:driver/app/backend/binding/firebase_register_binding.dart';
import 'package:driver/app/backend/binding/firebase_reset_password_binding.dart';
import 'package:driver/app/backend/binding/intro_binding.dart';
import 'package:driver/app/backend/binding/language_binding.dart';
import 'package:driver/app/backend/binding/login_binding.dart';
import 'package:driver/app/backend/binding/order_details_binding.dart';
import 'package:driver/app/backend/binding/orders_binding.dart';
import 'package:driver/app/backend/binding/register_binding.dart';
import 'package:driver/app/backend/binding/reset_password_binding.dart';
import 'package:driver/app/backend/binding/reviews_binding.dart';
import 'package:driver/app/backend/binding/splash_binding.dart';
import 'package:driver/app/backend/binding/tabs_binding.dart';
import 'package:driver/app/backend/binding/tracking_binding.dart';
import 'package:driver/app/backend/binding/update_firebase_password_binding.dart';
import 'package:driver/app/view/account.dart';
import 'package:driver/app/view/app_pages.dart';
import 'package:driver/app/view/contacts.dart';
import 'package:driver/app/view/edit_profile.dart';
import 'package:driver/app/view/error.dart';
import 'package:driver/app/view/firebase.dart';
import 'package:driver/app/view/firebase_delivery.dart';
import 'package:driver/app/view/firebase_register.dart';
import 'package:driver/app/view/firebase_reset.dart';
import 'package:driver/app/view/intro.dart';
import 'package:driver/app/view/languages.dart';
import 'package:driver/app/view/login.dart';
import 'package:driver/app/view/order_details.dart';
import 'package:driver/app/view/orders.dart';
import 'package:driver/app/view/register.dart';
import 'package:driver/app/view/reset_password.dart';
import 'package:driver/app/view/reviews.dart';
import 'package:driver/app/view/splash.dart';
import 'package:driver/app/view/tabs.dart';
import 'package:driver/app/view/tracking.dart';
import 'package:driver/app/view/update_password_firebase.dart';

class AppRouter {
  static const String initial = '/';
  static const String splashRoutes = '/splash';
  static const String loginRoutes = '/login';
  static const String tabsRoute = '/tabs';
  static const String errorRoute = '/error';
  static const String firebaseLogin = '/firebase_login';
  static const String resetPassword = '/reset_password';
  static const String registerRoutes = '/register';
  static const String firebaseResetPassword = '/firebase_reset';
  static const String firebaseUpdatePassword = '/firebase_update_password';
  static const String firebaseRegiter = '/firebase_register';
  static const String ordersRoutes = '/orders';
  static const String accountRoutes = '/account';
  static const String appPagesRoutes = '/app_pages';
  static const String contactRoutes = '/contact';
  static const String languagesRoutes = '/languages';
  static const String reviewsRoutes = '/reviews';
  static const String orderDetailsRoutes = '/order_details';
  static const String firebaseDeliveryRoutes = '/firebase_delivery';
  static const String trackingRoutes = '/tracking';
  static const String editProfileRoutes = '/edit_profile';

  static String getInitialRoute() => initial;
  static String getSplashRoute() => splashRoutes;
  static String getLoginRoute() => loginRoutes;
  static String getTabsRoute() => tabsRoute;
  static String getErrorRoute() => errorRoute;
  static String getFirebaseRoute() => firebaseLogin;
  static String getResetPasswordRoutes() => resetPassword;
  static String getRegisterRoute() => registerRoutes;
  static String getFirebaseResetRoutes() => firebaseResetPassword;
  static String getFirebaseUpdatePasswordRoutes() => firebaseUpdatePassword;
  static String getFirebaseRegisterRoute() => firebaseRegiter;
  static String getOrdersRoutes() => ordersRoutes;
  static String getAccountRoutes() => accountRoutes;
  static String getAppPagesRoutes() => appPagesRoutes;
  static String getContactRoutes() => contactRoutes;
  static String getLanguagesRoute() => languagesRoutes;
  static String getReviewsRoutes() => reviewsRoutes;
  static String getOrderDetailsRoutes() => orderDetailsRoutes;
  static String getFirebaseDeliveryRoutes() => firebaseDeliveryRoutes;
  static String getTrackingRoutes() => trackingRoutes;
  static String getEditProfileRoutes() => editProfileRoutes;

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const IntroScreen(), binding: IntroBinding()),
    GetPage(name: splashRoutes, page: () => const SplashScreen(), binding: SplashBinding()),
    GetPage(name: errorRoute, page: () => const ErrorScreen()),
    GetPage(name: loginRoutes, page: () => const LoginScreen(), binding: LoginBinding()),
    GetPage(name: registerRoutes, page: () => const RegisterScreen(), binding: RegisterBinding()),
    GetPage(name: resetPassword, page: () => const ResetPasswordScreen(), binding: ResetPasswordBinding()),
    GetPage(name: firebaseResetPassword, page: () => const FirebaseResetScreen(), binding: FirebaseResetBinding()),
    GetPage(name: firebaseUpdatePassword, page: () => const UpdatePasswordFirebaseScreen(), binding: UpdateFirebasePasswordBindings()),
    GetPage(name: firebaseLogin, page: () => const FirebaseVerificationScreen(), binding: FirebaseBinding()),
    GetPage(name: firebaseRegiter, page: () => const FirebaseRegisterScreen(), binding: FirebaseRegisterBinding()),
    GetPage(name: tabsRoute, page: () => const TabScreen(), binding: TabsBinding()),
    GetPage(name: ordersRoutes, page: () => const OrderListScreen(), binding: OrdersBinding()),
    GetPage(name: accountRoutes, page: () => const AccountScreen(), binding: AccountBinding()),
    GetPage(name: appPagesRoutes, page: () => const AppPageScreen(), binding: AppPagesBinding()),
    GetPage(name: contactRoutes, page: () => const ContactScreen(), binding: ContactBinding()),
    GetPage(name: languagesRoutes, page: () => const LanguageScreen(), binding: LanguageBinding()),
    GetPage(name: reviewsRoutes, page: () => const ReviewsListScreen(), binding: ReviewsBinding()),
    GetPage(name: orderDetailsRoutes, page: () => const OrderDetailScreen(), binding: OrderDetailsBinding()),
    GetPage(name: firebaseDeliveryRoutes, page: () => const FirebaseDeliveryScreen(), binding: FirebaseDeliveryBinding()),
    GetPage(name: trackingRoutes, page: () => const TrackingScreen(), binding: TrackingBinding()),
    GetPage(name: editProfileRoutes, page: () => const EditProfileScreen(), binding: EditProfileBinding())
  ];
}
