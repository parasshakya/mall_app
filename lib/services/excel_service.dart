import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mall_app/models/shop.dart';
import 'package:mall_app/models/mall.dart';
import 'package:permission_handler/permission_handler.dart';

class ExcelService {
  static Future<void> appendSingleMallToExcel(Mall mall) async {
    if (await _requestStoragePermission()) {
      final directory = Directory('/storage/emulated/0/Download');
      final path = '${directory.path}/malls.xlsx';
      File file = File(path);
      Excel excel;

      if (await file.exists()) {
        // Load existing Excel file
        var bytes = file.readAsBytesSync();
        excel = Excel.decodeBytes(bytes);
      } else {
        // Create a new Excel file
        excel = Excel.createExcel();
      }

      Sheet sheet = excel['Malls'];

      // If the sheet is empty, add headers first
      if (sheet.rows.isEmpty) {
        sheet.appendRow([
          TextCellValue("Mall ID"),
          TextCellValue("Name"),
          TextCellValue("Location"),
          TextCellValue("Latitude"),
          TextCellValue("Longitude"),
          TextCellValue("Total Shops"),
          TextCellValue("Opening Hours"),
          TextCellValue("Contact Info"),
          TextCellValue("Website"),
          TextCellValue("Amenities"),
          TextCellValue("Average Footfall"),
          TextCellValue("Image")
        ]);
      }

      // Append the new mall data
      sheet.appendRow([
        TextCellValue(mall.mall_id.toString()),
        TextCellValue(mall.name),
        TextCellValue(mall.location),
        TextCellValue(mall.latitude?.toString() ?? ""),
        TextCellValue(mall.longitude?.toString() ?? ""),
        TextCellValue(mall.total_shops?.toString() ?? ""),
        TextCellValue(mall.opening_hours ?? ""),
        TextCellValue(mall.contact_info),
        TextCellValue(mall.website),
        TextCellValue(mall.amenities?.join(", ") ?? ""),
        TextCellValue(mall.average_footfall?.toString() ?? ""),
        TextCellValue(mall.image ?? ""),
      ]);

      // Save the Excel file
      List<int>? bytes = excel.save();
      if (bytes != null) {
        File(file.path)
          ..createSync(recursive: true)
          ..writeAsBytesSync(bytes);
      }
    }
  }

  static Future<void> appendSingleShopToExcel(Shop shop) async {
    if (await _requestStoragePermission()) {
      final directory = Directory('/storage/emulated/0/Download');
      final path = "${directory.path}/malls.xlsx";
      final file = File(path);

      Excel excel;

      if (await file.exists()) {
        // Load existing Excel file
        var bytes = file.readAsBytesSync();
        excel = Excel.decodeBytes(bytes);
      } else {
        // Create a new Excel file
        excel = Excel.createExcel();
      }

      Sheet sheet = excel['Shops'];

      // If the sheet is empty, add headers first
      if (sheet.rows.isEmpty) {
        sheet.appendRow([
          TextCellValue("Shop ID"),
          TextCellValue("Mall ID"),
          TextCellValue("Name"),
          TextCellValue("Category"),
          TextCellValue("Floor Number"),
          TextCellValue("Unit Number"),
          TextCellValue("Owner Name"),
          TextCellValue("Contact Number"),
          TextCellValue("Email"),
          TextCellValue("Opening Hours"),
          TextCellValue("Products"),
          TextCellValue("Avg Monthly Sales"),
          TextCellValue("Customer Traffic"),
          TextCellValue("Social Media Links"),
          TextCellValue("Payment Methods"),
          TextCellValue("Image")
        ]);
      }

      // Append the new shop data
      sheet.appendRow([
        TextCellValue(shop.shop_id.toString()),
        TextCellValue(shop.mall_id.toString()),
        TextCellValue(shop.name),
        TextCellValue(shop.category),
        TextCellValue(shop.floor_number?.toString() ?? ""),
        TextCellValue(shop.unit_number ?? ""),
        TextCellValue(shop.owner_name),
        TextCellValue(shop.contact_number),
        TextCellValue(shop.email),
        TextCellValue(shop.opening_hours),
        TextCellValue(shop.products.join(", ")),
        TextCellValue(shop.average_monthly_sales?.toString() ?? ""),
        TextCellValue(shop.customer_traffic?.toString() ?? ""),
        TextCellValue(shop.social_media_links?.join(", ") ?? ""),
        TextCellValue(shop.payment_methods_accepted?.join(", ") ?? ""),
        TextCellValue(shop.image ?? ""),
      ]);

      // Save the Excel file
      List<int>? bytes = excel.save();
      if (bytes != null) {
        File(file.path)
          ..createSync(recursive: true)
          ..writeAsBytesSync(bytes);
      }
    }
  }

  // Request storage permissions
  static Future<bool> _requestStoragePermission() async {
    // Check if permission is already granted
    PermissionStatus status = await Permission.manageExternalStorage.status;
    if (status.isGranted) {
      return true;
    } else {
      // Request permission if not granted
      PermissionStatus statusGranted =
          await Permission.manageExternalStorage.request();

      if (statusGranted.isGranted) {
        return true;
      } else {
        // Optionally, show a message to the user about why permission is needed
        print("Permission to manage external storage denied");
        return false;
      }
    }
  }
}
