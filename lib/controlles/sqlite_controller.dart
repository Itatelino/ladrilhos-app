import 'package:ladrilho_app/models/imgs_models.dart';
import 'package:ladrilho_app/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class SqliteController {
  late Database _db;

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
}
