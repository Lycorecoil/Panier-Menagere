/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:vendors/app/controller/order_details_controller.dart';
import 'package:vendors/app/controller/orders_controller.dart';
import 'package:vendors/app/env.dart';
import 'package:vendors/app/helper/router.dart';
import 'package:vendors/app/util/theme.dart';
import '../util/drawer.dart' as drawer;

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  final ScrollController _scrollControllerNew = ScrollController();
  final ScrollController _scrollControllerOnGoing = ScrollController();
  final ScrollController _scrollControllerOlder = ScrollController();
  final GlobalKey<RefreshIndicatorState> refreshKeyNew = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> refreshKeyOnGoing = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> refreshKeyOlder = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      tabController.animateTo(tabController.index, duration: const Duration(seconds: 3));
      debugPrint(tabController.index.toString());
    });

    _scrollControllerNew.addListener(() {
      if (_scrollControllerNew.position.pixels == _scrollControllerNew.position.maxScrollExtent) {
        Get.find<OrdersController>().increment();
      }
    });

    _scrollControllerOnGoing.addListener(() {
      if (_scrollControllerOnGoing.position.pixels == _scrollControllerOnGoing.position.maxScrollExtent) {
        Get.find<OrdersController>().increment();
      }
    });

    _scrollControllerOlder.addListener(() {
      if (_scrollControllerOlder.position.pixels == _scrollControllerOlder.position.maxScrollExtent) {
        Get.find<OrdersController>().increment();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
      builder: (value) {
        return SideMenu(
          key: _sideMenuKey,
          background: ThemeProvider.secondaryAppColor,
          menu: drawer.buildMenu(_sideMenuKey),
          type: SideMenuType.shrinkNSlide, // check above images
          inverse: true,
          child: SafeArea(
            child: DefaultTabController(
              length: 3,
              child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: ThemeProvider.appColor,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    bottom: value.apiCalled == true
                        ? PreferredSize(
                            preferredSize: const Size.fromHeight(30.0),
                            child: TabBar(
                              tabAlignment: TabAlignment.start,
                              controller: tabController,
                              isScrollable: true,
                              labelColor: ThemeProvider.whiteColor,
                              unselectedLabelColor: ThemeProvider.whiteColor,
                              indicatorColor: ThemeProvider.whiteColor,
                              indicator: const UnderlineTabIndicator(borderSide: BorderSide(width: 2.0, color: ThemeProvider.whiteColor), insets: EdgeInsets.symmetric(horizontal: 5)),
                              tabs: [Tab(text: "New Orders".tr), Tab(text: "Ongoing Orders".tr), Tab(text: "Past Orders".tr)],
                            ),
                          )
                        : null,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [Text('Vendors'.tr, style: const TextStyle(fontSize: 18, fontFamily: 'bold', color: ThemeProvider.whiteColor))])
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: InkWell(
                                        onTap: () {
                                          if (_sideMenuKey.currentState!.isOpened) {
                                            _sideMenuKey.currentState?.closeSideMenu();
                                          } else {
                                            _sideMenuKey.currentState?.openSideMenu();
                                          }
                                        },
                                        child: const Icon(Icons.menu_outlined, size: 20, color: ThemeProvider.whiteColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: value.apiCalled == false ? SkeletonListView() : _buildBody(value)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(value) {
    List<Widget> contents = [];
    contents.add(
      RefreshIndicator(
        key: refreshKeyNew,
        onRefresh: () async => await value.hardRefresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollControllerNew,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: List.generate(
                    value.newOrderList.length,
                    (index) {
                      return InkWell(
                        onTap: () {
                          Get.delete<OrderDetailsController>(force: true);
                          Get.toNamed(AppRouter.getOrderDetailsRoutes(), arguments: [value.newOrderList[index].id]);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 30),
                          margin: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            color: ThemeProvider.whiteColor,
                            boxShadow: [BoxShadow(color: ThemeProvider.greyColor.withOpacity(0.5), spreadRadius: 2, blurRadius: 7, offset: const Offset(0, 3))],
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 75,
                                    width: 75,
                                    child: FadeInImage(
                                      image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.newOrderList[index].orders![0].cover}'),
                                      placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                                      },
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('ORDER #'.tr + value.newOrderList[index].id.toString(), style: const TextStyle(fontSize: 12, fontFamily: 'semibold', color: Colors.grey)),
                                          Column(
                                            children: List.generate(
                                              value.newOrderList[index].orders!.length,
                                              (orderIndex) {
                                                return Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade300))),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Row(
                                                        children: value.newOrderList[index].orders![orderIndex].variations == null
                                                            ? [
                                                                Text(
                                                                    value.newOrderList[index].orders![orderIndex].name.length > 15
                                                                        ? value.newOrderList[index].orders![orderIndex].name.substring(0, 15) + '...'
                                                                        : value.newOrderList[index].orders![orderIndex].name.toString(),
                                                                    style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                                                const Text(' - '),
                                                                if (value.newOrderList[index].orders![orderIndex].haveGram == 1)
                                                                  Text(value.newOrderList[index].orders![orderIndex].gram.toString() + ' grams'.tr,
                                                                      style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                                else if (value.newOrderList[index].orders![orderIndex].haveKg == 1)
                                                                  Text(value.newOrderList[index].orders![orderIndex].kg.toString() + ' kg'.tr,
                                                                      style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                                else if (value.newOrderList[index].orders![orderIndex].haveLiter == 1)
                                                                  Text(value.newOrderList[index].orders![orderIndex].liter.toString() + ' ltr'.tr,
                                                                      style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                                else if (value.newOrderList[index].orders![orderIndex].haveMl == 1)
                                                                  Text(value.newOrderList[index].orders![orderIndex].ml.toString() + ' ml'.tr,
                                                                      style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                                else if (value.newOrderList[index].orders![orderIndex].havePcs == 1)
                                                                  Text(value.newOrderList[index].orders![orderIndex].pcs.toString() + ' pcs'.tr,
                                                                      style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start),
                                                                const Text(' - '),
                                                                value.newOrderList[index].orders![orderIndex].discount! > 0
                                                                    ? value.currencySide == 'left'
                                                                        ? Text(value.currencySymbol + value.newOrderList[index].orders![orderIndex].sellPrice.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                        : Text(value.newOrderList[index].orders![orderIndex].sellPrice.toString() + value.currencySymbol, style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                    : value.currencySide == 'left'
                                                                        ? Text(value.currencySymbol + value.newOrderList[index].orders![orderIndex].originalPrice.toString(),
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                        : Text(value.newOrderList[index].orders![orderIndex].originalPrice.toString() + value.currencySymbol,
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                              ]
                                                            : [
                                                                Text(
                                                                  value.newOrderList[index].orders![orderIndex].name.length > 15
                                                                      ? value.newOrderList[index].orders![orderIndex].name.substring(0, 15) + '...'
                                                                      : value.newOrderList[index].orders![orderIndex].name.toString(),
                                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'),
                                                                ),
                                                                const Text(' - '),
                                                                Text(value.newOrderList[index].orders![orderIndex].variations![0].items![value.newOrderList[index].orders![orderIndex].variant].title.toString(),
                                                                    style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                                                const Text(' - '),
                                                                value.newOrderList[index].orders![orderIndex].variations![0].items![value.newOrderList[index].orders![orderIndex].variant].discount! > 0
                                                                    ? value.currencySide == 'left'
                                                                        ? Text(
                                                                            value.currencySymbol +
                                                                                value.newOrderList[index].orders![orderIndex].variations![0].items![value.newOrderList[index].orders![orderIndex].variant].discount.toString(),
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                        : Text(
                                                                            value.newOrderList[index].orders![orderIndex].variations![0].items![value.newOrderList[index].orders![orderIndex].variant].sellPrice.toString() +
                                                                                value.currencySymbol,
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                    : value.currencySide == 'left'
                                                                        ? Text(
                                                                            value.currencySymbol +
                                                                                value.newOrderList[index].orders![orderIndex].variations![0].items![value.newOrderList[index].orders![orderIndex].variant].price.toString(),
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                        : Text(
                                                                            value.newOrderList[index].orders![orderIndex].variations![0].items![value.newOrderList[index].orders![orderIndex].variant].price.toString() +
                                                                                value.currencySymbol,
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                              ],
                                                      ),
                                                      Text('X ${value.newOrderList[index].orders![orderIndex].quantity}', style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(value.newOrderList[index].dateTime.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'semibold')),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 100,
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.only(bottomRight: Radius.circular(5))),
                                    child: Center(
                                      child: Text(
                                        value.newOrderList[index].status[0].status.toString().tr.toUpperCase(),
                                        style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'bold', fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                value.loadMore == true ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor)) : const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
    contents.add(
      RefreshIndicator(
        key: refreshKeyOnGoing,
        onRefresh: () async => await value.hardRefresh(),
        child: SingleChildScrollView(
          controller: _scrollControllerOnGoing,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: List.generate(
                    value.onGoingOrderList.length,
                    (index) {
                      return InkWell(
                        onTap: () {
                          Get.delete<OrderDetailsController>(force: true);
                          Get.toNamed(AppRouter.getOrderDetailsRoutes(), arguments: [value.onGoingOrderList[index].id]);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 30),
                          margin: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            color: ThemeProvider.whiteColor,
                            boxShadow: [BoxShadow(color: ThemeProvider.greyColor.withOpacity(0.5), spreadRadius: 2, blurRadius: 7, offset: const Offset(0, 3))],
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 75,
                                    width: 75,
                                    child: FadeInImage(
                                      image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.onGoingOrderList[index].orders![0].cover}'),
                                      placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                                      },
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('ORDER #'.tr + value.onGoingOrderList[index].id.toString(), style: const TextStyle(fontSize: 12, fontFamily: 'semibold', color: Colors.grey)),
                                          Column(
                                            children: List.generate(
                                              value.onGoingOrderList[index].orders!.length,
                                              (orderIndex) {
                                                return Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade300))),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Row(
                                                        children: value.onGoingOrderList[index].orders![orderIndex].variations == null
                                                            ? [
                                                                Text(
                                                                    value.onGoingOrderList[index].orders![orderIndex].name.length > 15
                                                                        ? value.onGoingOrderList[index].orders![orderIndex].name.substring(0, 15) + '...'
                                                                        : value.onGoingOrderList[index].orders![orderIndex].name.toString(),
                                                                    style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                                                const Text(' - '),
                                                                if (value.onGoingOrderList[index].orders![orderIndex].haveGram == 1)
                                                                  Text(value.onGoingOrderList[index].orders![orderIndex].gram.toString() + ' grams'.tr,
                                                                      style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                                else if (value.onGoingOrderList[index].orders![orderIndex].haveKg == 1)
                                                                  Text(value.onGoingOrderList[index].orders![orderIndex].kg.toString() + ' kg'.tr,
                                                                      style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                                else if (value.onGoingOrderList[index].orders![orderIndex].haveLiter == 1)
                                                                  Text(value.onGoingOrderList[index].orders![orderIndex].liter.toString() + ' ltr'.tr,
                                                                      style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                                else if (value.onGoingOrderList[index].orders![orderIndex].haveMl == 1)
                                                                  Text(value.onGoingOrderList[index].orders![orderIndex].ml.toString() + ' ml'.tr,
                                                                      style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                                else if (value.onGoingOrderList[index].orders![orderIndex].havePcs == 1)
                                                                  Text(value.onGoingOrderList[index].orders![orderIndex].pcs.toString() + ' pcs'.tr,
                                                                      style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start),
                                                                const Text(' - '),
                                                                value.onGoingOrderList[index].orders![orderIndex].discount! > 0
                                                                    ? value.currencySide == 'left'
                                                                        ? Text(value.currencySymbol + value.onGoingOrderList[index].orders![orderIndex].sellPrice.toString(),
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                        : Text(value.onGoingOrderList[index].orders![orderIndex].sellPrice.toString() + value.currencySymbol,
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                    : value.currencySide == 'left'
                                                                        ? Text(value.currencySymbol + value.onGoingOrderList[index].orders![orderIndex].originalPrice.toString(),
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                        : Text(value.onGoingOrderList[index].orders![orderIndex].originalPrice.toString() + value.currencySymbol,
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                              ]
                                                            : [
                                                                Text(
                                                                  value.onGoingOrderList[index].orders![orderIndex].name.length > 15
                                                                      ? value.onGoingOrderList[index].orders![orderIndex].name.substring(0, 15) + '...'
                                                                      : value.onGoingOrderList[index].orders![orderIndex].name.toString(),
                                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'),
                                                                ),
                                                                const Text(' - '),
                                                                Text(value.onGoingOrderList[index].orders![orderIndex].variations![0].items![value.onGoingOrderList[index].orders![orderIndex].variant].title.toString(),
                                                                    style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                                                const Text(' - '),
                                                                value.onGoingOrderList[index].orders![orderIndex].variations![0].items![value.onGoingOrderList[index].orders![orderIndex].variant].discount! > 0
                                                                    ? value.currencySide == 'left'
                                                                        ? Text(
                                                                            value.currencySymbol +
                                                                                value.onGoingOrderList[index].orders![orderIndex].variations![0].items![value.onGoingOrderList[index].orders![orderIndex].variant].discount
                                                                                    .toString(),
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                        : Text(
                                                                            value.onGoingOrderList[index].orders![orderIndex].variations![0].items![value.onGoingOrderList[index].orders![orderIndex].variant].discount.toString() +
                                                                                value.currencySymbol,
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                    : value.currencySide == 'left'
                                                                        ? Text(
                                                                            value.currencySymbol +
                                                                                value.onGoingOrderList[index].orders![orderIndex].variations![0].items![value.onGoingOrderList[index].orders![orderIndex].variant].price.toString(),
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                        : Text(
                                                                            value.onGoingOrderList[index].orders![orderIndex].variations![0].items![value.onGoingOrderList[index].orders![orderIndex].variant].price.toString() +
                                                                                value.currencySymbol,
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                              ],
                                                      ),
                                                      Text('X ${value.onGoingOrderList[index].orders![orderIndex].quantity}', style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(value.onGoingOrderList[index].dateTime.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'semibold')),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 100,
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.only(bottomRight: Radius.circular(5))),
                                    child: Center(
                                      child: Text(
                                        value.onGoingOrderList[index].status[0].status.toString().tr.toUpperCase(),
                                        style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'bold', fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                value.loadMore == true ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor)) : const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
    contents.add(
      RefreshIndicator(
        key: refreshKeyOlder,
        onRefresh: () async => await value.hardRefresh(),
        child: SingleChildScrollView(
          controller: _scrollControllerOlder,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: List.generate(
                    value.olderOrderList.length,
                    (index) {
                      return InkWell(
                        onTap: () {
                          Get.delete<OrderDetailsController>(force: true);
                          Get.toNamed(AppRouter.getOrderDetailsRoutes(), arguments: [value.olderOrderList[index].id]);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 30),
                          margin: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            color: ThemeProvider.whiteColor,
                            boxShadow: [BoxShadow(color: ThemeProvider.greyColor.withOpacity(0.5), spreadRadius: 2, blurRadius: 7, offset: const Offset(0, 3))],
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 75,
                                    width: 75,
                                    child: FadeInImage(
                                      image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.olderOrderList[index].orders![0].cover}'),
                                      placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                                      },
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('ORDER #'.tr + value.olderOrderList[index].id.toString(), style: const TextStyle(fontSize: 12, fontFamily: 'semibold', color: Colors.grey)),
                                          Column(
                                            children: List.generate(
                                              value.olderOrderList[index].orders!.length,
                                              (orderIndex) {
                                                return Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade300))),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Row(
                                                        children: value.olderOrderList[index].orders![orderIndex].variations == null
                                                            ? [
                                                                Text(
                                                                    value.olderOrderList[index].orders![orderIndex].name.length > 15
                                                                        ? value.olderOrderList[index].orders![orderIndex].name.substring(0, 15) + '...'
                                                                        : value.olderOrderList[index].orders![orderIndex].name.toString(),
                                                                    style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                                                const Text(' - '),
                                                                if (value.olderOrderList[index].orders![orderIndex].haveGram == 1)
                                                                  Text(value.olderOrderList[index].orders![orderIndex].gram.toString() + ' grams'.tr,
                                                                      style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                                else if (value.olderOrderList[index].orders![orderIndex].haveKg == 1)
                                                                  Text(value.olderOrderList[index].orders![orderIndex].kg.toString() + ' kg'.tr,
                                                                      style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                                else if (value.olderOrderList[index].orders![orderIndex].haveLiter == 1)
                                                                  Text(value.olderOrderList[index].orders![orderIndex].liter.toString() + ' ltr'.tr,
                                                                      style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                                else if (value.olderOrderList[index].orders![orderIndex].haveMl == 1)
                                                                  Text(value.olderOrderList[index].orders![orderIndex].ml.toString() + ' ml'.tr,
                                                                      style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                                else if (value.olderOrderList[index].orders![orderIndex].havePcs == 1)
                                                                  Text(value.olderOrderList[index].orders![orderIndex].pcs.toString() + ' pcs'.tr,
                                                                      style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start),
                                                                const Text(' - '),
                                                                value.olderOrderList[index].orders![orderIndex].discount! > 0
                                                                    ? value.currencySide == 'left'
                                                                        ? Text(value.currencySymbol + value.olderOrderList[index].orders![orderIndex].discount.toString(),
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                        : Text(value.olderOrderList[index].orders![orderIndex].discount.toString() + value.currencySymbol,
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                    : value.currencySide == 'left'
                                                                        ? Text(value.currencySymbol + value.olderOrderList[index].orders![orderIndex].originalPrice.toString(),
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                        : Text(value.olderOrderList[index].orders![orderIndex].originalPrice.toString() + value.currencySymbol,
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                              ]
                                                            : [
                                                                Text(
                                                                  value.olderOrderList[index].orders![orderIndex].name.length > 15
                                                                      ? value.olderOrderList[index].orders![orderIndex].name.substring(0, 15) + '...'
                                                                      : value.olderOrderList[index].orders![orderIndex].name.toString(),
                                                                  style: const TextStyle(fontSize: 10, fontFamily: 'regular'),
                                                                ),
                                                                const Text(' - '),
                                                                Text(value.olderOrderList[index].orders![orderIndex].variations![0].items![value.olderOrderList[index].orders![orderIndex].variant].title.toString(),
                                                                    style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                                                const Text(' - '),
                                                                value.olderOrderList[index].orders![orderIndex].variations![0].items![value.olderOrderList[index].orders![orderIndex].variant].discount! > 0
                                                                    ? value.currencySide == 'left'
                                                                        ? Text(
                                                                            value.currencySymbol +
                                                                                value.olderOrderList[index].orders![orderIndex].variations![0].items![value.olderOrderList[index].orders![orderIndex].variant].discount.toString(),
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                        : Text(
                                                                            value.olderOrderList[index].orders![orderIndex].variations![0].items![value.olderOrderList[index].orders![orderIndex].variant].discount.toString() +
                                                                                value.currencySymbol,
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                    : value.currencySide == 'left'
                                                                        ? Text(
                                                                            value.currencySymbol +
                                                                                value.olderOrderList[index].orders![orderIndex].variations![0].items![value.olderOrderList[index].orders![orderIndex].variant].price.toString(),
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                                        : Text(
                                                                            value.olderOrderList[index].orders![orderIndex].variations![0].items![value.olderOrderList[index].orders![orderIndex].variant].price.toString() +
                                                                                value.currencySymbol,
                                                                            style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                              ],
                                                      ),
                                                      Text('X ${value.olderOrderList[index].orders![orderIndex].quantity}', style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(value.olderOrderList[index].dateTime.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'semibold')),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 100,
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.only(bottomRight: Radius.circular(5))),
                                    child: Center(
                                      child: Text(
                                        value.olderOrderList[index].status[0].status.toString().tr.toUpperCase(),
                                        style: const TextStyle(color: ThemeProvider.whiteColor, fontFamily: 'bold', fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                value.loadMore == true ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor)) : const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
    return SizedBox(child: TabBarView(controller: tabController, children: contents));
  }
}
