


import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/entities/user.dart';

class LocalDBHelper {
  static Database? _db;

  static Future<Database> get database async{
    if(_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath,'users');

    return await openDatabase(
        path,
        version: 1,
        onCreate: (db,version) async{
          await db.execute('''
            CREATE TABLE users(
            id INTEGER PRIMARY KEY,
            name TEXT,
            email TEXT
          )'''
          );
        }
    );

  }

  static Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  static Future<List<User>> getAllUsers() async {
    final db = await database;
    final result = await db.query('users');
    return result.map((e) => User.fromMap(e)).toList();
  }


}