import 'dart:typed_data';

class AppContact {
  int id;
  String name;
  Uint8List avatar;
  bool favorite;

  AppContact({this.name, this.avatar, this.favorite = false});

  AppContact.withId({this.id, this.name, this.avatar, this.favorite = false});

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
      "favorite": favorite,
    };
  }
}
