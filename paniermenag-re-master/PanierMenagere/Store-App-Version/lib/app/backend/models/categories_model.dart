/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
class CategoriesModel {
  int? id;
  String? name;
  String? cover;
  String? extraField;
  int? status;

  CategoriesModel({this.id, this.name, this.cover, this.extraField, this.status});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'];
    cover = json['cover'];
    extraField = json['extra_field'];
    status = int.parse(json['status'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cover'] = cover;
    data['extra_field'] = extraField;
    data['status'] = status;
    return data;
  }
}
