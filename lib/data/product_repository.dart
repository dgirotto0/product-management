import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/products.dart';

class ProductRepository {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    sqfliteFfiInit();

    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'Database/produtos.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {},
    );
  }

  Future<List<Product>> getAllProductsByTable(
      String tableName, List<String> columns) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i], columns);
    });
  }

  Future<void> insertProduct(
      Product product, String tableName, List<String> columns) async {
    final db = await database;
    final Map<String, dynamic> productMap = product.toMap(columns);

    await db.insert(
      tableName,
      productMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
