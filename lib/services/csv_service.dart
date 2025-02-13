import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:mall_app/models/mall.dart';
import 'package:mall_app/models/shop.dart';

class CSVService {
  static Future<void> appendSingleMallToCSV(Mall mall) async {
    final directory =
        Directory('/storage/emulated/0/Download'); // Public Downloads folder

    final path = "${directory.path}/malls_data.csv";
    final file = File(path);

    bool fileExists = await file.exists();

    // Define the CSV headers
    List<String> headers = [
      "Mall ID",
      "Name",
      "Location",
      "Latitude",
      "Longitude",
      "Total Shops",
      "Opening Hours",
      "Contact Info",
      "Website",
      "Amenities",
      "Average Footfall",
      "Image"
    ];

    // Convert single mall data to CSV row format
    List<String> mallData = [
      mall.mall_id.toString(),
      mall.name,
      mall.location,
      mall.latitude?.toString() ?? "",
      mall.longitude?.toString() ?? "",
      mall.total_shops?.toString() ?? "",
      mall.opening_hours ?? "",
      mall.contact_info,
      mall.website,
      "${mall.amenities?.join(", ") ?? ""}",
      mall.average_footfall?.toString() ?? "",
      mall.image ?? "",
    ];

    String csvRow = const ListToCsvConverter().convert([mallData]);

    // If file does not exist, create it and add headers
    if (!fileExists) {
      String csvHeader = const ListToCsvConverter().convert([headers]);
      await file.writeAsString("$csvHeader\n$csvRow",
          mode: FileMode.write, encoding: utf8);
    } else {
      // Append only the mall data if the file already exists
      await file.writeAsString("\n$csvRow",
          mode: FileMode.append, encoding: utf8);
    }

    print("Mall data appended to: $path");
  }

  static Future<void> appendSingleShopToCSV(Shop shop) async {
    final directory = Directory('/storage/emulated/0/Download');
    final path = "${directory.path}/shops_data.csv";
    final file = File(path);

    bool fileExists = await file.exists();

    // Define the CSV headers
    List<String> headers = [
      "Shop ID",
      "Mall ID",
      "Name",
      "Category",
      "Floor Number",
      "Unit Number",
      "Owner Name",
      "Contact Number",
      "Email",
      "Opening Hours",
      "Products",
      "Avg Monthly Sales",
      "Customer Traffic",
      "Social Media Links",
      "Payment Methods",
      "Image"
    ];

    // Convert single shop data to CSV row format
    List<String> shopData = [
      shop.shop_id.toString(),
      shop.mall_id.toString(),
      shop.name,
      shop.category,
      shop.floor_number?.toString() ?? "",
      shop.unit_number ?? "",
      shop.owner_name,
      shop.contact_number,
      shop.email,
      shop.opening_hours,
      "${shop.products.join(", ")}",
      shop.average_monthly_sales?.toString() ?? "",
      shop.customer_traffic?.toString() ?? "",
      "${shop.social_media_links?.join(", ") ?? ""}",
      "${shop.payment_methods_accepted?.join(", ") ?? ""}",
      shop.image ?? "",
    ];

    String csvRow = const ListToCsvConverter().convert([shopData]);

    // If file does not exist, create it and add headers
    if (!fileExists) {
      String csvHeader = const ListToCsvConverter().convert([headers]);
      await file.writeAsString("$csvHeader\n$csvRow",
          mode: FileMode.write, encoding: utf8);
    } else {
      // Append only the shop data if the file already exists
      await file.writeAsString("\n$csvRow",
          mode: FileMode.append, encoding: utf8);
    }

    print("Shop data appended to: $path");
  }
}
