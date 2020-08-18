
import 'dart:convert';
import 'dart:typed_data';

import 'package:contactsapp/blocs/favorite_contact/favorite_contact_bloc.dart';
import 'package:contactsapp/blocs/favorite_contact/favorite_event.dart';
import 'package:contactsapp/blocs/favorite_contact/favorite_state.dart';
import 'package:contactsapp/model/contact.dart';
import 'package:contactsapp/screens/update_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';


class FavoriteContactListScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => FavoriteContactListScreenState();

}

class FavoriteContactListScreenState extends State<FavoriteContactListScreen>{
  List<Contact> contacts;
  String contactImage;
  Uint8List _bytesImage;

  @override
  void initState() {
    super.initState();
    if (contacts == null)
      contacts = List<Contact>();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteContactsBloc, FavoriteContactsState>(
      builder: (context, state) {
        return Scaffold(
          body: getBody(state),
        );
      },
    );
  }

  getBody(FavoriteContactsState state) {
    if (state is FavoriteContactsLoadSuccess) {
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
                  moveToUpdateScreen(this.contacts[pos]);
                },
              ),
            );
          });
    }
  }

  void getData() {
    BlocProvider.of<FavoriteContactsBloc>(context).add(FavoriteContactRequested());
  }

  void moveToUpdateScreen(Contact contact) async{
    var result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UpdateContactScreen(contact)));
    if (result != null) {
      Fluttertoast.showToast(msg: result.toString(),toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      getData();
    }
  }
}