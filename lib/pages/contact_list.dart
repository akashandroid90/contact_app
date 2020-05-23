import 'package:contactapp/bloc/contact_bloc.dart';
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
    return contactList.length > 0
        ? ListView.builder(
        itemCount: contactList.length,
            itemBuilder: (BuildContext context, int index) {
              final contact = contactList[index];
              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: MemoryImage(contact.avatar),
                  ),
                  title: Text(
                    contact.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            })
        : ScreenMessage(showFav
            ? StringConstants.FAVOURITE_CONTACTS
            : StringConstants.CONTACT_LIST);
  }
}
