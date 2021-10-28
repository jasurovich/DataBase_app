import 'dart:async';
import 'dart:io';
import 'package:loading/model/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// STEP - 1
class DatabaseHelper {
  static DatabaseHelper? databaseHelper;
  static Database? database;

  factory DatabaseHelper() {
    if (databaseHelper == null) {
      databaseHelper = DatabaseHelper.internal();
      print("DB HELPER NULL EDI. KIRITILMOQDA !");
      return databaseHelper!;
    } else {
      print("DB HELPER BOR. ESKISI ISHLATILMOQDA !");
      return databaseHelper!;
    }
  }

  DatabaseHelper.internal();

  Future<Database> _getDataBase() async {
    if (database == null) {
      print("DB KIRITILMOQDA");
      database = await initDatabase();
      return database!;
    } else {
      print("BOR DB OCHILDI !");
      return database!;
    }
  }

  initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String dbPath = join(folder.path, "User.db"); // PATH
    print("DB PATH: ${dbPath}");
    var UserDb =
        await openDatabase(dbPath, version: 1, onCreate: _createTableDb);
    return UserDb;
  }

  Future<void> _createTableDb(Database db, int version) async {
    print("TABLE KIRITILMOQDA....");
    await db.execute(
        "CREATE TABLE Users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, picture TEXT, radioValue TEXT)");
  }

  Future<int> addUser(User u) async {
    var db = await _getDataBase();
    var result = db.insert('Users', u.toMapToDb());
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    var db = await _getDataBase();
    var result = db.query('Users');
    return result;
  }
}