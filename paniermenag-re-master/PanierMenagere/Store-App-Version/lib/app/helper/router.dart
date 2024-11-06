/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:vendors/app/backend/binding/account_binding.dart';
import 'package:vendors/app/backend/binding/categories_binding.dart';
import 'package:vendors/app/backend/binding/chat_list_binding.dart';
import 'package:vendors/app/backend/binding/contacts_binding.dart';
import 'package:vendors/app/backend/binding/drivers_binding.dart';
import 'package:vendors/app/backend/binding/edit_profile_binding.dart';
import 'package:vendors/app/backend/binding/firebase_binding.dart';
import 'package:vendors/app/backend/binding/firebase_register_binding.dart';
import 'package:vendors/app/backend/binding/firebase_reset_binding.dart';
import 'package:vendors/app/backend/binding/inbox_binding.dart';
import 'package:vendors/app/backend/binding/intro_binding.dart';
import 'package:vendors/app/backend/binding/invoice_list_binding.dart';
import 'package:vendors/app/backend/binding/languages_binding.dart';
import 'package:vendors/app/backend/binding/login_binding.dart';
import 'package:vendors/app/backend/binding/manage_product_binding.dart';
import 'package:vendors/app/backend/binding/order_binding.dart';
import 'package:vendors/app/backend/binding/order_details_binding.dart';
import 'package:vendors/app/backend/binding/pages_binding.dart';
import 'package:vendors/app/backend/binding/products_binding.dart';
import 'package:vendors/app/backend/binding/register_binding.dart';
import 'package:vendors/app/backend/binding/reset_password_binding.dart';
import 'package:vendors/app/backend/binding/reviews_binding.dart';
import 'package:vendors/app/backend/binding/search_binding.dart';
import 'package:vendors/app/backend/binding/splash_binding.dart';
import 'package:vendors/app/backend/binding/stats_charts_binding.dart';
import 'package:vendors/app/backend/binding/sub_categories_binding.dart';
import 'package:vendors/app/backend/binding/tabs_binding.dart';
import 'package:vendors/app/backend/binding/update_firebase_password_binding.dart';
import 'package:vendors/app/view/account.dart';
import 'package:vendors/app/view/app_pages.dart';
import 'package:vendors/app/view/categories.dart';
import 'package:vendors/app/view/chats_list.dart';
import 'package:vendors/app/view/contacts.dart';
import 'package:vendors/app/view/drivers.dart';
import 'package:vendors/app/view/edit_profile.dart';
import 'package:vendors/app/view/error.dart';
import 'package:vendors/app/view/firebase.dart';
import 'package:vendors/app/view/firebase_register.dart';
import 'package:vendors/app/view/firebase_reset.dart';
import 'package:vendors/app/view/inbox.dart';
import 'package:vendors/app/view/intro.dart';
import 'package:vendors/app/view/invoice_list.dart';
import 'package:vendors/app/view/languages.dart';
import 'package:vendors/app/view/login.dart';
import 'package:vendors/app/view/manage_product.dart';
import 'package:vendors/app/view/order_details.dart';
import 'package:vendors/app/view/orders.dart';
import 'package:vendors/app/view/products.dart';
import 'package:vendors/app/view/register.dart';
import 'package:vendors/app/view/reset.dart';
import 'package:vendors/app/view/reviews.dart';
import 'package:vendors/app/view/search.dart';
import 'package:vendors/app/view/splash.dart';
import 'package:vendors/app/view/stats.dart';
import 'package:vendors/app/view/stats_chart.dart';
import 'package:vendors/app/view/sub_category.dart';
import 'package:vendors/app/view/tabs.dart';
import 'package:vendors/app/view/update_password_firebase.dart';

class AppRouter {
  static const String initial = '/';
  static const String splashRoutes = '/splash';
  static const String loginRoutes = '/login';
  static const String tabsRoutes = '/tabs';
  static const String orders = '/orders';
  static const String stats = '/stats';
  static const String account = '/account';
  static const String errorRoutes = '/error';
  static const String firebaseRoutes = '/fire_auth';
  static const String registerRoutes = '/register';
  static const String firebaseRegisterRoutes = '/firebase_register';
  static const String resetPassworRoute = '/reset_password';
  static const String firebaseResetRoutes = '/firebase_reset_password';
  static const String updateFirebasePassword = '/update_firebase_password';
  static const String ordersRoutes = '/orders';
  static const String orderDetailsRoute = '/order_details';
  static const String driversRoute = '/drivers';
  static const String statsChartsRoute = '/stats_charts';
  static const String invoiceListRoute = '/invoice_list';
  static const String apppagesRoute = '/app_pages';
  static const String languagesRoute = '/languages';
  static const String chatListRoutes = '/chat_list';
  static const String inboxRoutes = '/inbox';
  static const String contactsRoutes = '/contacts';
  static const String productsRoutes = '/products';
  static const String searchRoutes = '/search';
  static const String manageProductRoute = '/manage_products';
  static const String categoriesRoutes = '/categories';
  static const String subCategoriesRoutes = '/sub_categories';
  static const String reviewsRoutes = '/reviews';
  static const String editProfileRoutes = '/edit_profile';

