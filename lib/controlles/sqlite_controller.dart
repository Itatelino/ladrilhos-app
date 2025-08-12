import 'package:ladrilho_app/models/imgs_models.dart';
import 'package:ladrilho_app/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class SqliteController {
  late final Database _db;

  Future<void> initDb() async {
    // Simula uma inicialização assíncrona, como abrir um banco de dados

    var databasesPath = await getDatabasesPath();
    String path = '$databasesPath/demo.db';

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE User (
          id INTEGER PRIMARY KEY,
          name TEXT,
          email TEXT,
          password TEXT
        )
      ''');
        await db.execute('''
        CREATE TABLE Imgs (
          id TEXT PRIMARY KEY,
          name TEXT,
          url TEXT,
          description TEXT
        )
      ''');
      },
    );
  }

  Future<void> insertUser(UserModel user) async {
    await _db.insert('User', {'name': user.name});
    printDatabase();
  }

  Future<void> insertImgs(ImgsModel imgs) async {
    await _db.insert('Imgs', {'id': imgs.id, 'url': imgs.url});
    printDatabase();
  }

  Future<List<UserModel>> getUsers() async {
    List<Map<String, dynamic>> users = await _db.query('User');
    printDatabase();
    return users.map((e) => UserModel.fromJson(e)).toList();
  }

  Future<List<ImgsModel>> getUserImgs(int userId) async {
    List<Map<String, dynamic>> imgs = await _db.query(
      'Imgs',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    printDatabase();
    return imgs.map((imgs) => ImgsModel.fromJson(imgs)).toList();
  }

  Future<void> deleteUser(int userId) async {
    await _db.delete('User', where: 'id = ?', whereArgs: [userId]);
    await _db.delete('Imgs', where: 'userId = ?', whereArgs: [userId]);
    printDatabase();
  }

  Future<void> deleteImgs(int imgsId) async {
    await _db.delete('Imgs', where: 'id = ?', whereArgs: [imgsId]);
    printDatabase();
  }

  Future<void> updateUser(UserModel user) async {
    await _db.update(
      'User',
      {'name': user.name, 'email': user.email, 'password': user.password},
      where: 'id = ?',
      whereArgs: [user.id],
    );
    printDatabase();
  }

  Future<void> updateImgs(ImgsModel imgs) async {
    await _db.update(
      'Imgs',
      {'name': imgs.name, 'url': imgs.url, 'description': imgs.description},
      where: 'id = ?',
      whereArgs: [imgs.id],
    );
    printDatabase();
  }

  Future<void> printDatabase() async {
    List<Map<String, dynamic>> users = await _db.query('User');
    List<Map<String, dynamic>> imgs = await _db.query('Imgs');

    print('Users:');
    for (var user in users) {
      print(UserModel.fromJson(user));
    }

    print('Imgs:');
    for (var img in imgs) {
      print(ImgsModel.fromJson(img));
    }
  }
}
