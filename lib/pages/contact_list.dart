import 'dart:io';

import 'package:contactapp/bloc/contact_bloc.dart';
import 'package:contactapp/bloc/home_bloc.dart';
import 'package:contactapp/constants/app_constants.dart';
import 'package:contactapp/model/app_contact.dart';
import 'package:contactapp/state/contact_state.dart';
import 'package:contactapp/widget/screen_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactListPage extends StatelessWidget {
  final bool showFav;
  ContactBloc _contactBloc;

  ContactListPage({this.showFav = false});

  Widget _buildListView(List<AppContact> contactList) {
    return ListView.builder(
        itemCount: contactList == null ? 0 : contactList.length,
        itemBuilder: (BuildContext context, int index) {
          final contact = contactList[index];
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: contact.avatar != null
                    ? FileImage(File(contact.avatar))
                    : null,
                child: contact.avatar == null
                    ? Text(
                  contact.name.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )
                    : null,
              ),
              title: Text(
                contact.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: contact.favorite ? Icon(Icons.favorite) : null,
              onTap: () => {
                BlocProvider.of<ContactBloc>(context)
                    .setSelectedContact(contact),
                BlocProvider.of<HomeBloc>(context)
                    .updateScreen(ScreenConstants.UPDATE_CONTACT_SCREEN)
              },
            ),
          );
        });
  }

  Widget _buildMessage() {
    return ScreenMessage(showFav
        ? StringConstants.FAVOURITE_CONTACTS
        : StringConstants.CONTACT_LIST);
  }

  @override
  Widget build(BuildContext context) {
    _contactBloc = BlocProvider.of<ContactBloc>(context);
    return Stack(
      children: <Widget>[
        FutureBuilder<List<AppContact>>(
            future: _contactBloc.fetchContacts(showFav),
            builder: (BuildContext context,
                AsyncSnapshot<List<AppContact>> snapshot) {
              return snapshot.hasData
                  ? snapshot.data.isEmpty
                  ? _buildMessage()
                  : _buildListView(snapshot.data)
                  : _buildMessage();
            }),
        BlocBuilder(
            bloc: _contactBloc,
            builder: (BuildContext context, ContactState state) {
              return Visibility(
                  visible: state.showLoader,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ));
            })
      ],
    );
  }
}
