import 'dart:typed_data';

import 'package:contactapp/constants/app_constants.dart';
import 'package:contactapp/model/app_phone.dart';

class AppContact {
  int id;
  String name;
  Uint8List avatar;
  bool _favorite;
  List<AppPhone> phoneList;

  AppContact(
      {this.name = "",
      this.avatar,
      favorite = false,
      this.phoneList = AppConstant.phoneList});

  AppContact.withId(
      {this.id,
      this.name,
      this.avatar,
      favorite = false,
      this.phoneList = AppConstant.phoneList});

  factory AppContact.fromMap(Map<String, dynamic> map) {
    return AppContact.withId(
        id: map["id"],
        name: map["name"],
        avatar: map["avatar"],
        favorite: map["favorite"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "avatar": avatar,
      "favorite": _favorite,
    };
  }

  set favorite(bool value) {
    _favorite = value;
  }

  bool get favorite => _favorite;
}
