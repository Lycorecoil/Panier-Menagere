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
import 'package:driver/app/controller/firebase_delivery_controller.dart';
import 'package:driver/app/util/constant.dart';
import 'package:driver/app/util/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FirebaseDeliveryScreen extends StatefulWidget {
  const FirebaseDeliveryScreen({super.key});

  @override
  State<FirebaseDeliveryScreen> createState() => _FirebaseDeliveryScreenState();
}

class _FirebaseDeliveryScreenState extends State<FirebaseDeliveryScreen> {
  bool isLoading = true;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    final WebViewController controller = WebViewController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('success_verified')) {
              Get.find<FirebaseDeliveryController>().onLogin();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.message)));
        },
      )
      ..loadRequest(
          Uri.parse('${Get.find<FirebaseDeliveryController>().apiURL}${AppConstants.openFirebaseVerification}mobile=${Get.find<FirebaseDeliveryController>().countryCode}${Get.find<FirebaseDeliveryController>().phoneNumber}'));
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FirebaseDeliveryController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            centerTitle: false,
            title: Text('Verify your phone number'.tr, style: ThemeProvider.titleStyle),
          ),
          body: Stack(children: <Widget>[WebViewWidget(controller: _controller), isLoading ? const Center(child: CircularProgressIndicator(color: ThemeProvider.whiteColor)) : const Stack()]),
        );
      },
    );
  }
}
