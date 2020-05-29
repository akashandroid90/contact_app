import 'package:contactapp/bloc/contact_bloc.dart';
import 'package:contactapp/bloc/home_bloc.dart';
import 'package:contactapp/constants/app_constants.dart';
import 'package:contactapp/pages/add_or_update_contact.dart';
import 'package:contactapp/pages/contact_list.dart';
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

  Widget _buildSideDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          FlatButton(
              child: Text(StringConstants.All_CONTACTS),
              onPressed: () => {
                    _homeBloc.updateScreen(ScreenConstants.CONTACT_LIST_SCREEN),
                    Navigator.pop(context),
                  }),
          FlatButton(
              child: Text(StringConstants.ADD_CONTACT),
              onPressed: () => {
                    _openAddContactScreen(),
                    Navigator.pop(context),
                  }),
          FlatButton(
              child: Text(StringConstants.FAVOURITE_CONTACTS),
              onPressed: () => {
                _homeBloc.updateScreen(
                    ScreenConstants.FAVOURITE_CONTACT_LIST_SCREEN),
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
        return (state.screen == ScreenConstants.ADD_CONTACT_SCREEN ||
            state.screen == ScreenConstants.UPDATE_CONTACT_SCREEN)
            ? AddOrUpdateContactPage()
            : ContactListPage(
            showFav: state.screen ==
                ScreenConstants.FAVOURITE_CONTACT_LIST_SCREEN);
      },
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: BlocBuilder(
          bloc: _homeBloc,
          builder: (BuildContext context, HomeState state) {
            return Text(state.screen == ScreenConstants.ADD_CONTACT_SCREEN
                ? StringConstants.ADD_CONTACT
                : state.screen == ScreenConstants.UPDATE_CONTACT_SCREEN
                ? StringConstants.UPDATE_CONTACT
                : state.screen == ScreenConstants.CONTACT_LIST_SCREEN
                ? StringConstants.CONTACT_LIST
                : StringConstants.FAVOURITE_CONTACTS);
          }),
    );
  }

  Widget _buildFloatingButton() {
    return BlocBuilder(
        bloc: _homeBloc,
        builder: (BuildContext context, HomeState state) {
          return Visibility(
            visible: state.screen == ScreenConstants.CONTACT_LIST_SCREEN,
            child: FloatingActionButton(
              onPressed: _openAddContactScreen,
              tooltip: StringConstants.ADD_CONTACT,
              child: Icon(Icons.add),
            ),
          );
        });
  }

  void _openAddContactScreen() {
    _contactBloc.initializeSelectedContact();
    _homeBloc.updateScreen(ScreenConstants.ADD_CONTACT_SCREEN);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => _homeBloc,
      child: Scaffold(
        drawer: SafeArea(child: _buildSideDrawer()),
        appBar: _buildAppBar(),
        body: BlocProvider<ContactBloc>(
            create: (_) => _contactBloc, child: _buildHomeBody()),
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
