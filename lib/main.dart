import 'package:contactapp/bloc/contact_bloc.dart';
import 'package:contactapp/bloc/home_bloc.dart';
import 'package:contactapp/constants/app_constants.dart';
import 'package:contactapp/pages/add_or_update_contact.dart';
import 'package:contactapp/pages/contact_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  final _homeBloc = HomeBloc();
  final _contactBloc = ContactBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => _homeBloc,
      child: BlocProvider(
        create: (_) => _contactBloc,
        child: MaterialApp(
          title: StringConstants.APP_NAME,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
//      home: MyHomePage(),
          routes: {
            "/": (BuildContext context) => ContactListPage(),
          },
          onGenerateRoute: (RouteSettings settings) {
            final List<String> pathElements = settings.name.split('/');
            if (pathElements[0] != '') {
              return null;
            }
            if (pathElements[1] == "add_contact") {
              _contactBloc.initializeSelectedContact(list: []);
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => AddOrUpdateContactPage(),
              );
            } else if (pathElements[1] == "update_contact") {
              _contactBloc.initializeSelectedContact();
              _contactBloc.state.selectedContact.id =
                  int.parse(pathElements[2]);
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => AddOrUpdateContactPage(),
              );
            } else if (pathElements[1] == "favourite_contact_list") {
              _contactBloc.initializeSelectedContact();
              _contactBloc.state.selectedContact.id =
                  int.parse(pathElements[2]);
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => ContactListPage(
                  showFav: true,
                ),
              );
            }
            return null;
          },
        ),
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
