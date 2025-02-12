import 'package:flutter/material.dart';
import 'package:mall_app/screens/add_shop_screen.dart';

class ShopsScreen extends StatelessWidget {
  const ShopsScreen({super.key});

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
        body: Container());
  }
}
