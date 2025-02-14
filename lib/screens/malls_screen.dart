import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mall_app/blocs/network_bloc/network_bloc.dart';
import 'package:mall_app/models/mall.dart';
import 'package:mall_app/providers/malls_provider.dart';
import 'package:mall_app/screens/add_mall_screen.dart';
import 'package:mall_app/services/hive_service.dart';
import 'package:mall_app/widgets/mall_card.dart';
import 'package:provider/provider.dart';

class MallsScreen extends StatefulWidget {
  const MallsScreen({super.key});

  @override
  State<MallsScreen> createState() => _MallsScreenState();
}

class _MallsScreenState extends State<MallsScreen> {
  List<Mall> _malls = [];
  bool _loading = true;
  late MallsProvider _mallsProvider;

  // loadMalls({bool fromLocalStorage = false}) async {
  //   setState(() {
  //     _loading = true;
  //   });

  //   if (fromLocalStorage) {
  //     _malls = HiveService.getAllMalls();
  //   } else {
  //     //load malls from backend and save them locally

  //     _malls = [];
  //   }

  //   setState(() {
  //     _loading = false;
  //   });
  // }

  loadMalls() {
    _malls = HiveService.getAllMalls();
    _mallsProvider.loadMalls(_malls);

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadMalls();
    });
    // Trigger loadMalls() every time the page is visited
    // final networkState = context.read<NetworkBloc>().state;
    // if (networkState is NetworkSuccess) {
    //   loadMalls();
    // } else {
    //   loadMalls(fromLocalStorage: true);
    // }
  }

  @override
  Widget build(BuildContext context) {
    _mallsProvider = Provider.of<MallsProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade300,
          title: const Text("Malls"),
          actions: [
            // BlocBuilder<NetworkBloc, NetworkState>(builder: (context, state) {
            //   if (state is NetworkSuccess) {
            //     return const Text("Connected");
            //   } else {
            //     return const Text("not connected");
            //   }
            // }),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddMallScreen()));
              },
            )
          ],
        ),
        body: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _mallsProvider.malls.length,
                itemBuilder: (context, index) {
                  final mall = _mallsProvider.malls[index];

                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MallCard(
                        mall: mall,
                      ));
                }));
  }
}
