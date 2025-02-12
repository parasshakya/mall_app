import 'package:flutter/material.dart';
import 'package:mall_app/screens/malls_screen.dart';
import 'package:mall_app/screens/shops_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _screens = [const MallsScreen(), const ShopsScreen()];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
            body: TabBarView(
              children: _screens,
            ),
            bottomNavigationBar: const TabBar(
              tabs: [
                Tab(
                  child: Text("🏬 Malls"),
                ),
                Tab(
                  child: Text("🏪 Shops"),
                ),
              ],
            )),
      ),
    );
  }
}
