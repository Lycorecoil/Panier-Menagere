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
import 'package:timeline_tile/timeline_tile.dart';
import 'package:vendors/app/controller/order_details_controller.dart';
import 'package:vendors/app/env.dart';
import 'package:vendors/app/util/theme.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailsController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: true,
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor), onPressed: () => Get.back()),
            title: Text('${'Order #'.tr} ${value.orderId}', style: ThemeProvider.titleStyle),
            actions: <Widget>[IconButton(onPressed: () => value.launchInBrowser(), icon: const Icon(Icons.print_outlined))],
          ),
          bottomNavigationBar: SizedBox(
            height: 50,
            child: Column(
              children: [
                if (value.orderStatus == 'accepted' || value.orderStatus == 'ongoing')
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => value.openStatusModal(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(color: ThemeProvider.whiteColor, borderRadius: BorderRadius.circular(5), border: Border.all(color: ThemeProvider.greyColor)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  value.selectedStatusId == ''
                                      ? Text('Choose Status'.tr, style: const TextStyle(color: ThemeProvider.greyColor, fontSize: 12))
                                      : Text(value.selectedStatusId.toUpperCase(), style: const TextStyle(color: ThemeProvider.greyColor, fontSize: 12)),
                                  const Icon(Icons.arrow_drop_down_rounded, size: 17, color: ThemeProvider.greyColor),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () => value.changeOrderStatusOption(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.circular(5)),
                              child: Center(child: Text('Update Status'.tr, style: const TextStyle(color: ThemeProvider.whiteColor))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (value.orderStatus == 'created')
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => value.onAcceptOrder(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(color: ThemeProvider.appColor, borderRadius: BorderRadius.circular(5)),
                              child: Center(child: Text('Accept'.tr, style: const TextStyle(color: ThemeProvider.whiteColor))),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () => value.changeOrderStatus('Reject', 'rejected'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(color: ThemeProvider.redColor, borderRadius: BorderRadius.circular(5)),
                              child: Center(child: Text('Reject'.tr, style: const TextStyle(color: ThemeProvider.whiteColor))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (value.orderStatus == 'cancelled')
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text('Order Cancelled by user'.tr, style: const TextStyle(color: ThemeProvider.redColor, fontSize: 14)))]),
                  ),
                if (value.orderStatus == 'delivered')
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text('Order Delivered'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontSize: 14))),
                      ],
                    ),
                  ),
                if (value.orderStatus == 'rejected')
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text('Order Rejected'.tr, style: const TextStyle(color: ThemeProvider.redColor, fontSize: 14)))],
                    ),
                  ),
              ],
            ),
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.appColor),
                )
              : SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: double.infinity,
                          decoration: bottomBorder(),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[Text('Orders'.tr, style: boldText())]),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            Column(
                              children: List.generate(
                                value.details.orders!.length,
                                (orderIndex) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade300))),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: value.details.orders![orderIndex].variations == null
                                              ? [
                                                  Text(value.details.orders![orderIndex].name!.length > 25 ? '${value.details.orders![orderIndex].name!.substring(0, 25)}...' : value.details.orders![orderIndex].name.toString(),
                                                      style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                                  const Text(' - '),
                                                  if (value.details.orders![orderIndex].haveGram == 1)
                                                    Text('${value.details.orders![orderIndex].gram} grams', style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                  else if (value.details.orders![orderIndex].haveKg == 1)
                                                    Text('${value.details.orders![orderIndex].kg} kg', style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                  else if (value.details.orders![orderIndex].haveLiter == 1)
                                                    Text('${value.details.orders![orderIndex].liter} ltr', style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                  else if (value.details.orders![orderIndex].haveMl == 1)
                                                    Text('${value.details.orders![orderIndex].ml} ml', style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start)
                                                  else if (value.details.orders![orderIndex].havePcs == 1)
                                                    Text('${value.details.orders![orderIndex].pcs} pcs', style: const TextStyle(fontSize: 10, fontFamily: 'regular'), textAlign: TextAlign.start),
                                                  const Text(' - '),
                                                  value.details.orders![orderIndex].discount! > 0
                                                      ? value.currencySide == 'left'
                                                          ? Text(value.currencySymbol + value.details.orders![orderIndex].sellPrice.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                          : Text(value.details.orders![orderIndex].sellPrice.toString() + value.currencySymbol, style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                      : value.currencySide == 'left'
                                                          ? Text(value.currencySymbol + value.details.orders![orderIndex].originalPrice.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                          : Text(value.details.orders![orderIndex].originalPrice.toString() + value.currencySymbol, style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                ]
                                              : [
                                                  Text(
                                                    value.details.orders![orderIndex].name!.length > 25 ? '${value.details.orders![orderIndex].name!.substring(0, 25)}...' : value.details.orders![orderIndex].name.toString(),
                                                    style: const TextStyle(fontSize: 10, fontFamily: 'regular'),
                                                  ),
                                                  const Text(' - '),
                                                  Text(value.details.orders![orderIndex].variations![0].items![value.details.orders![orderIndex].variant].title.toString(),
                                                      style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                                  const Text(' - '),
                                                  value.details.orders![orderIndex].variations![0].items![value.details.orders![orderIndex].variant].discount! > 0
                                                      ? value.currencySide == 'left'
                                                          ? Text(value.currencySymbol + value.details.orders![orderIndex].variations![0].items![value.details.orders![orderIndex].variant].discount.toString(),
                                                              style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                          : Text(value.details.orders![orderIndex].variations![0].items![value.details.orders![orderIndex].variant].discount.toString() + value.currencySymbol,
                                                              style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                      : value.currencySide == 'left'
                                                          ? Text(value.currencySymbol + value.details.orders![orderIndex].variations![0].items![value.details.orders![orderIndex].variant].price.toString(),
                                                              style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                          : Text(value.details.orders![orderIndex].variations![0].items![value.details.orders![orderIndex].variant].price.toString() + value.currencySymbol,
                                                              style: const TextStyle(fontSize: 10, fontFamily: 'regular'))
                                                ],
                                        ),
                                        Text('X ${value.details.orders![orderIndex].quantity}', style: const TextStyle(fontSize: 10, fontFamily: 'regular')),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: bottomBorder(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Order Item Total'.tr, style: const TextStyle(fontSize: 10, fontFamily: 'bold')),
                                  value.currencySide == 'left'
                                      ? Text(value.currencySymbol + value.itemTotalStore.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'bold'))
                                      : Text(value.itemTotalStore.toString() + value.currencySymbol, style: const TextStyle(fontSize: 10, fontFamily: 'bold'))
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: bottomBorder(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Order Delivery Charge'.tr, style: const TextStyle(fontSize: 10, fontFamily: 'bold')),
                                  value.currencySide == 'left'
                                      ? Text(value.currencySymbol + value.deliveryChargeStore.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'bold'))
                                      : Text(value.deliveryChargeStore.toString() + value.currencySymbol, style: const TextStyle(fontSize: 10, fontFamily: 'bold'))
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: bottomBorder(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Split Order Tax'.tr, style: const TextStyle(fontSize: 10, fontFamily: 'bold')),
                                  value.currencySide == 'left'
                                      ? Text(value.currencySymbol + value.splitOrderTaxStore.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'bold'))
                                      : Text(value.splitOrderTaxStore.toString() + value.currencySymbol, style: const TextStyle(fontSize: 10, fontFamily: 'bold'))
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: bottomBorder(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Split Order Discount'.tr, style: const TextStyle(fontSize: 10, fontFamily: 'bold')),
                                  value.currencySide == 'left'
                                      ? Text(value.currencySymbol + value.splitOrderDiscountStore.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'bold'))
                                      : Text(value.splitOrderDiscountStore.toString() + value.currencySymbol, style: const TextStyle(fontSize: 10, fontFamily: 'bold'))
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: bottomBorder(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Split Order Wallet Discount'.tr, style: const TextStyle(fontSize: 10, fontFamily: 'bold')),
                                  value.currencySide == 'left'
                                      ? Text(value.currencySymbol + value.splitOrderWalletDiscountStore.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'bold'))
                                      : Text(value.splitOrderWalletDiscountStore.toString() + value.currencySymbol, style: const TextStyle(fontSize: 10, fontFamily: 'bold'))
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: bottomBorder(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Amount To Collect'.tr.toUpperCase(), style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.appColor)),
                                  value.currencySide == 'left'
                                      ? Text(value.currencySymbol + value.grandTotalStore.toString(), style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.appColor))
                                      : Text(value.grandTotalStore.toString() + value.currencySymbol, style: const TextStyle(fontSize: 10, fontFamily: 'bold', color: ThemeProvider.appColor))
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Deliver to'.tr, style: const TextStyle(fontFamily: 'bold', fontSize: 12)),
                              Text(value.details.orderTo.toString().toUpperCase(), style: const TextStyle(fontFamily: 'bold')),
                            ],
                          ),
                        ),
                        value.details.orderTo == 'home'
                            ? Text(
                                '${value.details.address!.landmark.toString().toUpperCase()} ${value.details.address!.house.toString().toUpperCase()} ${value.details.address!.address.toString().toUpperCase()} ${value.details.address!.pincode.toString().toUpperCase()}',
                                style: const TextStyle(fontFamily: 'bold', fontSize: 12))
                            : const SizedBox(),
                        Container(padding: const EdgeInsets.symmetric(vertical: 10), width: double.infinity, decoration: bottomBorder(), child: Text('Basic Detail'.tr, style: boldText())),
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[Text('Order ID'.tr, style: greyFont()), Text(value.details.id.toString(), style: darkFont())]),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[Text('Payment Method'.tr, style: greyFont()), Text(value.details.paidMethod == 'cod' ? 'COD'.tr : 'PAID'.tr, style: darkFont())],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[Text('Delivery On'.tr, style: greyFont()), Text(value.details.dateTime.toString(), style: darkFont())],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(padding: const EdgeInsets.symmetric(vertical: 10), width: double.infinity, decoration: bottomBorder(), child: Text('Order Tracking'.tr, style: boldText())),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: ListView(
                            shrinkWrap: true,
                            children: List.generate(
                              value.details.notes!.length,
                              (index) {
                                return TimelineTile(
                                  alignment: TimelineAlign.start,
                                  lineXY: 0.1,
                                  isFirst: index == 0 ? true : false,
                                  indicatorStyle: const IndicatorStyle(width: 5, color: ThemeProvider.greyColor, padding: EdgeInsets.all(6)),
                                  endChild: getContentOfTracking(value.details.notes![index].value.toString(), value.details.notes![index].time.toString()),
                                  beforeLineStyle: const LineStyle(color: ThemeProvider.greyColor),
                                );
                              },
                            ),
                          ),
                        ),
                        value.userDetails.firstName != null ? const SizedBox(height: 16) : const SizedBox(),
                        value.userDetails.firstName != null
                            ? Container(padding: const EdgeInsets.symmetric(vertical: 10), width: double.infinity, decoration: bottomBorder(), child: Text('User Information'.tr, style: boldText()))
                            : const SizedBox(),
                        value.userDetails.firstName != null
                            ? InkWell(
                                onTap: () => value.openActionModalStore(
                                    '${value.userDetails.firstName} ${value.userDetails.lastName}', value.userDetails.email.toString(), value.userDetails.mobile.toString(), value.userDetails.id.toString(), false, 'user'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: Row(
                                    children: <Widget>[
                                      ClipRRect(
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(30),
                                          child: FadeInImage(
                                            image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.userDetails.cover}'),
                                            placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                            imageErrorBuilder: (context, error, stackTrace) {
                                              return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                                            },
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 16, right: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('${value.userDetails.firstName} ${value.userDetails.lastName}', style: boldText()),
                                            const SizedBox(height: 5),
                                            Row(children: <Widget>[const Icon(Icons.mail, size: 17), const SizedBox(width: 5), Text(value.userDetails.email.toString())]),
                                            const SizedBox(height: 5),
                                            Row(children: <Widget>[const Icon(Icons.call, size: 17), const SizedBox(width: 5), Text(value.userDetails.mobile.toString())]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        value.driverDetails.firstName != null ? const SizedBox(height: 16) : const SizedBox(),
                        value.driverDetails.firstName != null
                            ? Container(padding: const EdgeInsets.symmetric(vertical: 10), width: double.infinity, decoration: bottomBorder(), child: Text('Driver Information'.tr, style: boldText()))
                            : const SizedBox(),
                        value.driverDetails.firstName != null
                            ? InkWell(
                                onTap: () => value.openActionModalStore('${value.driverDetails.firstName} ${value.driverDetails.lastName}', value.driverDetails.email.toString(), value.driverDetails.mobile.toString(),
                                    value.driverDetails.id.toString(), false, 'driver'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: Row(
                                    children: <Widget>[
                                      ClipRRect(
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(30),
                                          child: FadeInImage(
                                            image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.driverDetails.cover}'),
                                            placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                            imageErrorBuilder: (context, error, stackTrace) {
                                              return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                                            },
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 16, right: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('${value.driverDetails.firstName} ${value.driverDetails.lastName}', style: boldText()),
                                            const SizedBox(height: 5),
                                            Row(children: <Widget>[const Icon(Icons.mail, size: 17), const SizedBox(width: 5), Text(value.driverDetails.email.toString())]),
                                            const SizedBox(height: 5),
                                            Row(children: <Widget>[const Icon(Icons.call, size: 17), const SizedBox(width: 5), Text(value.driverDetails.mobile.toString())]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget getContentOfTracking(String title, String message) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(title, style: const TextStyle(color: Color(0xFF636564), fontSize: 12, fontFamily: 'bold')),
              const SizedBox(height: 6),
              Text(message, style: const TextStyle(color: Color(0xFF636564), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  bottomBorder() {
    return BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: ThemeProvider.greyColor.shade300)));
  }

  boldText() {
    return const TextStyle(fontSize: 14, fontFamily: 'bold');
  }

  greyFont() {
    return const TextStyle(color: Colors.grey, fontSize: 12);
  }

  darkFont() {
    return const TextStyle(fontFamily: 'bold', fontSize: 12);
  }
}
