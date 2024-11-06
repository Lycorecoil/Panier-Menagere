/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:vendors/app/backend/models/products_model.dart';

class TopProductsModel {
  int? id;
  ProductsModel? items;
  int? counts;

  TopProductsModel({this.id, this.items, this.counts});

  TopProductsModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    items = json['items'];
    counts = int.parse(json['counts'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['items'] = items;
    data['counts'] = counts;
    return data;
  }
}
