

import 'package:contactsapp/model/contact_entity.dart';
import 'package:contactsapp/util/dbhelper.dart';


class ContactsRepository{
  final db = DBHelper();

  Future addNewContact(ContactEntity contact) async => await db.insertContact(contact);

  Future deleteContact(ContactEntity contact) async => await db.deleteContact(contact.id);

  Future getAllContacts() async {
    final maps = await db.getContacts();
    List<ContactEntity> list= List<ContactEntity>.generate(maps.length, (i) {
      return ContactEntity.withId(
        maps[i]['id'],
        maps[i]['name'],
        maps[i]['mobile'],
        maps[i]['landline'],
        maps[i]['favorite'],
        maps[i]['image'],
      );
    });
    return list;
  }

  Future getAllFavoriteContacts() async{
    final maps = await db.getFavoriteContacts();
    List<ContactEntity> list= List<ContactEntity>.generate(maps.length, (i) {
      return ContactEntity.withId(
        maps[i]['id'],
        maps[i]['name'],
        maps[i]['mobile'],
        maps[i]['landline'],
        maps[i]['favorite'],
        maps[i]['image'],
      );
    });
    return list;
  }

  Future updateContact(ContactEntity contact) async => await db.updateContact(contact);
}