// ignore: unused_import
import 'package:ladrilho_app/models/imgs_models.dart';
// ignore: unused_import
import 'package:ladrilho_app/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class SqliteController {
  static Database? _db;
  static final SqliteController _instance = SqliteController._internal();

  factory SqliteController() => _instance;

  SqliteController._internal();

  Future<Database> getDatabase() async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ladrilho_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            image TEXT,
            color INTEGER,
            width_cm REAL,
            height_cm REAL,
            notes TEXT,
            created_at TEXT
          )
        ''');
      },
    );
  }

  Future<void> initDb() async {
    await getDatabase();
  }

  Future<void> insertOrder(Map<String, dynamic> order) async {
    final db = await getDatabase();
    await db.insert('orders', order);
  }

  // Buscar todos os pedidos
  Future<List<Map<String, dynamic>>> getAllOrders() async {
    final db = await getDatabase();
    return await db.query('orders', orderBy: 'created_at DESC');
  }

  // Atualizar um pedido pelo id
  Future<int> updateOrder(int id, Map<String, dynamic> order) async {
    final db = await getDatabase();
    return await db.update('orders', order, where: 'id = ?', whereArgs: [id]);
  }

  // Deletar um pedido pelo id
  Future<int> deleteOrder(int id) async {
    final db = await getDatabase();
    return await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }
}

// Exemplo simples em Node.js
