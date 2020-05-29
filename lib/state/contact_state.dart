import 'package:contactapp/model/app_contact.dart';

class ContactState {
  final bool showLoader;
  AppContact selectedContact;

  ContactState({this.showLoader = false, this.selectedContact});
}
