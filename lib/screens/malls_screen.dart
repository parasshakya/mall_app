import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mall_app/blocs/network_bloc/network_bloc.dart';
import 'package:mall_app/models/mall.dart';
import 'package:mall_app/screens/add_mall_screen.dart';
import 'package:mall_app/services/hive_service.dart';

class MallsScreen extends StatefulWidget {
  const MallsScreen({super.key});

  @override
  State<MallsScreen> createState() => _MallsScreenState();
}

class _MallsScreenState extends State<MallsScreen> {
  List<Mall> _malls = [];
  bool _loading = false;

  loadMalls({bool fromLocalStorage = false}) async {
    setState(() {
      _loading = true;
    });

    if (fromLocalStorage) {
      _malls = HiveService.getAllMalls();
    } else {
      //load malls from backend

      _malls = [];
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Trigger loadMalls() every time the page is visited
    final networkState = context.read<NetworkBloc>().state;
    if (networkState is NetworkSuccess) {
      loadMalls();
    } else {
      loadMalls(fromLocalStorage: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade300,
          title: const Text("Malls"),
          actions: [
            BlocBuilder<NetworkBloc, NetworkState>(builder: (context, state) {
              if (state is NetworkSuccess) {
                return const Text("Connected");
              } else {
                return const Text("not connected");
              }
            }),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddMallScreen()));
              },
            )
          ],
        ),
        body: BlocListener<NetworkBloc, NetworkState>(
          listener: (context, state) {
            if (state is NetworkSuccess) {
              loadMalls();
            } else {
              loadMalls(fromLocalStorage: true);
            }
          },
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: _malls.length,
                  itemBuilder: (context, index) {
                    final mall = _malls[index];
                    return ListTile(
                      title: Text(mall.name),
                    );
                  }),
        ));
  }
}
