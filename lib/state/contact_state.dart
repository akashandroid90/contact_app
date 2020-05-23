import 'package:contactapp/constants/app_constants.dart';
import 'package:contactapp/model/app_contact.dart';

class ContactState {
  List<AppContact> contactList;
  final bool showLoader;

  ContactState({this.showLoader = false, this.contactList = AppConstant.list});
}
