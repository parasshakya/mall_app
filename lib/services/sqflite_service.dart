import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteService {
  // Singleton instance of the database
  static final SqfliteService _instance = SqfliteService._internal();
  late Database _database;

  factory SqfliteService() {
    return _instance;
  }

  SqfliteService._internal();

  // Initialize the database
  Future<void> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'mall_database.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE malls(mall_id INTEGER PRIMARY KEY, name TEXT, location TEXT, latitude REAL, longitude REAL, contact_info TEXT, website TEXT, opening_hours TEXT, average_footfall INTEGER)',
        );

        db.execute(
          'CREATE TABLE shops(shop_id INTEGER PRIMARY KEY, mall_id INTEGER, name TEXT, category TEXT, owner_name TEXT, contact_number TEXT, email TEXT, opening_hours TEXT, products TEXT, average_monthly_sales REAL, customer_traffic INTEGER, social_media_links TEXT, payment_methods_accepted TEXT, FOREIGN KEY(mall_id) REFERENCES malls(id))',
        );
      },
      version: 1,
    );
  }

  // Insert a mall into the database
  Future<int> insertMall(Map<String, dynamic> mall) async {
    return await _database.insert('malls', mall);
  }

  // Insert a shop into the database
  Future<int> insertShop(Map<String, dynamic> shop) async {
    return await _database.insert('shops', shop);
  }

  // Get all malls from the database
  Future<List<Map<String, dynamic>>> getAllMalls() async {
    return await _database.query('malls');
  }

  // Get all shops from the database by mall_id
  Future<List<Map<String, dynamic>>> getShopsByMallId(int mallId) async {
    return await _database.query(
      'shops',
      where: 'mall_id = ?',
      whereArgs: [mallId],
    );
  }

  // Get a mall by id
  Future<Map<String, dynamic>?> getMallById(int id) async {
    List<Map<String, dynamic>> result = await _database.query(
      'malls',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Get a shop by id
  Future<Map<String, dynamic>?> getShopById(int id) async {
    List<Map<String, dynamic>> result = await _database.query(
      'shops',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Update a mall in the database
  Future<int> updateMall(int id, Map<String, dynamic> mall) async {
    return await _database.update(
      'malls',
      mall,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Update a shop in the database
  Future<int> updateShop(int id, Map<String, dynamic> shop) async {
    return await _database.update(
      'shops',
      shop,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a mall from the database
  Future<int> deleteMall(int id) async {
    return await _database.delete(
      'malls',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a shop from the database
  Future<int> deleteShop(int id) async {
    return await _database.delete(
      'shops',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close the database connection
  Future<void> close() async {
    await _database.close();
  }
}
