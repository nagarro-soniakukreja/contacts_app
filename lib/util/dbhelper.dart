import 'dart:io';
import 'package:contactsapp/model/contact_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';


class DBHelper {
  static final DBHelper _dbHelper = new DBHelper._internal();

  String tblContacts = "contacts";
  String colId = "id";
  String colName = "name";
  String colMobile = "mobile";
  String colLandline = "landline";
  String colFavorite = "favorite";
  String colImage = "image";


  DBHelper._internal();

  factory DBHelper() {
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async{
    if(_db == null) {
      _db = await initializeDB();
    }
    return _db;
  }

  Future<Database> initializeDB() async{
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "contacts.db";
    var dbTodos = await openDatabase(path, version:3, onCreate: _createDb);
    return dbTodos;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute(
        "CREATE TABLE $tblContacts ($colId INTEGER PRIMARY KEY,"
            "$colName TEXT, "
            "$colMobile BIGINT, "
            "$colLandline BIGINT, "
            "$colFavorite SMALLINT, "
            "$colImage TEXT)"
    );
  }

//  void _onUpgradeDb(Database db, int oldVersion, int newVersion) {
//    if (oldVersion < newVersion){
//      db.execute("ALTER TABLE $tblContacts ADD COLUMN $colImage TEXT;");
//    }
//  }

  Future<int> insertContact(ContactEntity contact) async {
    Database db = await this.db;
    var result = await db.insert(tblContacts, contact.getMap());
    return result;
  }

  Future<List> getContacts() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblContacts order by $colName ASC");
    return result;
  }

  Future<List> getFavoriteContacts() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblContacts where $colFavorite = 1 order by $colName ASC");
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("Select count(*) from $tblContacts")
    );
    return result;
  }

  Future<int> updateContact(ContactEntity contact) async{
    Database db = await this.db;
    var result = await db.update(tblContacts, contact.getMap(),
        where: "$colId=?" , whereArgs: [contact.id]);
    return result;
  }

  Future<int> deleteContact(int id) async{
    Database db = await this.db;
    int result = await db.rawDelete("DELETE FROM $tblContacts where $colId = '$id'");
    return result;
  }

}