import 'package:contactapp/bloc/contact_bloc.dart';
import 'package:contactapp/bloc/home_bloc.dart';
import 'package:contactapp/constants/app_constants.dart';
import 'package:contactapp/model/app_contact.dart';
import 'package:contactapp/pages/add_contact.dart';
import 'package:contactapp/pages/contact_list.dart';
import 'package:contactapp/pages/update_contact.dart';
import 'package:contactapp/state/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _homeBloc = HomeBloc();
  final _contactBloc = ContactBloc();

  @override
  void initState() {
    _contactBloc.fetchContacts();
    super.initState();
  }

  Widget _buildSideDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          FlatButton(
              child: Text(StringConstants.All_CONTACTS),
              onPressed: () => {
                    _homeBloc.updateData(ScreenConstants.CONTACT_LIST_SCREEN,
                        StringConstants.CONTACT_LIST),
                    Navigator.pop(context),
                  }),
          FlatButton(
              child: Text(StringConstants.ADD_CONTACT),
              onPressed: () => {
                    _homeBloc.updateData(ScreenConstants.ADD_CONTACT_SCREEN,
                        StringConstants.ADD_CONTACT),
                    Navigator.pop(context),
                  }),
          FlatButton(
              child: Text(StringConstants.FAVOURITE_CONTACTS),
              onPressed: () => {
                    _homeBloc.updateData(
                        ScreenConstants.FAVOURITE_CONTACT_LIST_SCREEN,
                        StringConstants.FAVOURITE_CONTACTS),
                    Navigator.pop(context),
                  })
        ],
      ),
    );
  }

  Widget _buildHomeBody() {
    return BlocBuilder(
        bloc: _homeBloc,
        builder: (BuildContext context, HomeState state) {
          return state.screen == ScreenConstants.ADD_CONTACT_SCREEN ||
                  state.screen == ScreenConstants.UPDATE_CONTACT_SCREEN
              ? AddContactPage(AppContact())
              : state.screen == ScreenConstants.UPDATE_CONTACT_SCREEN
                  ? UpdateContactPage()
                  : BlocProvider<ContactBloc>(
                      create: (_) => _contactBloc,
                      child: ListPage(
                          showFav: state.screen ==
                              ScreenConstants.FAVOURITE_CONTACT_LIST_SCREEN));
        });
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: BlocBuilder(
          bloc: _homeBloc,
          builder: (BuildContext context, HomeState state) {
            return Text(state.title);
          }),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _contactBloc.fetchDeviceContacts)
      ],
    );
  }

  Widget _buildFloatingButton() {
    return BlocBuilder(
        bloc: _homeBloc,
        builder: (BuildContext context, HomeState state) {
          return Visibility(
            visible: state.screen == ScreenConstants.CONTACT_LIST_SCREEN,
            child: FloatingActionButton(
              onPressed: () => {
                _homeBloc.updateData(ScreenConstants.ADD_CONTACT_SCREEN,
                    StringConstants.ADD_CONTACT),
              },
              tooltip: StringConstants.ADD_CONTACT,
              child: Icon(Icons.add),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => _homeBloc,
      child: Scaffold(
        drawer: SafeArea(child: _buildSideDrawer()),
        appBar: _buildAppBar(),
        body: _buildHomeBody(),
        floatingActionButton: _buildFloatingButton(),
      ),
    );
  }

  @override
  void dispose() {
    _contactBloc.close();
    _homeBloc.close();
    super.dispose();
  }
}
