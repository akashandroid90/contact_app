import 'package:contactapp/state/contact_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactBloc extends Bloc<dynamic, ContactState> {
  @override
  get initialState => ContactState();

  @override
  Stream<ContactState> mapEventToState(event) async* {
    yield ContactState();
  }

  void fetchContacts() {}
}
