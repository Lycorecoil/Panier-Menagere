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
import 'package:vendors/app/controller/manage_product_controller.dart';
import 'package:vendors/app/controller/search_controller.dart';
import 'package:vendors/app/env.dart';
import 'package:vendors/app/helper/router.dart';
import 'package:vendors/app/util/theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppSearchController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            title: Container(
              width: double.infinity,
              height: 40,
              color: ThemeProvider.whiteColor,
              child: Center(
                child: TextField(
                  controller: value.searchController,
                  onChanged: value.searchProducts,
                  decoration: InputDecoration(
                    hintText: 'Search product'.tr,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(onPressed: () => value.clearData(), icon: const Icon(Icons.close)),
                  ),
                ),
              ),
            ),
            actions: <Widget>[IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close))],
            automaticallyImplyLeading: false,
          ),
          body: value.isEmpty.isFalse && value.result.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var i in value.result)
                        InkWell(
                          onTap: () {
                            Get.delete<ManageProductController>(force: true);
                            Get.toNamed(AppRouter.getProductDetails(), arguments: ['update', i.id, i.name]);
                          },
                          child: ListTile(
                            leading: ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 44, minHeight: 44, maxWidth: 64, maxHeight: 64),
                              child: FadeInImage(
                                image: NetworkImage('${Environments.apiBaseURL}storage/images/${i.cover}'),
                                placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                                },
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            title: Text(i.name.toString(), style: const TextStyle(fontSize: 10.0)),
                          ),
                        ),
                      const SizedBox(height: 10)
                    ],
                  ),
                )
              : Container(),
        );
      },
    );
  }
}
