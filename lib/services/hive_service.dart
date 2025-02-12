import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mall_app/models/mall.dart';
import 'package:mall_app/models/shop.dart';

class HiveService {
  static late Box mallBox;
  static late Box shopBox;

  /// 🛠️ Initialize Hive
  static Future<void> initHive() async {
    await Hive.initFlutter();

    mallBox = await Hive.openBox("malls");
    shopBox = await Hive.openBox("shops");
  }

  /// Save a Mall to Hive
  static Future<void> saveMall(Mall mall) async {
    await mallBox.put(mall.mall_id.toString(), mall.toJson());
  }

  /// Get a Mall by ID
  static Mall? getMall(int mallId) {
    final mallData = mallBox.get(mallId.toString());
    return mallData != null ? Mall.fromJson(mallData) : null;
  }

  ///Get All Malls
  static List<Mall> getAllMalls() {
    List<Mall> malls = [];
    for (var key in mallBox.keys) {
      final mallData = mallBox.get(key);
      if (mallData != null) {
        malls.add(Mall.fromJson(Map<String, dynamic>.from(
            mallData))); //Map<String, dynamic>.from() is used because hive stores data as _Map<dynamic, dynamic>
      }
    }
    return malls;
  }

  ///Delete a Mall
  static Future<void> deleteMall(int mallId) async {
    await mallBox.delete(mallId.toString());
  }

  /// Save a Shop to Hive
  static Future<void> saveShop(Shop shop) async {
    await shopBox.put(shop.shop_id.toString(), shop.toJson());
  }

  /// Get a Shop by ID
  static Shop? getShop(int shopId) {
    final shopData = shopBox.get(shopId.toString());
    return shopData != null ? Shop.fromJson(shopData) : null;
  }

  /// Get All Shops
  static List<Shop> getAllShops() {
    List<Shop> shops = [];
    for (var key in shopBox.keys) {
      final shopData = shopBox.get(key);
      if (shopData != null) {
        shops.add(Shop.fromJson(Map<String, dynamic>.from(
            shopData))); //Map<String, dynamic>.from() is used because hive stores data as _Map<dynamic, dynamic>
      }
    }
    return shops;
  }

  /// Delete a Shop
  static Future<void> deleteShop(int shopId) async {
    await shopBox.delete(shopId.toString());
  }

  /// Get Shops by Mall ID
  static List<Shop> getShopsByMallId(int mallId) {
    return shopBox.values
        .toList()
        .cast<Map<String, dynamic>>()
        .map((shopData) => Shop.fromJson(shopData))
        .where((shop) => shop.mall_id == mallId)
        .toList();
  }
}
