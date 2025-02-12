import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mall_app/blocs/network_bloc/network_bloc.dart';
import 'package:mall_app/models/shop.dart';

class ShopCard extends StatelessWidget {
  final Shop shop;

  const ShopCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Shop Image
            BlocBuilder<NetworkBloc, NetworkState>(builder: (context, state) {
              if (state is NetworkSuccess) {
                //return Image.network
              } else {
                return shop.image != null
                    ? Image.file(File(shop.image!),
                        fit: BoxFit.cover, height: 200, width: double.infinity)
                    : Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Center(child: Text('No Image Available')),
                      );
              }
              return Container();
            }),

            const SizedBox(height: 10),

            /// Shop Name & Category
            Text(
              shop.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              shop.category,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),

            /// Owner & Contact
            Row(
              children: [
                const Icon(Icons.person, size: 18, color: Colors.blue),
                const SizedBox(width: 5),
                Text(
                  shop.owner_name,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.phone, size: 18, color: Colors.green),
                const SizedBox(width: 5),
                Text(
                  shop.contact_number,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),

            /// Social Media Links
            if (shop.social_media_links != null &&
                shop.social_media_links!.isNotEmpty)
              Row(
                children: shop.social_media_links!.map((link) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      icon: Icon(Icons.contact_mail),
                      onPressed: () {
                        // Handle social media link tap
                      },
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
