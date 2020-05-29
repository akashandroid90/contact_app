import 'package:contactapp/model/app_contact.dart';

class ContactState {
  List<AppContact> contactList;
  final bool showLoader;
  AppContact selectedContact;

  ContactState(
      {this.showLoader = false, this.contactList, this.selectedContact}) {
    if (contactList == null) contactList = [];
  }
}
