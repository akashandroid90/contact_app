import 'package:contactapp/model/app_contact.dart';
import 'package:contactapp/model/app_phone.dart';
import 'package:contactapp/model/contact_with_phone.dart';
import 'package:flutter_contact/contact.dart';
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
  String colFav = "fav";

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
        "CREATE TABLE $tblName($colId INTEGER PRIMARY KEY, $colName TEXT, $colAvatar BLOB, $colFav BOOLEAN)");
    await db.execute(
        "CREATE TABLE $tblPhoneName($colId INTEGER PRIMARY KEY, $colLabel TEXT, $colNumber TEXT, $colContactId INTEGER,"
        " constraint fk_contact_id foreign key($colContactId) references $tblName($colId))");
//    await db.execute("PRAGMA foreign_keys=on");
  }

  Future<List<dynamic>> insertContacts(Iterable<Contact> list) async {
    return await db.then((value) {
      return value.transaction((txn) {
        txn.delete(tblPhoneName);
        txn.delete(tblName);

        list.forEach((element) async {
          var contact =
              AppContact(name: element.displayName, avatar: element.avatar);
          var value = await txn.insert(tblName, contact.toMap());
          element.phones.forEach((item) {
            var phoneContact = AppPhone(
                contactId: value, label: item.label, number: item.value);
            txn.insert(tblPhoneName, phoneContact.toMap());
          });
        });
        return txn.batch().commit();
      });
    });
  }

  Future<List<AppContact>> fetchContacts() async {
    return await db.then((value) {
      return value.query(tblName).then((value) {
        return value.map((element) => AppContact.fromMap(element)).toList();
//        final List<AppContact> list = [];
//        value.forEach((element) {
//          list.add(AppContact.fromMap(element));
//        });
//        return list;
      });
    });
  }

  List<AppPhone> fetchContactWithNumber(int columnId) {
    db.then((value) {
      value.query(tblPhoneName,
          where: colContactId, whereArgs: [columnId]).then((value) {
        final List<AppPhone> list = [];
        value.forEach((element) {
          list.add(AppPhone.fromMap(element));
        });
        return list;
      });
    });
  }

  Future<List<dynamic>> updateContact(ContactWithPhone data) {
    db.then((value) {
      value.transaction((txn) {
        txn.delete(tblPhoneName,
            where: colContactId, whereArgs: [data.id]).then((value) {
          var contact = AppContact.withId(
              id: data.id,
              name: data.name,
              avatar: data.avatar,
              favorite: data.favorite);
          txn.update(tblName, contact.toMap(),
              where: colId, whereArgs: [data.id]).then((value) {
            data.phoneNumber.forEach((item) {
              var phoneContact = AppPhone(
                  contactId: data.id, label: item.label, number: item.number);
              txn.insert(tblPhoneName, phoneContact.toMap());
            });
          });
        });
        return txn.batch().commit();
      });
    });
  }
}
