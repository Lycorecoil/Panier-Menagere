/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
class VariationsModel {
  String? title;
  double? price;
  double? discount;

  VariationsModel({this.title, this.price, this.discount});

  VariationsModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    price = double.parse(json['price'].toString());
    discount = double.parse(json['discount'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['price'] = price;
    data['discount'] = discount;
    return data;
  }
}
