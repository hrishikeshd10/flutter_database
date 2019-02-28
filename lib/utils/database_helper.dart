import 'package:flutter_database/models/User.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class DataBaseHelper {
  final String tableUser = "userTable";
  final String columnID = "id";
  final String columnUsername = "username";
  final String columnPassword = "password";

  static final DataBaseHelper _instance = new DataBaseHelper.internal();
  factory DataBaseHelper() => _instance;
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DataBaseHelper.internal() ;

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "maindb");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tableUser($columnID INTEGER PRIMARY KEY, $columnUsername TEXT, $columnPassword TEXT)");
  }

  //INSERTION INto THE DATABASE
  Future<int> saveUser(User user) async {
    var dbClient = await db; // ! this is the getDB method to get the database to insert the values into the database

    int res = await dbClient.insert("$tableUser", user.toMap());
    return res;
  }

  // !getting al the users
  Future<List> getAllUSers() async {
    var dbCLient = await db; //! this db is getDB() method
    var result = await dbCLient.rawQuery("SELECT * FROM $tableUser");
    return result.toList();
  }

//FUNCTION TO GET THE COUNT OF ALL USERS
  Future<int> getCount() async {
    var dbClient = await db; //! this db is getDB() method
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableUser"));
  }

//FUNCTION GO GET A SPECIFIC USER;
  Future<User> getUser(int id) async {
    var dbCLient = await db; //!this is the getDB() method;
    var result =
        await dbCLient.rawQuery("SELECT * FROM $tableUser WHERE $columnID = $id");
    if (result.length == 0) return null;
    return new User.fromMap(result.first);
  }

//FUNCTION TO DELETE THE USER
  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableUser, where: "$columnID = ?", whereArgs: [id]);
  }

//function t o update the user;

  Future<int> updateUser(User user) async {
    var dbClient = await db; // !This is the getDb() method;
    return await dbClient.update(tableUser, user.toMap(),
        where: "$columnID=?", whereArgs: [user.id]);
  }

//FUNCTION TO CLOSE THE DATABASE INSTANCE

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
