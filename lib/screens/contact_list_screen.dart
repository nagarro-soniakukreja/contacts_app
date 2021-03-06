
import 'dart:convert';
import 'dart:typed_data';

import 'package:contactsapp/blocs/contacts.dart';
import 'package:contactsapp/model/contact.dart';
import 'package:contactsapp/screens/add_new_contact_screen.dart';
import 'package:contactsapp/screens/update_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ContactListScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ContactListScreenState();

}

class _ContactListScreenState extends State<ContactListScreen>{
  List contacts;
  String contactImage;
  Uint8List _bytesImage;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsBloc, ContactsState>(
      builder: (context, state){
        return Scaffold(
          body: getBody(state),
          floatingActionButton: FloatingActionButton(
            child: Icon(
                Icons.add
            ),
            onPressed: () {
              navigateToScreen(2);
            },
          ),
        );
      },
    );
  }

  getBody(ContactsState state) {
    if (state is ContactsLoadSuccess) {
      contacts = state.contacts;
      return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (BuildContext context, int pos) {
            contactImage = contacts[pos].image;
            _bytesImage = contactImage!=null?Base64Decoder().convert(contactImage):null;
            return Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: ClipRRect(
                      borderRadius:BorderRadius.circular(40),
                      child:_bytesImage!=null?Image.memory(_bytesImage, fit: BoxFit.cover,width: 77.0, height: 77.0,colorBlendMode: BlendMode.clear,):Icon(
                        Icons.perm_identity,
                        color: Colors.white,
                      )
                  ),
                ),
                title: Text(this.contacts[pos].name),
                onTap: () {
                  navigateToScreen(3, this.contacts[pos]);
                },
              ),
            );
          });
    }
  }

  void getData() {
    if (contacts == null) {
      contacts = List<Contact>();
    }
    BlocProvider.of<ContactsBloc>(context).add(ContactsRequested());

  }


  void navigateToScreen(int i, [Contact contact]) {
    switch(i) {
      case 2:
        moveToAddNewScreen();
        break;
      case 3:
        moveToUpdateScreen(contact);
        break;
    }
  }

  void moveToAddNewScreen() async{
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewContactScreen()));
    if (result != null) {
      showToast(result);
    }
  }

  void moveToUpdateScreen(Contact contact) async{
    var result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UpdateContactScreen(contact)));
    if (result != null) {
      showToast(result);
      getData();
    }
  }

  void showToast(result) {
    Fluttertoast.showToast(msg: result.toString(),toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}