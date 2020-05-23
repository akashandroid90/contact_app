import 'package:contactapp/constants/app_constants.dart';
import 'package:contactapp/data/app_database.dart';
import 'package:contactapp/state/contact_state.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  void fetchDeviceContacts() {
    add(AppConstant.showLoader);
    // Get all contacts on device
    ContactsService.getContacts().then((value) {
      if (value.length > 0) {
        appdatabase.insertContacts(value).then((value) => fetchContacts());
      } else
        add(AppConstant.showList);
    }).catchError(onError);
  }

  void fetchContacts() {
    add(AppConstant.showLoader);
    appdatabase.fetchContacts().then((value) {
      if (value != null) state.contactList = value;
      add(AppConstant.showList);
    }).catchError(onError);
  }
}
