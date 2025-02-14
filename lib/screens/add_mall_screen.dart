import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mall_app/blocs/network_bloc/network_bloc.dart';
import 'package:mall_app/models/mall.dart';
import 'package:mall_app/providers/malls_provider.dart';
import 'package:mall_app/services/csv_service.dart';
import 'package:mall_app/services/excel_service.dart';
import 'package:mall_app/services/hive_service.dart';
import 'package:provider/provider.dart';

class AddMallScreen extends StatefulWidget {
  const AddMallScreen({super.key});

  @override
  State<AddMallScreen> createState() => _AddMallScreenState();
}

class _AddMallScreenState extends State<AddMallScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  XFile? _image;
  late MallsProvider _mallsProvider;

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
  final TextEditingController _openingTimeController = TextEditingController();
  final TextEditingController _closingTimeController = TextEditingController();

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

  // Function to pick image
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source, // Pick image from gallery
    );
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile; // Update the selected image
      }
    });
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        controller.text = pickedTime.format(context);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Please add image")));
        return;
      }
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
      String? openingTime = _openingTimeController.text.isNotEmpty
          ? _openingTimeController.text
          : null;
      String? closingTime = _closingTimeController.text.isNotEmpty
          ? _closingTimeController.text
          : null;
      String? openingHours;

      if (openingTime != null && closingTime != null) {
        openingHours = "$openingTime - $closingTime";
      }

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
          image: _image!.path);

      //save locally
      await HiveService.saveMall(newMall);

      _mallsProvider.addMall(newMall);

      // await CSVService.appendSingleMallToCSV(newMall);
      await ExcelService.appendSingleMallToExcel(newMall);

      // You can now use `newMall` for further processing
      print("Mall Data Saved: ${newMall.name}");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Mall Data Saved!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    _mallsProvider = Provider.of<MallsProvider>(context);
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
                _buildTimeSelector(),
                _buildTextField(_contactInfoController, "Contact Info",
                    "Enter Contact Info"),
                _buildTextField(_websiteController, "Website", "Enter Website"),
                _buildTextField(_footfallController, "Average Footfall",
                    "Enter Average Footfall",
                    isNumber: true),
                SizedBox(
                  height: 20,
                ),
                _buildImageSelector(),
                SizedBox(
                  height: 20,
                ),
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

  Widget _buildTimeSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Operating Hours",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _openingTimeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Opening Time",
                    suffixIcon: Icon(Icons.access_time),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () => _selectTime(context, _openingTimeController),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter opening time";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _closingTimeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Closing Time",
                    suffixIcon: Icon(Icons.access_time),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () => _selectTime(context, _closingTimeController),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter closing time";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Image Selector Widget
  Widget _buildImageSelector() {
    return Column(
      children: [
        Text("Mall Image",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        _image == null
            ? Icon(Icons.image, size: 100, color: Colors.grey)
            : Image.file(
                File(_image!.path),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _showImagePickerOptions,
          child: Text("Upload Photo"),
        ),
      ],
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("From Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text("From Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
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
