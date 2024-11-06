/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:vendors/app/backend/api/handler.dart';
import 'package:vendors/app/backend/models/complaints_model.dart';
import 'package:vendors/app/backend/models/orders_model.dart';
import 'package:vendors/app/backend/models/products_model.dart';
import 'package:vendors/app/backend/models/stats_chart_model.dart';
import 'package:vendors/app/backend/models/stats_data_model.dart';
import 'package:vendors/app/backend/models/top_products_model.dart';
import 'package:vendors/app/backend/parse/stats_parse.dart';
import 'package:vendors/app/util/constant.dart';

class StoreStatsController extends GetxController implements GetxService {
  final StoreStatsParser parser;
  bool apiCalled = false;

  List<ProductsModel> _tempOrders = <ProductsModel>[];
  List<ProductsModel> get tempOrders => _tempOrders;

  List<TopProductsModel> _topOrders = <TopProductsModel>[];
  List<TopProductsModel> get topOrders => _topOrders;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  StatsDataModel _todayStates = StatsDataModel();
  StatsDataModel get todayStates => _todayStates;

  StatsDataModel _weeekStates = StatsDataModel();
  StatsDataModel get weeekStates => _weeekStates;

  StatsDataModel _monthStats = StatsDataModel();
  StatsDataModel get monthStats => _monthStats;

  StatsDataModel _todayStatesRejected = StatsDataModel();
  StatsDataModel get todayStatesRejected => _todayStatesRejected;

  StatsDataModel _weeekStatesRejected = StatsDataModel();
  StatsDataModel get weeekStatesRejected => _weeekStatesRejected;

  StatsDataModel _monthStatsRejected = StatsDataModel();
  StatsDataModel get monthStatsRejected => _monthStatsRejected;

  List<StatsChartModel> _todayStatesCharts = <StatsChartModel>[];
  List<StatsChartModel> get todayStatesCharts => _todayStatesCharts;

  List<StatsChartModel> _weeekStatesCharts = <StatsChartModel>[];
  List<StatsChartModel> get weeekStatesCharts => _weeekStatesCharts;

  List<StatsChartModel> _monthStatsCharts = <StatsChartModel>[];
  List<StatsChartModel> get monthStatsCharts => _monthStatsCharts;

  List<OrdersModel> _todaysOrders = <OrdersModel>[];
  List<OrdersModel> get todaysOrders => _todaysOrders;

  List<OrdersModel> _weeklyOrders = <OrdersModel>[];
  List<OrdersModel> get weeklyOrders => _weeklyOrders;

  List<OrdersModel> _monthlyOrders = <OrdersModel>[];
  List<OrdersModel> get monthlyOrders => _monthlyOrders;

  List<ComplaintsModel> _complaintsList = <ComplaintsModel>[];
  List<ComplaintsModel> get complaintsList => _complaintsList;

  String uid = '';

  List<String> reasonList = [
    'The product arrived too late',
    'The product did not match the description',
    'The purchase was fraudulent',
    'The product was damaged or defective',
    'The merchant shipped the wrong item',
    'Wrong Item Size or Wrong Product Shipped',
    'Driver arrived too late',
    'Driver behavior',
    'Store Vendors behavior',
    'Issue with Payment Amout',
    'Others',
  ];

  StoreStatsController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    uid = parser.getUID();

