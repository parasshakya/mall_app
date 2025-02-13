import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mall_app/blocs/network_bloc/network_bloc.dart';
import 'package:mall_app/models/shop.dart';
import 'package:mall_app/services/csv_service.dart';
import 'package:mall_app/services/excel_service.dart';
import 'package:mall_app/services/hive_service.dart';

class AddShopScreen extends StatefulWidget {
  const AddShopScreen({super.key});

  @override
  State<AddShopScreen> createState() => _AddShopScreenState();
}

class _AddShopScreenState extends State<AddShopScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  XFile? _image;

  // Controllers for text fields
  final TextEditingController _shopIdController = TextEditingController();
  final TextEditingController _mallIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _floorNumberController = TextEditingController();
  final TextEditingController _unitNumberController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _openingHoursController = TextEditingController();
  final TextEditingController _salesController = TextEditingController();
  final TextEditingController _trafficController = TextEditingController();

  // Multi-select lists
  List<String> selectedProducts = [];
  List<String> selectedPaymentMethods = [];
  List<String> selectedSocialMediaLinks = [];

  final List<String> productOptions = [
    'Clothing',
    'Electronics',
    'Food',
    'Jewelry',
    'Books',
    'Cosmetics'
  ];
  final List<String> paymentOptions = [
    'Cash',
    'Credit Card',
    'Mobile Payment',
    'Cryptocurrency'
  ];
  final List<String> socialMediaOptions = [
    'Facebook',
    'Instagram',
    'Twitter',
    'LinkedIn',
    'TikTok'
  ];
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please add image")));
        return;
      }

      int shopId = int.parse(_shopIdController.text);
      int mallId = int.parse(_mallIdController.text);
      String name = _nameController.text;
      String category = _categoryController.text;
      int? floorNumber = _floorNumberController.text.isNotEmpty
          ? int.parse(_floorNumberController.text)
          : null;
      String? unitNumber = _unitNumberController.text.isNotEmpty
          ? _unitNumberController.text
          : null;
      String ownerName = _ownerNameController.text;
      String contactNumber = _contactNumberController.text;
      String email = _emailController.text;
      String openingHours = _openingHoursController.text;
      double? avgSales = _salesController.text.isNotEmpty
          ? double.parse(_salesController.text)
          : null;
      int? customerTraffic = _trafficController.text.isNotEmpty
          ? int.parse(_trafficController.text)
          : null;

      Shop newShop = Shop(
          shop_id: shopId,
          mall_id: mallId,
          name: name,
          category: category,
          floor_number: floorNumber,
          unit_number: unitNumber,
          owner_name: ownerName,
          contact_number: contactNumber,
          email: email,
          opening_hours: openingHours,
          products: selectedProducts,
          average_monthly_sales: avgSales,
          customer_traffic: customerTraffic,
          social_media_links: selectedSocialMediaLinks,
          payment_methods_accepted: selectedPaymentMethods,
          image: _image!.path);

      final networkState = context.read<NetworkBloc>().state;
      if (networkState is NetworkSuccess) {
        //submit shop data to backend
      } else {
        //save shop data locally

        await HiveService.saveShop(newShop);
      }

      await CSVService.appendSingleShopToCSV(newShop);
      await ExcelService.appendSingleShopToExcel(newShop);

      print("Shop Data Added: ${newShop.name}");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Shop Data Saved!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shop Form")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(_shopIdController, "Shop ID", "Enter Shop ID",
                    isNumber: true),
                _buildTextField(_mallIdController, "Mall ID", "Enter Mall ID",
                    isNumber: true),
                _buildTextField(
                    _nameController, "Shop Name", "Enter Shop Name"),
                _buildTextField(
                    _categoryController, "Category", "Enter Category"),
                _buildTextField(_floorNumberController, "Floor Number",
                    "Enter Floor Number",
                    isNumber: true),
                _buildTextField(
                    _unitNumberController, "Unit Number", "Enter Unit Number"),
                _buildTextField(
                    _ownerNameController, "Owner Name", "Enter Owner Name"),
                _buildTextField(_contactNumberController, "Contact Number",
                    "Enter Contact Number"),
                _buildTextField(_emailController, "Email", "Enter Email"),
                _buildTextField(_openingHoursController, "Opening Hours",
                    "e.g., 10 AM - 9 PM"),
                _buildTextField(_salesController, "Avg. Monthly Sales",
                    "Enter Avg. Monthly Sales",
                    isNumber: true),
                _buildTextField(_trafficController, "Customer Traffic",
                    "Enter Customer Traffic",
                    isNumber: true),
                SizedBox(height: 20),
                Center(child: _buildImageSelector()),
                SizedBox(height: 20),
                _buildMultiSelectChips(
                    "Products", productOptions, selectedProducts),
                SizedBox(height: 20),
                _buildMultiSelectChips(
                    "Payment Methods", paymentOptions, selectedPaymentMethods),
                SizedBox(height: 20),
                _buildMultiSelectChips("Social Media Links", socialMediaOptions,
                    selectedSocialMediaLinks),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSelector() {
    return Column(
      children: [
        Text("Shop Image",
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

  Widget _buildMultiSelectChips(
      String label, List<String> options, List<String> selectedItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 10,
          children: options.map((option) {
            return FilterChip(
              label: Text(option),
              selected: selectedItems.contains(option),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    selectedItems.add(option);
                  } else {
                    selectedItems.remove(option);
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
