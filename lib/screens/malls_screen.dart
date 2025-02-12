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
  bool loading = false;

  loadMalls() async {
    setState(() {
      loading = true;
    });
    _malls = HiveService.getAllMalls();

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    loadMalls();
    super.initState();
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
        body: loading
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
                }));
  }
}
