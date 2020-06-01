import 'dart:io';

import 'package:contactapp/bloc/contact_bloc.dart';
import 'package:contactapp/bloc/home_bloc.dart';
import 'package:contactapp/constants/app_constants.dart';
import 'package:contactapp/model/app_contact.dart';
import 'package:contactapp/state/contact_state.dart';
import 'package:contactapp/state/home_state.dart';
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
                Navigator.pushNamed<bool>(
                    context, "/update_contact/${contact.id}")
              },
            ),
          );
        });
  }

  Widget _buildMessage() {
    return BlocBuilder(
        bloc: _contactBloc,
        builder: (BuildContext context, ContactState state) {
          return Visibility(
              visible: !state.showLoader,
              child: ScreenMessage(showFav
                  ? StringConstants.FAVOURITE_CONTACTS
                  : StringConstants.CONTACT_LIST));
        });
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: FlatButton(
                child: Text(StringConstants.All_CONTACTS),
                onPressed: () => {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/", ModalRoute.withName('/')),
                    }),
          ),
          Container(
            width: double.infinity,
            child: FlatButton(
                child: Text(StringConstants.ADD_CONTACT),
                onPressed: () => {
                      Navigator.pop(context),
                      Navigator.pushNamed(context, "/add_contact"),
                    }),
          ),
          Container(
            width: double.infinity,
            child: FlatButton(
                child: Text(StringConstants.FAVOURITE_CONTACTS),
                onPressed: () => {
                      Navigator.pushNamedAndRemoveUntil(context,
                          "/favourite_contact_list", ModalRoute.withName('/')),
                    }),
          )
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: BlocBuilder(
          bloc: BlocProvider.of<HomeBloc>(context),
          builder: (BuildContext context, HomeState state) {
            return Text(showFav
                ? StringConstants.FAVOURITE_CONTACTS
                : StringConstants.CONTACT_LIST);
          }),
    );
  }

  Widget _buildFloatingButton(BuildContext context) {
    return BlocBuilder(
        bloc: BlocProvider.of<HomeBloc>(context),
        builder: (BuildContext context, HomeState state) {
          return FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, "/add_contact")
                .then((value) => null),
            tooltip: StringConstants.ADD_CONTACT,
            child: Icon(Icons.add),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _contactBloc = BlocProvider.of<ContactBloc>(context);
    return Scaffold(
      drawer: SafeArea(child: _buildSideDrawer(context)),
      appBar: _buildAppBar(context),
      body: Stack(
        children: <Widget>[
          FutureBuilder<List<AppContact>>(
              future: _contactBloc.fetchContacts(showFav),
              builder: (BuildContext context,
                  AsyncSnapshot<List<AppContact>> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return snapshot.hasData
                      ? snapshot.data.isEmpty
                      ? _buildMessage()
                      : _buildListView(snapshot.data)
                      : _buildMessage();
                }
              }),
        ],
      ),
      floatingActionButton: _buildFloatingButton(context),
    );
  }
}
