import 'package:contactapp/constants/app_constants.dart';
import 'package:contactapp/data/app_database.dart';
import 'package:contactapp/state/contact_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contact/contacts.dart';

class ContactBloc extends Bloc<int, ContactState> {
  final appdatabase = AppDatabase();

  @override
  get initialState => ContactState();

  @override
  Stream<ContactState> mapEventToState(event) async* {
    if (event == AppConstant.showLoader)
      yield ContactState(showLoader: true, contactList: state.contactList);
    else if (event == AppConstant.showList)
      yield ContactState(showLoader: false, contactList: state.contactList);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
  }

  void fetchDeviceContacts() async {
    add(AppConstant.showLoader);
    // Get all contacts on device
    await Contacts.streamContacts().forEach((contact) {
      appdatabase.insertContacts([contact]);
    }).catchError(onError);
    fetchContacts();
    add(AppConstant.showList);
  }

  void fetchContacts() {
    add(AppConstant.showLoader);
    appdatabase.fetchContacts().then((value) {
      if (value != null) state.contactList = value;
      add(AppConstant.showList);
    }).catchError(onError);
  }
}
