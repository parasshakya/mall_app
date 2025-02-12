import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mall_app/blocs/network_bloc/network_bloc.dart';
import 'package:mall_app/models/shop.dart';
import 'package:mall_app/screens/add_shop_screen.dart';
import 'package:mall_app/services/hive_service.dart';
import 'package:mall_app/widgets/shop_card.dart';

class ShopsScreen extends StatefulWidget {
  const ShopsScreen({super.key});

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  bool _loading = false;
  List<Shop> _shops = [];

  _loadShops({bool fromLocalStorage = false}) async {
    setState(() {
      _loading = true;
    });

    if (fromLocalStorage) {
      //load shops from local storage
      _shops = HiveService.getAllShops();
    } else {
      //load shops from backend
      _shops = [];
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Trigger loadShops() every time the page is visited
    final networkState = context.read<NetworkBloc>().state;
    if (networkState is NetworkSuccess) {
      _loadShops();
    } else {
      _loadShops(fromLocalStorage: true);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        body: BlocListener<NetworkBloc, NetworkState>(
          listener: (context, state) {
            if (state is NetworkSuccess) {
              _loadShops();
            } else {
              _loadShops(fromLocalStorage: true);
            }
          },
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: _shops.length,
                  itemBuilder: (context, index) {
                    final shop = _shops[index];
                    return ShopCard(shop: shop);
                  }),
        ));
  }
}
