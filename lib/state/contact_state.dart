import 'package:contactapp/model/app_contact.dart';

class ContactState {
  final bool showLoader;
  List<AppContact> contactList;
  int contactId;
  AppContact selectedContact;

  ContactState({this.showLoader = false,
    this.contactList,
    this.contactId = -1,
    this.selectedContact});
}
