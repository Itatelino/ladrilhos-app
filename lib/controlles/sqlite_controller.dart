import 'package:ladrilho_app/models/imgs_model.dart';
import 'package:ladrilho_app/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class SqliteController {
  late final Database _db;

  Future<void> initDb() async {
    // Initialize the SQLite database
    var databasePath = await getDatabasesPath();
    String path = '$databasePath/my_database.db';

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE imgs (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          url TEXT,
          description TEXT
        )
      ''');
        await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT
        )
      ''');
        // Create your tables here
      },
    );
  }

  Future<void> insertUser(UserModel user) async {
    await _db.insert("users", {'name': user.name});
    printDatabase();
  }

  Future<void> insertImage(ImgsModel image) async {
    await _db.insert('Imgs', {'text': image.text, 'userId': image.userId});
    printDatabase();
  }

  Future<List<UserModel>> getUsers() async {
    final List<Map<String, dynamic>> users = await _db.query('User');
    return users.map((e) => UserModel.fromJson(e)).toList();
  }
}

Future<List<ImgsModel>> getUserImages(int userId) async {
  // SELECT * FROM Imgs WHERE userId = ?
  List<Map<String, dynamic>> images = await _db.query(
    'Imgs',
    where: 'userId = ?',
    whereArgs: [userId],
  );
  printDatabase();
  return images.map((image) => ImgsModel.fromJson(image)).toList();
}

Future<void> deleteUser(int id) async {
  await _db.delete('User', where: 'id = ?', whereArgs: [id]);
  await _db.delete('Imgs', where: 'userId = ?', whereArgs: [id]);
  printDatabase();
}

Future<void> deleteImage(int id) async {
  await _db.delete('Imgs', where: 'id = ?', whereArgs: [id]);
  printDatabase();
}

Future<void> updateUser(UserModel user) async {
  await _db.update(
    'User',
    {'name': user.name},
    where: 'id = ?',
    whereArgs: [user.id],
  );
  printDatabase();
}

Future<void> updateImage(ImgsModel image) async {
  await _db.update(
    'Imgs',
    {'text': image.text, 'userId': image.userId},
    where: 'id = ?',
    whereArgs: [image.id],
  );
  printDatabase();
}

Future<void> printDatabase() async {
  final List<Map<String, dynamic>> users = await _db.query('User');

  final List<Map<String, dynamic>> images = await _db.query('Imgs');

  // Print users and images to console
  print('Users');
  for (var user in users) {
    print('ID: ${user['id']}, Name: ${user['name']}');
  }

  print('Images');
  for (var image in images) {
    print(
      'ID: ${image['id']}, Text: ${image['text']}, User ID: ${image['userId']}',
    );
  }
}
