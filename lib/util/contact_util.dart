import 'package:flutter_contacts/model/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ContactUtil {
  static final ContactUtil _instance = ContactUtil.internal();

  factory ContactUtil() => _instance;

  ContactUtil.internal();

  Database _db;

  Future<Database> get db async {
    if (_db == null) _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    final dataBasesPath = await getDatabasesPath();
    final path = join(dataBasesPath, 'contacts.db');

    return openDatabase(path, version: 1,
        onCreate: (Database db, int newVersion) async {
      await db.execute(
          'CREATE TABLE ${Contact.contactTable} (${Contact.idColumn} INTEGER PRIMARY KEY, ${Contact.nameColumn} TEXT NOT NULL, ${Contact.emailColumn} TEXT NOT NULL, '
          '${Contact.phoneColumn} TEXT NOT NULL, ${Contact.photoColumn} TEXT)');
    });
  }

  Future<Contact> save(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(Contact.contactTable, contact.toMap());
    return contact;
  }

  Future<List> findAll() async {
    Database dbContact = await db;
    List list =
        await dbContact.rawQuery('SELECT * FROM ${Contact.contactTable}');
    List<Contact> contacts = List();

    for (Map map in list) {
      contacts.add(Contact.fromMap(map));
    }

    return contacts;
  }

  Future<Contact> findOne(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(Contact.contactTable,
        columns: [
          Contact.idColumn,
          Contact.nameColumn,
          Contact.emailColumn,
          Contact.phoneColumn,
          Contact.photoColumn
        ],
        where: '${Contact.idColumn} = ?',
        whereArgs: [id]);

    if (maps.length > 0) return Contact.fromMap(maps.first);

    return null;
  }

  Future<int> update(Contact contact) async {
    Database dbContact = await db;
    return await dbContact.update(Contact.contactTable, contact.toMap(),
        where: '${Contact.idColumn} = ?', whereArgs: [contact.id]);
  }

  Future<int> delete(int id) async {
    Database dbContact = await db;
    return await dbContact.delete(Contact.contactTable,
        where: '${Contact.idColumn} = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    Database dbContact = await db;
    return await dbContact.delete(Contact.contactTable, where: '1 = 1');
  }

  Future<int> getNumber() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact
        .rawQuery('SELECT COUNT(*) FROM ${Contact.contactTable}'));
  }

  Future<Null> close() async {
    Database dbContact = await db;
    return dbContact.close();
  }
}
