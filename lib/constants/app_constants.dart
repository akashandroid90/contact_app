import 'package:contactapp/model/app_contact.dart';
import 'package:contactapp/model/app_phone.dart';

class ScreenConstants {
  ScreenConstants._();

  static const String CONTACT_LIST_SCREEN = "contact_list_screen";
  static const String UPDATE_CONTACT_SCREEN = "update_screen";
  static const String ADD_CONTACT_SCREEN = "add_screen";
  static const String FAVOURITE_CONTACT_LIST_SCREEN =
      "favourite_contact_list_screen";
}

class StringConstants {
  StringConstants._();

  static const All_CONTACTS = "All Contacts";
  static const ADD_CONTACT = "Add Contact";
  static const UPDATE_CONTACT = "Update Contact";
  static const FAVOURITE_CONTACTS = "Favourite Contacts";
  static const CONTACT_LIST = "Contact List";
}

class AppConstant {
  static const showLoader = 1;
  static const showList = 2;

  static const List<AppContact> list = [];
  static const List<AppPhone> phoneList = [];
}
