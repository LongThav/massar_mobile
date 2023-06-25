import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CartDB {
  static const product = 'product';

  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'cartdb.db'),
      onCreate: (db, version) {
      db.execute('CREATE TABLE $product(id TEXT PRIMARY KEY,'
          ' cartName TEXT,'
          ' cartSellerName TEXT,'
          ' cartPrice TEXT,'
          ' cartRate TEXT,'
          ' cartImage TEXT,'
          ' cartDiscount TEXT)');
    },
    version: 2
   );
  }

  static Future addItemCart(String table, Map<String, Object> data) async {
    final db = await CartDB.database();
    return db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> readItemCart() async {
    final db = await CartDB.database();
    var select = await db.query(CartDB.product);
    return select;
  }

  static Future<void> deleteById(
      String table, String columnId, String id) async {
    final db = await CartDB.database();
    await db.delete(table, where: "$columnId = ?", whereArgs: [id]);
  }

  static Future deleteTable(String table)async{
    final db = await CartDB.database();
    return db.rawDelete('DELETE FROM $product');
  }
}
