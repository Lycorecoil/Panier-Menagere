/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:vendors/app/backend/models/stats_chart_model.dart';
import 'package:vendors/app/backend/models/top_products_model.dart';
import 'package:vendors/app/backend/parse/stats_chart_parse.dart';
import 'package:vendors/app/controller/store_stats_controller.dart';
import 'package:vendors/app/util/constant.dart';

class StatsChartsController extends GetxController implements GetxService {
  final StatsChartParser parser;

  List<StatsChartModel> _todayStatesCharts = <StatsChartModel>[];
  List<StatsChartModel> get todayStatesCharts => _todayStatesCharts;

  List<StatsChartModel> _weeekStatesCharts = <StatsChartModel>[];
  List<StatsChartModel> get weeekStatesCharts => _weeekStatesCharts;

  List<StatsChartModel> _monthStatsCharts = <StatsChartModel>[];
  List<StatsChartModel> get monthStatsCharts => _monthStatsCharts;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  List<TopProductsModel> _topOrders = <TopProductsModel>[];
  List<TopProductsModel> get topOrders => _topOrders;

  StatsChartsController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    _todayStatesCharts = Get.find<StoreStatsController>().todayStatesCharts;
    _weeekStatesCharts = Get.find<StoreStatsController>().weeekStatesCharts;
    _monthStatsCharts = Get.find<StoreStatsController>().monthStatsCharts;
    _topOrders = Get.find<StoreStatsController>().topOrders;
  }
}
