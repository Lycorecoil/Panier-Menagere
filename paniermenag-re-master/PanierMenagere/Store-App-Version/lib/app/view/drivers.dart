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
import 'package:vendors/app/controller/drivers_controller.dart';
import 'package:vendors/app/env.dart';
import 'package:vendors/app/util/theme.dart';

class DriverListScreen extends StatefulWidget {
  const DriverListScreen({super.key});

  @override
  State<DriverListScreen> createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<WidgetState> states) {
      return ThemeProvider.appColor;
    }

    return GetBuilder<DriversController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text('Select Driver'.tr, style: ThemeProvider.titleStyle),
          ),
          bottomNavigationBar: SizedBox(
            height: 50,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => value.onStoreID(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.circular(5)),
                            child: Center(child: Text('Select'.tr, style: const TextStyle(color: ThemeProvider.whiteColor))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () => Get.back(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(color: ThemeProvider.redColor, borderRadius: BorderRadius.circular(5)),
                            child: Center(child: Text('Cancel'.tr, style: const TextStyle(color: ThemeProvider.whiteColor))),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                for (var options in value.driversList)
                  ListTile(
                    textColor: ThemeProvider.blackColor,
                    iconColor: ThemeProvider.blackColor,
                    title: Text('${options.firstName} ${options.lastName}'),
                    subtitle: Text('${options.distance} ${'KM'.tr}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    leading: ClipRRect(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(30),
                        child: FadeInImage(
                          image: NetworkImage('${Environments.apiBaseURL}storage/images/${options.cover}'),
                          placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                          },
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    trailing: Radio(
                      fillColor: WidgetStateProperty.resolveWith(getColor),
                      value: options.id.toString(),
                      groupValue: value.selectedDriverId,
                      onChanged: (e) => value.saveDriverId(e.toString()),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
