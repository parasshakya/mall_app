class Shop {
  int shop_id;

  int mall_id;

  String name;

  String category;

  int? floor_number;

  String? unit_number;

  String owner_name;

  String contact_number;

  String email;

  String opening_hours;

  List<String> products;

  double? average_monthly_sales;

  int? customer_traffic;

  List<String>? social_media_links;

  List<String>? payment_methods_accepted;

  String? image;

  Shop(
      {required this.shop_id,
      required this.mall_id,
      required this.name,
      required this.category,
      required this.contact_number,
      this.average_monthly_sales,
      this.customer_traffic,
      this.floor_number,
      this.payment_methods_accepted,
      this.social_media_links,
      required this.email,
      required this.opening_hours,
      required this.owner_name,
      this.unit_number,
      this.image,
      required this.products});

  /// Convert Shop object to JSON
  Map<String, dynamic> toJson() {
    return {
      "shop_id": shop_id,
      "mall_id": mall_id,
      "name": name,
      "category": category,
      "floor_number": floor_number,
      "unit_number": unit_number,
      "owner_name": owner_name,
      "contact_number": contact_number,
      "email": email,
      "opening_hours": opening_hours,
      "products": products,
      "average_monthly_sales": average_monthly_sales,
      "customer_traffic": customer_traffic,
      "social_media_links": social_media_links,
      "payment_methods_accepted": payment_methods_accepted,
      "image": image
    };
  }

  /// Create Shop object from JSON
  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
        shop_id: json["shop_id"],
        mall_id: json["mall_id"],
        name: json["name"],
        category: json["category"],
        floor_number: json["floor_number"],
        unit_number: json["unit_number"],
        owner_name: json["owner_name"],
        contact_number: json["contact_number"],
        email: json["email"],
        opening_hours: json["opening_hours"],
        products: List<String>.from(json["products"]),
        average_monthly_sales: json["average_monthly_sales"]?.toDouble(),
        customer_traffic: json["customer_traffic"],
        social_media_links: (json["social_media_links"] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        payment_methods_accepted:
            (json["payment_methods_accepted"] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList(),
        image: json["image"]);
  }
}
