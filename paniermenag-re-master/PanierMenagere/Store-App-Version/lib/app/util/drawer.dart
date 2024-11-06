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
import 'package:vendors/app/controller/account_controller.dart';
import 'package:vendors/app/controller/chat_list_controller.dart';
import 'package:vendors/app/controller/contact_controller.dart';
import 'package:vendors/app/controller/tabs_controller.dart';
import 'package:vendors/app/env.dart';
import 'package:vendors/app/helper/router.dart';
import 'package:vendors/app/util/theme.dart';

Widget buildMenu(sideMenuKey) {
  return GetBuilder<AccountController>(
    builder: (value) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(30),
                        child: FadeInImage(
                          image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.cover}'),
                          placeholder: const AssetImage("assets/images/logo.png"),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/images/logo.png', fit: BoxFit.fitWidth);
                          },
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(value.storeName.toString(), style: const TextStyle(color: ThemeProvider.whiteColor)),
                    const SizedBox(height: 10),
                    const Text(Environments.appName, style: TextStyle(color: ThemeProvider.whiteColor)),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
            ListTile(
              onTap: () {
                if (sideMenuKey.currentState!.isOpened) {
                  sideMenuKey.currentState?.closeSideMenu();
                } else {
                  sideMenuKey.currentState?.openSideMenu();
                }
                Get.find<TabsBottomController>().updateTabId(0);
              },
              leading: const Icon(Icons.home, size: 20.0, color: Colors.white),
              title: Text('Home'.tr),
              textColor: Colors.white,
              dense: true,
            ),
            ListTile(
              onTap: () {
                if (sideMenuKey.currentState!.isOpened) {
                  sideMenuKey.currentState?.closeSideMenu();
                } else {
                  sideMenuKey.currentState?.openSideMenu();
                }
                Get.find<TabsBottomController>().updateTabId(3);
              },
              leading: const Icon(Icons.account_circle_outlined, size: 20.0, color: Colors.white),
              title: Text('Profile'.tr),
              textColor: Colors.white,
              dense: true,
            ),
            ListTile(
              onTap: () {
                if (sideMenuKey.currentState!.isOpened) {
                  sideMenuKey.currentState?.closeSideMenu();
                } else {
                  sideMenuKey.currentState?.openSideMenu();
                }
                Get.find<TabsBottomController>().updateTabId(1);
              },
              leading: const Icon(Icons.trending_up_outlined, size: 20.0, color: Colors.white),
              title: Text('Analytics'.tr),
              textColor: Colors.white,
              dense: true,
            ),
            ListTile(
              onTap: () {
                if (sideMenuKey.currentState!.isOpened) {
                  sideMenuKey.currentState?.closeSideMenu();
                } else {
                  sideMenuKey.currentState?.openSideMenu();
                }
                Get.find<TabsBottomController>().updateTabId(2);
              },
              leading: const Icon(Icons.category_outlined, size: 20.0, color: Colors.white),
              title: Text('Products'.tr),
              textColor: Colors.white,
              dense: true,
            ),
            ListTile(
              onTap: () {
                if (sideMenuKey.currentState!.isOpened) {
                  sideMenuKey.currentState?.closeSideMenu();
                } else {
                  sideMenuKey.currentState?.openSideMenu();
                }
                Get.toNamed(AppRouter.getLanguagesRoute());
              },
              leading: const Icon(Icons.translate, size: 20.0, color: Colors.white),
              title: Text('Languages'.tr),
              textColor: Colors.white,
              dense: true,
            ),
            ListTile(
              onTap: () {
                if (sideMenuKey.currentState!.isOpened) {
                  sideMenuKey.currentState?.closeSideMenu();
                } else {
                  sideMenuKey.currentState?.openSideMenu();
                }
                Get.delete<ContactController>(force: true);
                Get.toNamed(AppRouter.getContactsRoutes());
              },
              leading: const Icon(Icons.attach_email_outlined, size: 20.0, color: Colors.white),
              title: Text('Contact Us'.tr),
              textColor: Colors.white,
              dense: true,
            ),
            ListTile(
              onTap: () {
                if (sideMenuKey.currentState!.isOpened) {
                  sideMenuKey.currentState?.closeSideMenu();
                } else {
                  sideMenuKey.currentState?.openSideMenu();
                }
                Get.delete<ChatListController>(force: true);
                Get.toNamed(AppRouter.getChatListRoutes());
              },
              leading: const Icon(Icons.wechat_outlined, size: 20.0, color: Colors.white),
              title: Text('Chats'.tr),
              textColor: Colors.white,
              dense: true,
            ),
            ListTile(
              onTap: () {
                if (sideMenuKey.currentState!.isOpened) {
                  sideMenuKey.currentState?.closeSideMenu();
                } else {
                  sideMenuKey.currentState?.openSideMenu();
                }

                value.logout();
              },
              leading: const Icon(Icons.logout, size: 20.0, color: Colors.white),
              title: Text('Logout'.tr),
              textColor: Colors.white,
              dense: true,
            ),
          ],
        ),
      );
    },
  );
}
