import 'package:contactapp/bloc/contact_bloc.dart';
import 'package:contactapp/bloc/home_bloc.dart';
import 'package:contactapp/constants/app_constants.dart';
import 'package:contactapp/widget/screen_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListPage extends StatelessWidget {
  final bool showFav;

  ListPage({this.showFav = false});

  @override
  Widget build(BuildContext context) {
    final contactList = BlocProvider.of<ContactBloc>(context).state.contactList;
    return (contactList != null && contactList.length > 0)
        ? ListView.builder(
            itemCount: contactList == null ? 0 : contactList.length,
            itemBuilder: (BuildContext context, int index) {
              final contact = contactList[index];
              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: contact.avatar != null
                        ? MemoryImage(contact.avatar)
                        : null,
                    child: contact.avatar == null
                        ? Text(
                            contact.name.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        : null,
                  ),
                  title: Text(
                    contact.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () => {
                    BlocProvider.of<ContactBloc>(context)
                        .setSelectedContact(contact),
                    BlocProvider.of<HomeBloc>(context).updateData(
                        ScreenConstants.ADD_CONTACT_SCREEN,
                        StringConstants.UPDATE_CONTACT)
                  },
                ),
              );
            })
        : ScreenMessage(showFav
            ? StringConstants.FAVOURITE_CONTACTS
            : StringConstants.CONTACT_LIST);
  }
}
