import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mall_app/blocs/network_bloc/network_bloc.dart';
import 'package:mall_app/models/mall.dart';

class MallCard extends StatelessWidget {
  final Mall mall;

  const MallCard({required this.mall});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            // Display the image of the mall if available

            mall.image != null
                ? Image.file(File(mall.image!),
                    fit: BoxFit.cover, height: 200, width: double.infinity)
                : Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Center(child: Text('No Image Available')),
                  ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mall Name
                  Text(
                    mall.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  // Mall Location
                  Text(
                    mall.location,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 10),
                  // Mall Opening Hours
                  if (mall.opening_hours != null)
                    Text(
                      'Opening Hours: ${mall.opening_hours}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  SizedBox(height: 10),
                  // Mall Amenities
                  if (mall.amenities != null && mall.amenities!.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.settings, color: Colors.blue),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            'Amenities: ${mall.amenities!.join(', ')}',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 10),
                  // Mall Contact Information
                  Text(
                    'Contact: ${mall.contact_info}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 5),
                  // Mall Website
                  Text(
                    'Website: ${mall.website}',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
