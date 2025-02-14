import 'package:flutter/material.dart';
import 'package:mall_app/models/mall.dart';

class MallsProvider extends ChangeNotifier {
  List<Mall> _malls = [];

  List<Mall> get malls => _malls;

  loadMalls(List<Mall> malls) {
    _malls = malls;
    notifyListeners();
  }

  addMall(Mall mall) {
    _malls.add(mall);
    notifyListeners();
  }
}
