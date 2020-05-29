import 'package:contactapp/model/app_contact.dart';
import 'package:contactapp/model/app_phone.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  String tblName = "contact_table";
  String tblPhoneName = "phone_table";
  String colId = "id";
  String colName = "name";
  String colLabel = "label";
  String colNumber = "number";
  String colContactId = "contactId";
  String colAvatar = "avatar";
  String colFav = "favorite";

  AppDatabase._();

  factory AppDatabase() => AppDatabase._();

  Database _db;

  Future<Database> get db async {
    if (_db == null) _db = await initializeDb();
    return _db;
  }

  Future<Database> initializeDb() async {
    return await getApplicationDocumentsDirectory()
        .then((value) => value.path + "contacts.db")
        .then((value) => openDatabase(value, version: 1, onCreate: _createDb));
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblName($colId INTEGER PRIMARY KEY, $colName TEXT, $colAvatar BLOB, $colFav INTEGER default 0)");
    await db.execute(
        "CREATE TABLE $tblPhoneName($colId INTEGER PRIMARY KEY, $colLabel TEXT, $colNumber TEXT, $colContactId INTEGER)");
//    await db.execute("PRAGMA foreign_keys=on");
  }

  Future<int> insertContact(AppContact contact) async {
    var value = await db.then((value) async {
      var rowId = await value.insert(tblName, contact.toMap());
      contact.phoneList.forEach((item) async {
        item.contactId = rowId;
        await value.insert(tblPhoneName, item.toMap());
      });
      return rowId;
    });
    return value;
  }

  Future<List<AppContact>> fetchContacts() async {
    return await db.then((value) {
      return value.query(tblName).then((value) {
        return value.map((element) => AppContact.fromMap(element)).toList();
      });
    });
  }

  Future<List<AppPhone>> fetchContactNumbers(int rowId) async {
    return await db.then((value) async {
      var query = await value
          .query(tblPhoneName, where: colContactId + "=?", whereArgs: [rowId]);
      return query.map((element) => AppPhone.fromMap(element)).toList();
    });
  }

  Future<int> updateContact(AppContact contact) async {
    var value = await db.then((value) async {
      await value
          .delete(tblPhoneName, where: colContactId, whereArgs: [contact.id]);
      var rowId = await value.update(tblName, contact.toMap(),
          where: colId, whereArgs: [contact.id]);
      contact.phoneList.forEach((item) async {
        await value.insert(tblPhoneName, item.toMap());
      });
      return rowId;
    });
    return value;
  }
}
