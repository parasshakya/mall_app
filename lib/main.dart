import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mall_app/blocs/network_bloc/network_bloc.dart';
import 'package:mall_app/providers/malls_provider.dart';
import 'package:mall_app/providers/shops_provider.dart';
import 'package:mall_app/screens/home_screen.dart';
import 'package:mall_app/services/hive_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.initHive();

  runApp(BlocProvider(
    create: (context) => NetworkBloc()..add(NetworkObserve()),
    child: MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => MallsProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ShopsProvider(),
      )
    ], child: const MainApp()),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}
