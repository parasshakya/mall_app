import 'package:flutter/material.dart';
import 'package:mall_app/models/shop.dart';

class ShopsProvider extends ChangeNotifier {
  List<Shop> _shops = [];

  List<Shop> get shops => _shops;

  loadShops(List<Shop> shops) {
    _shops = shops;
    notifyListeners();
  }

  addShop(Shop shop) {
    _shops.add(shop);
    notifyListeners();
  }
}