    getStats();
  }

  Future<void> getStats() async {
    Response response = await parser.getStats();
    apiCalled = true;
    _tempOrders = [];
    _topOrders = [];
    _todayStates = StatsDataModel();
    _weeekStates = StatsDataModel();
    _monthStats = StatsDataModel();
    _todayStatesRejected = StatsDataModel();
    _weeekStatesRejected = StatsDataModel();
    _monthStatsRejected = StatsDataModel();
    _todayStatesCharts = [];
    _weeekStatesCharts = [];
    _monthStatsCharts = [];
    _todaysOrders = [];
    _weeklyOrders = [];
    _monthlyOrders = [];
    _complaintsList = [];
    double todayDeliveredTotal = 0.0;
    double todayRejectedTotal = 0.0;

    double weeklyDeliveredTotal = 0.0;
    double weeklyRejectedTotal = 0.0;

    double monthlyDeliveredTotal = 0.0;
    double monthlyRejectedTotal = 0.0;

    List todaysDeliveredOrders = [];
    List todaysCancelledOrders = [];

    List weeklyDeliveredOrders = [];
    List weeklyCancelledOrders = [];

    List monthlyDeliveredOrders = [];
    List monthlyCancelledOrders = [];

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];

      if (body['today'] != null && body['today']['data'] != null) {
        todayStates.label = body['today']['label'];
        todayStatesRejected.label = body['today']['label'];
        body['today']['data'].forEach((data) {
          OrdersModel datas = OrdersModel.fromJson(data);
          datas.orders = datas.orders!.where((element) => element.storeId.toString() == uid).toList();
          for (var element in datas.orders!) {
            _tempOrders.add(element);
          }

          var status = datas.status!.firstWhere((element) => element.id.toString() == uid).status;
          if (status == 'delivered') {
            for (var element in datas.orders!) {
              double total = 0.0;
              if (element.discount! == 0) {
                if (element.size == 1) {
                  if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                    total = total + element.variations![0].items![element.variant].discount! * element.quantity;
                  } else {
                    total = total + element.variations![0].items![element.variant].price! * element.quantity;
                  }
                } else {
                  total = total + element.originalPrice! * element.quantity;
                }
              } else {
                if (element.size == 1) {
                  if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                    total = total + element.variations![0].items![element.variant].discount! * element.quantity;
                  } else {
                    total = total + element.variations![0].items![element.variant].price! * element.quantity;
                  }
                } else {
                  total = total + element.sellPrice! * element.quantity;
                }
              }
              todayDeliveredTotal = double.parse((todayDeliveredTotal + total).toStringAsFixed(2));
              todaysDeliveredOrders.add(element);
            }
          }

          if (status == 'rejected' || status == 'cancelled') {
            for (var element in datas.orders!) {
              double total = 0.0;
              if (element.discount! == 0) {
                if (element.size == 1) {
                  if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                    total = total + element.variations![0].items![element.variant].discount! * element.quantity;
                  } else {
                    total = total + element.variations![0].items![element.variant].price! * element.quantity;
                  }
                } else {
                  total = total + element.originalPrice! * element.quantity;
                }
              } else {
                if (element.size == 1) {
                  if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                    total = total + element.variations![0].items![element.variant].discount! * element.quantity;
                  } else {
                    total = total + element.variations![0].items![element.variant].price! * element.quantity;
                  }
                } else {
                  total = total + element.sellPrice! * element.quantity;
                }
              }
              todayRejectedTotal = double.parse((todayRejectedTotal + total).toStringAsFixed(2));
              todaysCancelledOrders.add(element);
            }
          }

          _todaysOrders.add(datas);
        });
        var todaysList = [..._todaysOrders.map((element) => Jiffy.parse(element.dateTime.toString()).format(pattern: 'MMM d, hh a'))];
        todaysList = todaysList.toSet().toList();
        for (var item in todaysList) {
          var param = {"date": item, "sells": _todaysOrders.where((element) => Jiffy.parse(element.dateTime.toString()).format(pattern: 'MMM d, hh a') == item).toList(), "totalSell": 0};
          StatsChartModel datas = StatsChartModel.fromJson(param);
          _todayStatesCharts.add(datas);
        }
        for (var data in todayStatesCharts) {
          double orderTotal = 0.0;
          for (var sells in data.sells!) {
            for (var order in sells.orders!) {
              var element = order;
              if (element.discount! == 0) {
                if (element.size == 1) {
                  if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                    orderTotal = orderTotal + element.variations![0].items![element.variant].discount! * element.quantity;
                  } else {
                    orderTotal = orderTotal + element.variations![0].items![element.variant].price! * element.quantity;
                  }
                } else {
                  orderTotal = orderTotal + element.originalPrice! * element.quantity;
                }
              } else {
                if (element.size == 1) {
                  if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                    orderTotal = orderTotal + element.variations![0].items![element.variant].discount! * element.quantity;
                  } else {
                    orderTotal = orderTotal + element.variations![0].items![element.variant].price! * element.quantity;
                  }
                } else {
                  orderTotal = orderTotal + element.sellPrice! * element.quantity;
                }
              }
            }
          }
          data.totalSell = orderTotal;
        }
      }

      if (body['week'] != null && body['week']['data'] != null) {
        weeekStates.label = body['week']['label'];
        weeekStatesRejected.label = body['week']['label'];
        body['week']['data'].forEach((data) {
          OrdersModel datas = OrdersModel.fromJson(data);
          datas.orders = datas.orders!.where((element) => element.storeId.toString() == uid).toList();
          for (var element in datas.orders!) {
            _tempOrders.add(element);
          }

          var status = datas.status!.firstWhere((element) => element.id.toString() == uid).status;
          if (status == 'delivered') {
            for (var element in datas.orders!) {
              double total = 0.0;
              if (element.discount! == 0) {
                if (element.size == 1) {
                  if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                    total = total + element.variations![0].items![element.variant].discount! * element.quantity;
                  } else {
                    total = total + element.variations![0].items![element.variant].price! * element.quantity;
                  }
                } else {
                  total = total + element.originalPrice! * element.quantity;
                }
              } else {
                if (element.size == 1) {
                  if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                    total = total + element.variations![0].items![element.variant].discount! * element.quantity;
                  } else {
                    total = total + element.variations![0].items![element.variant].price! * element.quantity;
                  }
                } else {
                  total = total + element.sellPrice! * element.quantity;
                }
              }
              weeklyDeliveredTotal = double.parse((weeklyDeliveredTotal + total).toStringAsFixed(2));
              weeklyDeliveredOrders.add(element);
            }
          }

          if (status == 'rejected' || status == 'cancelled') {
            for (var element in datas.orders!) {
              double total = 0.0;
              if (element.discount! == 0) {
                if (element.size == 1) {
                  if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                    total = total + element.variations![0].items![element.variant].discount! * element.quantity;
                  } else {
                    total = total + element.variations![0].items![element.variant].price! * element.quantity;
                  }
                } else {
                  total = total + element.originalPrice! * element.quantity;
                }
              } else {
                if (element.size == 1) {
                  if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                    total = total + element.variations![0].items![element.variant].discount! * element.quantity;
                  } else {
                    total = total + element.variations![0].items![element.variant].price! * element.quantity;
                  }
                } else {
                  total = total + element.sellPrice! * element.quantity;
                }
              }
              weeklyRejectedTotal = double.parse((weeklyRejectedTotal + total).toStringAsFixed(2));
              weeklyCancelledOrders.add(element);
            }
          }

          _weeklyOrders.add(datas);
        });
        var todaysList = [..._weeklyOrders.map((element) => Jiffy.parse(element.dateTime.toString()).format(pattern: 'd MMM'))];
        todaysList = todaysList.toSet().toList();
        for (var item in todaysList) {
          var param = {"date": item, "sells": _weeklyOrders.where((element) => Jiffy.parse(element.dateTime.toString()).format(pattern: 'd MMM') == item).toList(), "totalSell": 0};
          StatsChartModel datas = StatsChartModel.fromJson(param);
          _weeekStatesCharts.add(datas);
        }
        for (var data in _weeekStatesCharts) {
          double orderTotal = 0.0;
          for (var sells in data.sells!) {
            for (var order in sells.orders!) {
              var element = order;
              if (element.discount! == 0) {
                if (element.size == 1) {
                  if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                    orderTotal = orderTotal + element.variations![0].items![element.variant].discount! * element.quantity;
                  } else {
                    orderTotal = orderTotal + element.variations![0].items![element.variant].price! * element.quantity;
                  }
                } else {
                  orderTotal = orderTotal + element.originalPrice! * element.quantity;
                }
              } else {
                if (element.size == 1) {
                  if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                    orderTotal = orderTotal + element.variations![0].items![element.variant].discount! * element.quantity;
                  } else {
                    orderTotal = orderTotal + element.variations![0].items![element.variant].price! * element.quantity;
                  }
                } else {
                  orderTotal = orderTotal + element.sellPrice! * element.quantity;
                }
              }
            }
          }
          data.totalSell = orderTotal;
        }
      }

      if (body['month'] != null && body['month']['data'] != null) {
        monthStats.label = body['month']['label'];
        monthStatsRejected.label = body['month']['label'];
        body['month']['data'].forEach((data) {
          OrdersModel datas = OrdersModel.fromJson(data);
          datas.orders = datas.orders!.where((element) => element.storeId.toString() == uid).toList();
          for (var element in datas.orders!) {
            _tempOrders.add(element);
          }

          var status = datas.status!.firstWhere((element) => element.id.toString() == uid).status;
          if (status == 'delivered') {
            for (var element in datas.orders!) {
              double total = 0.0;
              if (element.discount! == 0) {
                if (element.size == 1) {
                  if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                    total = total + element.variations![0].items![element.variant].discount! * element.quantity;
                  } else {
                    total = total + element.variations![0].items![element.variant].price! * element.quantity;
                  }
                } else {
                  total = total + element.originalPrice! * element.quantity;
                }
              } else {
                if (element.size == 1) {
                  if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                    total = total + element.variations![0].items![element.variant].discount! * element.quantity;
                  } else {
                    total = total + element.variations![0].items![element.variant].price! * element.quantity;
                  }
                } else {
                  total = total + element.sellPrice! * element.quantity;
                }
              }
              monthlyDeliveredTotal = double.parse((monthlyDeliveredTotal + total).toStringAsFixed(2));
              monthlyDeliveredOrders.add(element);
            }
          }

          if (status == 'rejected' || status == 'cancelled') {
            for (var element in datas.orders!) {
              double total = 0.0;
              if (element.discount! == 0) {
                if (element.size == 1) {
                  if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                    total = total + element.variations![0].items![element.variant].discount! * element.quantity;
                  } else {
                    total = total + element.variations![0].items![element.variant].price! * element.quantity;
                  }
                } else {
                  total = total + element.originalPrice! * element.quantity;
                }
              } else {
                if (element.size == 1) {
                  if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                    total = total + element.variations![0].items![element.variant].discount! * element.quantity;
                  } else {
                    total = total + element.variations![0].items![element.variant].price! * element.quantity;
                  }
                } else {
                  total = total + element.sellPrice! * element.quantity;
                }
              }
              monthlyRejectedTotal = double.parse((monthlyRejectedTotal + total).toStringAsFixed(2));
              monthlyCancelledOrders.add(element);
            }
          }

          _monthlyOrders.add(datas);
        });
        var todaysList = [..._monthlyOrders.map((element) => Jiffy.parse(element.dateTime.toString()).format(pattern: 'd MMM'))];
        todaysList = todaysList.toSet().toList();
        for (var item in todaysList) {
          var param = {"date": item, "sells": _monthlyOrders.where((element) => Jiffy.parse(element.dateTime.toString()).format(pattern: 'd MMM') == item).toList(), "totalSell": 0};
          StatsChartModel datas = StatsChartModel.fromJson(param);
          _monthStatsCharts.add(datas);
        }
        for (var data in _monthStatsCharts) {
          double orderTotal = 0.0;
          for (var sells in data.sells!) {
            for (var order in sells.orders!) {
              var element = order;
              if (element.discount! == 0) {
                if (element.size == 1) {
                  if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                    orderTotal = orderTotal + element.variations![0].items![element.variant].discount! * element.quantity;
                  } else {
                    orderTotal = orderTotal + element.variations![0].items![element.variant].price! * element.quantity;
                  }
                } else {
                  orderTotal = orderTotal + element.originalPrice! * element.quantity;
                }
              } else {
                if (element.size == 1) {
                  if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
                    orderTotal = orderTotal + element.variations![0].items![element.variant].discount! * element.quantity;
                  } else {
                    orderTotal = orderTotal + element.variations![0].items![element.variant].price! * element.quantity;
                  }
                } else {
                  orderTotal = orderTotal + element.sellPrice! * element.quantity;
                }
              }
            }
          }
          data.totalSell = orderTotal;
        }
      }
      if (body['complaints'] != null) {
        body['complaints'].forEach((data) {
          ComplaintsModel datas = ComplaintsModel.fromJson(data);
          _complaintsList.add(datas);
        });
      }
      todayStates.total = todayDeliveredTotal;
      todayStates.totalSold = todaysDeliveredOrders.length;

      todayStatesRejected.total = todayRejectedTotal;
      todayStatesRejected.totalSold = todaysCancelledOrders.length;

      weeekStates.total = weeklyDeliveredTotal;
      weeekStates.totalSold = weeklyDeliveredOrders.length;

      weeekStatesRejected.total = weeklyRejectedTotal;
      weeekStatesRejected.totalSold = weeklyCancelledOrders.length;

      monthStats.total = monthlyDeliveredTotal;
      monthStats.totalSold = monthlyDeliveredOrders.length;

      monthStatsRejected.total = monthlyRejectedTotal;
      monthStatsRejected.totalSold = monthlyCancelledOrders.length;

      List uniqueProductId = _tempOrders.map((e) => e.id).toSet().toList();
      for (var element in uniqueProductId) {
        List info = _tempOrders.where((x) => x.id == element).toList();
        if (info.isNotEmpty) {
          if (_topOrders.length < 10) {
            var param = {"id": element, "items": info[0], "counts": info.length};
            TopProductsModel topProductsParam = TopProductsModel.fromJson(param);
            _topOrders.add(topProductsParam);
          }
        }
      }
      _topOrders.sort((a, b) => b.counts!.compareTo(a.counts!));
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
    update();
  }

  Future<void> onRefresh() async {
    apiCalled = false;
    update();
    getStats();
  }
}
