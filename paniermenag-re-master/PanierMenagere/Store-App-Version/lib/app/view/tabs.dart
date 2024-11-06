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
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:vendors/app/controller/tabs_controller.dart';
import 'package:vendors/app/util/theme.dart';
import 'package:vendors/app/view/account.dart';
import 'package:vendors/app/view/orders.dart';
import 'package:vendors/app/view/products.dart';
import 'package:vendors/app/view/stats.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [const OrdersScreen(), const StatsScreen(), const ProductListScreen(), const AccountScreen()];
    return GetBuilder<TabsBottomController>(
      builder: (value) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: InkWell(
                  child: (GNav(
                    rippleColor: ThemeProvider.appColor,
                    hoverColor: ThemeProvider.appColor,
                    haptic: false,
                    curve: Curves.easeOutExpo,
                    tabBorderRadius: 15,
                    textStyle: const TextStyle(fontFamily: 'bold', color: Colors.white),
                    duration: const Duration(milliseconds: 300),
                    gap: 5,
                    color: Colors.grey.shade400,
                    activeColor: Colors.white,
                    iconSize: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    tabs: [
                      GButton(icon: Icons.shopping_cart_outlined, text: 'Orders'.tr, backgroundColor: ThemeProvider.appColor),
                      GButton(icon: Icons.trending_up_outlined, text: 'Analytics'.tr, backgroundColor: ThemeProvider.appColor),
                      GButton(icon: Icons.category_outlined, text: 'Products'.tr, backgroundColor: ThemeProvider.appColor),
                      GButton(icon: Icons.account_circle_outlined, text: 'Account'.tr, backgroundColor: ThemeProvider.appColor),
                    ],
                    selectedIndex: value.tabId,
                    onTabChange: (index) => value.updateTabId(index),
                  )),
                ),
              ),
            ),
            body: TabBarView(physics: const NeverScrollableScrollPhysics(), controller: value.tabController, children: pages),
          ),
        );
      },
    );
  }
}
