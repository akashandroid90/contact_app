import 'package:contactapp/bloc/contact_bloc.dart';
import 'package:contactapp/bloc/home_bloc.dart';
import 'package:contactapp/constants/app_constants.dart';
import 'package:contactapp/model/app_phone.dart';
import 'package:contactapp/state/contact_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddOrUpdateContactPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ContactBloc _contactBloc;

  Widget _buildAvatarImage() {
    return BlocBuilder(
        bloc: _contactBloc,
        builder: (BuildContext context, ContactState state) {
          return Stack(
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.account_circle,
                    size: 100,
                  ),
                  backgroundImage: state.selectedContact.avatar != null
                      ? MemoryImage(state.selectedContact.avatar)
                      : null,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                      ),
                      onPressed: () => {}),
                ),
              )
            ],
          );
        });
  }

  Widget _buildNameField() {
    return BlocBuilder(
      bloc: _contactBloc,
      builder: (BuildContext context, ContactState state) {
        return TextFormField(
          initialValue: _contactBloc.state.selectedContact.name,
          decoration: InputDecoration(
              labelText: 'Name', filled: true, fillColor: Colors.white),
          keyboardType: TextInputType.text,
          validator: (String value) {
            return value.isEmpty ? "Please enter name" : null;
          },
          onSaved: (String value) {
            state.selectedContact.name = value;
          },
        );
      },
    );
  }

  Widget _buildAddFav() {
    return Row(
      children: <Widget>[
        Expanded(
          child: BlocBuilder(
            bloc: _contactBloc,
            builder: (BuildContext context, ContactState state) {
              return SwitchListTile(
                value: state.selectedContact.favorite,
                onChanged: (bool value) => _contactBloc.changeFavourite(value),
                title: Text('Favorite'),
              );
            },
          ),
        ),
        Expanded(
          child: FlatButton(
            onPressed: _contactBloc.addPhoneNumber,
            child: Text(
              "Add Number",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(AppPhone phone) {
    return TextFormField(
      initialValue: phone.label,
      decoration: InputDecoration(
          labelText: "Label", filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.text,
      onSaved: ((String value) {
        phone.label = value;
      }),
      validator: (String value) {
        return value.isEmpty ? "Please enter label" : null;
      },
    );
  }

  Widget _buildNumber(AppPhone phone) {
    return TextFormField(
        initialValue: phone.number,
        maxLength: 14,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            labelText: "Number", filled: true, fillColor: Colors.white),
        onSaved: ((String value) {
          phone.number = value;
        }),
        validator: (String value) {
          return value.isEmpty ? "Please enter number" : null;
        });
  }

  void _addOrUpdateContact(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _contactBloc.insetOrUpdateContactInDb().then((_) {
        BlocProvider.of<HomeBloc>(context)
            .updateScreen(ScreenConstants.CONTACT_LIST_SCREEN);
      });
    }
  }

  Widget _buildPhoneNumber() {
    return Expanded(
      child: BlocBuilder(
        bloc: _contactBloc,
        builder: (BuildContext context, ContactState state) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.selectedContact.phoneList == null
                ? 0
                : state.selectedContact.phoneList.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      child:
                          _buildLabel(state.selectedContact.phoneList[index]),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    flex: 6,
                    child: _buildNumber(state.selectedContact.phoneList[index]),
                  ),
                  if (index != 0)
                    IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => _contactBloc.removePhoneNumber(index))
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBodyUi(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
        color: Colors.grey.shade100,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildAvatarImage(),
              SizedBox(
                height: 10.0,
              ),
              _buildNameField(),
              SizedBox(
                height: 10.0,
              ),
              _buildAddFav(),
              SizedBox(
                height: 10.0,
              ),
              _buildPhoneNumber(),
              RaisedButton(
                  onPressed: () => _addOrUpdateContact(context),
                  child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _contactBloc = BlocProvider.of<ContactBloc>(context);
    return FutureBuilder(
        future: _contactBloc.fetchContactNumbers(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return _buildBodyUi(context);
        });
  }
}
