import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mall_app/blocs/network_bloc/network_bloc.dart';
import 'package:mall_app/models/mall.dart';
import 'package:mall_app/services/hive_service.dart';

class AddMallScreen extends StatefulWidget {
  const AddMallScreen({super.key});

  @override
  State<AddMallScreen> createState() => _AddMallScreenState();
}

class _AddMallScreenState extends State<AddMallScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _mallIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _totalShopsController = TextEditingController();
  final TextEditingController _openingHoursController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _footfallController = TextEditingController();

  // Selected Amenities
  List<String> selectedAmenities = [];
  final List<String> amenitiesOptions = [
    'Parking',
    'WiFi',
    'Food Court',
    'Restrooms',
    'Movie Theater',
    'Kids Play Area'
  ];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      int mallId = int.parse(_mallIdController.text);
      String name = _nameController.text;
      String location = _locationController.text;
      double? latitude = _latitudeController.text.isNotEmpty
          ? double.parse(_latitudeController.text)
          : null;
      double? longitude = _longitudeController.text.isNotEmpty
          ? double.parse(_longitudeController.text)
          : null;
      int? totalShops = _totalShopsController.text.isNotEmpty
          ? int.parse(_totalShopsController.text)
          : null;
      String? openingHours = _openingHoursController.text.isNotEmpty
          ? _openingHoursController.text
          : null;
      String contactInfo = _contactInfoController.text;
      String website = _websiteController.text;
      int? averageFootfall = _footfallController.text.isNotEmpty
          ? int.parse(_footfallController.text)
          : null;

      Mall newMall = Mall(
        mall_id: mallId,
        name: name,
        location: location,
        latitude: latitude,
        longitude: longitude,
        total_shops: totalShops,
        opening_hours: openingHours,
        amenities: selectedAmenities,
        average_footfall: averageFootfall,
        contact_info: contactInfo,
        website: website,
      );

      final networkState = context.read<NetworkBloc>().state;
      if (networkState is NetworkSuccess) {
        //perform network request
      } else {
        //save locally
        await HiveService.saveMall(newMall);
      }
      // You can now use `newMall` for further processing
      print("Mall Data Saved: ${newMall.name}");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Mall Data Saved!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mall Form")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_mallIdController, "Mall ID", "Enter Mall ID",
                    isNumber: true),
                _buildTextField(
                    _nameController, "Mall Name", "Enter Mall Name"),
                _buildTextField(
                    _locationController, "Location", "Enter Location"),
                _buildTextField(
                    _latitudeController, "Latitude", "Enter Latitude",
                    isNumber: true),
                _buildTextField(
                    _longitudeController, "Longitude", "Enter Longitude",
                    isNumber: true),
                _buildTextField(
                    _totalShopsController, "Total Shops", "Enter Total Shops",
                    isNumber: true),
                _buildTextField(_openingHoursController, "Opening Hours",
                    "e.g., 10 AM - 9 PM"),
                _buildTextField(_contactInfoController, "Contact Info",
                    "Enter Contact Info"),
                _buildTextField(_websiteController, "Website", "Enter Website"),
                _buildTextField(_footfallController, "Average Footfall",
                    "Enter Average Footfall",
                    isNumber: true),
                _buildAmenitiesSelector(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hint,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter $label";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildAmenitiesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Amenities",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 10,
          children: amenitiesOptions.map((amenity) {
            return FilterChip(
              label: Text(amenity),
              selected: selectedAmenities.contains(amenity),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    selectedAmenities.add(amenity);
                  } else {
                    selectedAmenities.remove(amenity);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
