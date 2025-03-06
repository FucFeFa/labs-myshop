import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CartService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'cart.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE cart (
            id TEXT PRIMARY KEY,
            title TEXT,
            price REAL,
            quantity INTEGER
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> addToCart(String id, String title, double price, int quantity) async {
    final db = await database;
    await db.insert(
      'cart',
      {'id': id, 'title': title, 'price': price, 'quantity': quantity},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await database;
    return await db.query('cart');
  }

  Future<void> removeItem(String id) async {
    final db = await database;
    await db.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart');
  }
}
