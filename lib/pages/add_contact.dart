import 'package:contactapp/model/app_contact.dart';
import 'package:contactapp/model/app_phone.dart';
import 'package:flutter/material.dart';

class AddContactPage extends StatefulWidget {
  final AppContact contact;

  AddContactPage(this.contact);

  @override
  State<StatefulWidget> createState() {
    return AddContactPageState();
  }
}

class AddContactPageState extends State<AddContactPage> {
  List<AppPhone> phoneNumberList = [AppPhone()];

  Widget _buildAvatarImage() {
    return CircleAvatar(
//          backgroundImage: ImageIcon(Icons.camera_alt),
        );
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Name', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        return "";
      },
      onSaved: (String value) {
//        _formData['email'] = value;
      },
    );
  }

  Widget _buildAddFav() {
    return Row(
      children: <Widget>[
        /* SwitchListTile(
          value: widget.contact.favorite,
          onChanged: (bool value) {
            setState(() {
              widget.contact.favorite = !widget.contact.favorite;
            });
          },
          title: Text('Favorite'),
        ),*/
        FlatButton(
          onPressed: () => {
            setState(() {
              phoneNumberList.add(AppPhone());
            })
          },
          child: Text(
            "Add Number",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumber() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: phoneNumberList.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: TextFormField(
                initialValue: phoneNumberList[index].label,
                decoration: InputDecoration(
                    labelText: "Label", filled: true, fillColor: Colors.white),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Container(
              child: Expanded(
                flex: 6,
                child: TextFormField(
                  initialValue: phoneNumberList[index].number,
                  maxLength: 14,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      labelText: "Number",
                      filled: true,
                      fillColor: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
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
          Positioned(
              child: RaisedButton(
                onPressed: () => {},
                child: Text("Submit"),
              ))
        ],
      ),
    );
  }
}
