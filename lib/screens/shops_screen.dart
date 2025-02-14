import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mall_app/blocs/network_bloc/network_bloc.dart';
import 'package:mall_app/models/shop.dart';
import 'package:mall_app/providers/shops_provider.dart';
import 'package:mall_app/screens/add_shop_screen.dart';
import 'package:mall_app/services/hive_service.dart';
import 'package:mall_app/widgets/shop_card.dart';
import 'package:provider/provider.dart';

class ShopsScreen extends StatefulWidget {
  const ShopsScreen({super.key});

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  bool _loading = true;
  late ShopsProvider _shopsProvider;

  // _loadShops({bool fromLocalStorage = false}) async {
  //   setState(() {
  //     _loading = true;
  //   });

  //   if (fromLocalStorage) {
  //     //load shops from local storage
  //     _shops = HiveService.getAllShops();
  //   } else {
  //     //load shops from backend and save them locally
  //     _shops = [];
  //   }

  //   setState(() {
  //     _loading = false;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadShops();
    });
  }

  _loadShops() {
    final shops = HiveService.getAllShops();
    _shopsProvider.loadShops(shops);
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _shopsProvider = Provider.of<ShopsProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade300,
          title: Text("Shops"),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => AddShopScreen()));
              },
            )
          ],
        ),
        body: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _shopsProvider.shops.length,
                itemBuilder: (context, index) {
                  final shop = _shopsProvider.shops[index];
                  return ShopCard(shop: shop);
                }));
  }
}
