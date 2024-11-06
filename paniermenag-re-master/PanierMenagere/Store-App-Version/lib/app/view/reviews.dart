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
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:vendors/app/controller/reviews_controller.dart';
import 'package:vendors/app/util/theme.dart';
import 'package:vendors/app/env.dart';

class ReviewsListScreen extends StatefulWidget {
  const ReviewsListScreen({super.key});

  @override
  State<ReviewsListScreen> createState() => _ReviewsListScreenState();
}

class _ReviewsListScreenState extends State<ReviewsListScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewsController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: true,
            title: Text('Reviews'.tr, style: ThemeProvider.titleStyle),
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor), onPressed: () => Get.back()),
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          for (var item in value.reviewsList)
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ThemeProvider.greyColor))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: SizedBox.fromSize(
                                        size: const Size.fromRadius(30),
                                        child: FadeInImage(
                                          image: NetworkImage('${Environments.apiBaseURL}storage/images/${item.cover}'),
                                          placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                          imageErrorBuilder: (context, error, stackTrace) {
                                            return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                                          },
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(width: 120, child: Text('${item.firstName} ${item.lastName}', overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15))),
                                                Text(item.timestamp.toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(color: ThemeProvider.greyColor, fontSize: 12)),
                                              ],
                                            ),
                                            Text('${'Received from'.tr} ${item.way}', style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor)),
                                            Row(
                                              children: [
                                                Icon(Icons.star, color: item.rate! >= 1 ? ThemeProvider.ratingColor : ThemeProvider.greyColor, size: 15),
                                                Icon(Icons.star, color: item.rate! >= 2 ? ThemeProvider.ratingColor : ThemeProvider.greyColor, size: 15),
                                                Icon(Icons.star, color: item.rate! >= 3 ? ThemeProvider.ratingColor : ThemeProvider.greyColor, size: 15),
                                                Icon(Icons.star, color: item.rate! >= 4 ? ThemeProvider.ratingColor : ThemeProvider.greyColor, size: 15),
                                                Icon(Icons.star, color: item.rate! >= 5 ? ThemeProvider.ratingColor : ThemeProvider.greyColor, size: 15),
                                              ],
                                            ),
                                            Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Text(item.msg.toString(), style: const TextStyle(fontSize: 12))),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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
    );
  }
}
