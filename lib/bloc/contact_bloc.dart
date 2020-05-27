import 'package:contactapp/constants/app_constants.dart';
import 'package:contactapp/data/app_database.dart';
import 'package:contactapp/model/app_contact.dart';
import 'package:contactapp/model/app_phone.dart';
import 'package:contactapp/state/contact_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactBloc extends Bloc<int, ContactState> {
  final appdatabase = AppDatabase();

  @override
  get initialState => ContactState();

  @override
  Stream<ContactState> mapEventToState(event) async* {
    if (event == AppConstant.showLoader)
      yield ContactState(
          showLoader: true,
          contactList: state.contactList,
          selectedContact: state.selectedContact);
    else if (event == AppConstant.showList)
      yield ContactState(
          showLoader: false,
          contactList: state.contactList,
          selectedContact: state.selectedContact);
    else if (event == AppConstant.modifyContact)
      yield ContactState(
          showLoader: state.showLoader,
          contactList: state.contactList,
          selectedContact: state.selectedContact);
    else if (event == AppConstant.modifyPhoneNumber)
      state.selectedContact.phoneList =
          List.from(state.selectedContact.phoneList);
    yield ContactState(
        showLoader: state.showLoader,
        contactList: state.contactList,
        selectedContact: state.selectedContact);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
  }

  void fetchContacts() {
    add(AppConstant.showLoader);
    appdatabase.fetchContacts().then((value) {
      if (value != null) state.contactList = value;
      add(AppConstant.showList);
    }).catchError(onError);
  }

  void addPhoneNumber() {
    state.selectedContact.phoneList.add(AppPhone());
    add(AppConstant.modifyPhoneNumber);
  }

  void removePhoneNumber(int index) {
    state.selectedContact.phoneList.removeAt(index);
    add(AppConstant.modifyPhoneNumber);
  }

  void changeFavourite(bool value) {
    state.selectedContact.favorite = value;
    add(AppConstant.modifyContact);
  }

  void initializeSelectedContact() {
    state.selectedContact = AppContact();
  }

  void setSelectedContact(AppContact contact) {
    state.selectedContact = contact;
  }
}