  static String getInitialRoute() => initial;
  static String getSplashRoutes() => splashRoutes;
  static String getLoginRoute() => loginRoutes;
  static String getTabsRoute() => tabsRoutes;
  static String getOrdersRoute() => orders;
  static String getStatsRoute() => stats;
  static String getAccountRoute() => account;
  static String getErrorRoute() => errorRoutes;
  static String getFirebaseRoute() => firebaseRoutes;
  static String getRegisterRoute() => registerRoutes;
  static String getFirebaseRegisterRoute() => firebaseRegisterRoutes;
  static String getResetPasswordRoutes() => resetPassworRoute;
  static String getFirebaseResetRoutes() => firebaseResetRoutes;
  static String getFirebaseUpdatePasswordRoutes() => updateFirebasePassword;
  static String getOrdersRoutes() => ordersRoutes;
  static String getOrderDetailsRoutes() => orderDetailsRoute;
  static String getDrivers() => driversRoute;
  static String getStatsChartsRoutes() => statsChartsRoute;
  static String getInvoiceRoutes() => invoiceListRoute;
  static String getAppPagesRoute() => apppagesRoute;
  static String getLanguagesRoute() => languagesRoute;
  static String getChatListRoutes() => chatListRoutes;
  static String getInboxRoutes() => inboxRoutes;
  static String getContactsRoutes() => contactsRoutes;
  static String getProductsRoutes() => productsRoutes;
  static String getSearchRoutes() => searchRoutes;
  static String getProductDetails() => manageProductRoute;
  static String getCategoriesRoutes() => categoriesRoutes;
  static String getSubCategoriesRoutes() => subCategoriesRoutes;
  static String getReviewsRoutes() => reviewsRoutes;
  static String getEditProfileRoutes() => editProfileRoutes;

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const IntroScreen(), binding: IntroBinding()),
    GetPage(name: splashRoutes, page: () => const SplashScreen(), binding: SplashBinding()),
    GetPage(name: errorRoutes, page: () => const ErrorScreen()),
    GetPage(name: firebaseRoutes, page: () => const FirebaseVerificationScreen(), binding: FirebaseBinding()),
    GetPage(name: loginRoutes, page: () => const LoginScreen(), binding: LoginBinding()),
    GetPage(name: registerRoutes, page: () => const RegisterScreen(), binding: RegisterBinding()),
    GetPage(name: firebaseRegisterRoutes, page: () => const FirebaseRegisterScreen(), binding: FirebaseRegisterBinding()),
    GetPage(name: tabsRoutes, page: () => const TabsScreen(), binding: TabsBinding()),
    GetPage(name: orders, page: () => const OrdersScreen()),
    GetPage(name: stats, page: () => const StatsScreen()),
    GetPage(name: account, page: () => const AccountScreen(), binding: AccountBinding()),
    GetPage(name: resetPassworRoute, page: () => const ResetPasswordScreen(), binding: ResetPasswordBinding()),
    GetPage(name: firebaseResetRoutes, page: () => const FirebaseResetScreen(), binding: FirebaseResetBinding()),
    GetPage(name: updateFirebasePassword, page: () => const UpdatePasswordFirebaseScreen(), binding: UpdateFirebasePasswordBindings()),
    GetPage(name: ordersRoutes, page: () => const OrdersScreen(), binding: OrdersBinding()),
    GetPage(name: orderDetailsRoute, page: () => const OrderDetailScreen(), binding: OrderDetailsBinding()),
    GetPage(name: driversRoute, page: () => const DriverListScreen(), fullscreenDialog: true, binding: DriversBinding()),
    GetPage(name: statsChartsRoute, page: () => const StatsChartScreen(), binding: StatsChartsBinding()),
    GetPage(name: invoiceListRoute, page: () => const InvoiceListScreen(), binding: InvoiceListBinding()),
    GetPage(name: apppagesRoute, page: () => const AppPageScreen(), binding: AppPagesBinding()),
    GetPage(name: languagesRoute, page: () => const LanguageScreen(), binding: LanguagesBinding()),
    GetPage(name: chatListRoutes, page: () => const ChatListScreen(), binding: ChatListBinding()),
    GetPage(name: inboxRoutes, page: () => const InboxScreen(), binding: InboxBinding()),
    GetPage(name: contactsRoutes, page: () => const ContactScreen(), binding: ContactBinding()),
    GetPage(name: productsRoutes, page: () => const ProductListScreen(), binding: ProductsBinding()),
    GetPage(name: searchRoutes, page: () => const SearchScreen(), binding: SearchBinding(), fullscreenDialog: true),
    GetPage(name: manageProductRoute, page: () => const ManageProductScreen(), binding: ManageProductBinding()),
    GetPage(name: categoriesRoutes, page: () => const CategoriesListScreen(), binding: CategoriesBinding(), fullscreenDialog: true),
    GetPage(name: subCategoriesRoutes, page: () => const SubCategoryScreen(), binding: SubCategoriesBinding(), fullscreenDialog: true),
    GetPage(name: reviewsRoutes, page: () => const ReviewsListScreen(), binding: ReviewsBinding()),
    GetPage(name: editProfileRoutes, page: () => const EditProfileScreen(), binding: EditProfileBinding())
  ];
}
