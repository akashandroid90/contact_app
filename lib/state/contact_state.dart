import 'package:contactapp/model/app_contact.dart';

class ContactState {
  final bool showLoader;
  int contactId;
  AppContact selectedContact;

  ContactState(
      {this.showLoader = false, this.contactId = -1, this.selectedContact});
}
