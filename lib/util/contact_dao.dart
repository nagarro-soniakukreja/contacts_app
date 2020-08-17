/*

import 'package:contactsapp/model/contact_entity.dart';
import 'package:contactsapp/util/dbhelper.dart';
import 'package:sqflite/sqflite.dart';

class ContactDao{
  final dbhlper = DBHelper();

  Future<int> insertContact(ContactEntity contact) async {
    Database db = await this.dbhlper.db;
    var result = await db.insert(dbhlper.tblContacts, contact.getMap());
    return result;
  }

  Future<List> getContacts() async {
    Database db = await this.dbhlper.db;
    var result = await db.rawQuery("SELECT * FROM ${dbhlper.tblContacts} order by ${dbhlper.colName} ASC");
    return result;
  }

  Future<List> getFavoriteContacts() async {
    Database db = await this.dbhlper.db;
    var result = await db.rawQuery("SELECT * FROM ${dbhlper.tblContacts} where ${dbhlper.colFavorite} = 1 order by ${dbhlper.colName} ASC");
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.dbhlper.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("Select count(*) from ${dbhlper.tblContacts}")
    );
    return result;
  }

  Future<int> updateContact(ContactEntity contact) async{
    Database db = await this.dbhlper.db;
    var result = await db.update(dbhlper.tblContacts, contact.getMap(),
        where: "${dbhlper.colId}=?" , whereArgs: [contact.id]);
    return result;
  }

  Future<int> deleteContact(int id) async{
    Database db = await this.dbhlper.db;
    int result = await db.rawDelete("DELETE FROM ${dbhlper.tblContacts} where ${dbhlper.colId} = '$id'");
    return result;
  }
}*/
