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
import 'package:driver/app/controller/account_controller.dart';
import 'package:driver/app/controller/app_pages_controller.dart';
import 'package:driver/app/controller/contact_controller.dart';
import 'package:driver/app/controller/edit_profile_controller.dart';
import 'package:driver/app/controller/reset_password_controller.dart';
import 'package:driver/app/controller/reviews_controller.dart';
import 'package:driver/app/env.dart';
import 'package:driver/app/helper/router.dart';
import 'package:driver/app/util/theme.dart';
import '../util/drawer.dart' as drawer;

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(
      builder: (value) {
        return SideMenu(
          key: _sideMenuKey,
          background: ThemeProvider.secondaryAppColor,
          menu: drawer.buildMenu(_sideMenuKey),
          type: SideMenuType.shrinkNSlide, // check above images
          inverse: true,
          child: Scaffold(
            body: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)), color: ThemeProvider.appColor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Profile'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 18, color: Colors.white)),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (_sideMenuKey.currentState!.isOpened) {
                                        _sideMenuKey.currentState?.closeSideMenu();
                                      } else {
                                        _sideMenuKey.currentState?.openSideMenu();
                                      }
                                    },
                                    child: const Icon(Icons.menu, color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(100)),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: SizedBox.fromSize(
                                            size: const Size.fromRadius(30),
                                            child: FadeInImage(
                                              image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.cover}'),
                                              placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                              imageErrorBuilder: (context, error, stackTrace) {
                                                return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                                              },
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Column(
                                            children: [
                                              Row(children: [Text(value.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'bold', fontSize: 18, color: Colors.white))]),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  SizedBox(width: 150, child: Text(value.email, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.white))),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.delete<EditProfileController>(force: true);
                                                      Get.toNamed(AppRouter.getEditProfileRoutes());
                                                    },
                                                    child: Container(
                                                      width: 70,
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                                        gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [ThemeProvider.whiteColor, ThemeProvider.whiteColor]),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                      child: Center(child: Text('Edit'.tr, style: const TextStyle(color: ThemeProvider.appColor))),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        _buildContent(Icons.star_border_outlined, 'Reviews', 'reviews'),
                        _buildContent(Icons.code, 'Change Password', 'password'),
                        _buildContent(Icons.translate, 'Languages', 'languages'),
                        _buildContent(Icons.attach_email_outlined, 'Contact Us', 'contact'),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        _buildContent(Icons.help_outline, 'Faq & Help', 'faqs'),
                        _buildContent(Icons.privacy_tip_outlined, 'Privacy And Terms', 'privacy'),
                        _buildContent(Icons.info_outline, 'About', 'about'),
                        InkWell(onTap: () {}, child: _buildContent(Icons.logout, 'Logout', 'logout')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(icn, txt, route) {
    return InkWell(
      onTap: () {
        if (route == 'logout') {
          Get.find<AccountController>().logout();
        } else if (route == 'faqs') {
          Get.delete<AppPagesController>(force: true);
          Get.toNamed(AppRouter.getAppPagesRoutes(), arguments: ['Frequently Asked Questions'.tr, '5'], preventDuplicates: false);
        } else if (route == 'privacy') {
          Get.delete<AppPagesController>(force: true);
          Get.toNamed(AppRouter.getAppPagesRoutes(), arguments: ['Privacy Policy', '2'], preventDuplicates: false);
        } else if (route == 'about') {
          Get.delete<AppPagesController>(force: true);
          Get.toNamed(AppRouter.getAppPagesRoutes(), arguments: ['About Us', '1'], preventDuplicates: false);
        } else if (route == 'password') {
          Get.delete<ResetPasswordController>(force: true);
          Get.toNamed(AppRouter.getResetPasswordRoutes());
        } else if (route == 'languages') {
          Get.toNamed(AppRouter.getLanguagesRoute());
        } else if (route == 'contact') {
          Get.delete<ContactController>(force: true);
          Get.toNamed(AppRouter.getContactRoutes());
        } else if (route == 'reviews') {
          Get.delete<ReviewsController>(force: true);
          Get.toNamed(AppRouter.getReviewsRoutes());
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [Icon(icn, color: ThemeProvider.appColor, size: 14), const SizedBox(width: 10), Text('$txt'.tr, style: const TextStyle(fontSize: 14, fontFamily: 'bold'))]),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
