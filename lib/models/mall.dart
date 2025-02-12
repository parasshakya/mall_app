class Mall {
  int mall_id;

  String name;

  String location;

  double? latitude;

  double? longitude;

  int? total_shops;

  String? opening_hours;

  String contact_info;

  String website;

  List<String>? amenities;

  int? average_footfall;

  String? image;

  Mall(
      {required this.mall_id,
      required this.name,
      required this.location,
      this.latitude,
      this.longitude,
      this.total_shops,
      this.opening_hours,
      this.amenities,
      this.average_footfall,
      required this.contact_info,
      required this.website,
      this.image});

  /// Convert Mall object to JSON
  Map<String, dynamic> toJson() {
    return {
      "mall_id": mall_id,
      "name": name,
      "location": location,
      "latitude": latitude,
      "longitude": longitude,
      "total_shops": total_shops,
      "opening_hours": opening_hours,
      "contact_info": contact_info,
      "website": website,
      "amenities": amenities,
      "average_footfall": average_footfall,
    };
  }

  /// Create Mall object from JSON
  factory Mall.fromJson(Map<String, dynamic> json) {
    return Mall(
      mall_id: json["mall_id"],
      name: json["name"],
      location: json["location"],
      latitude: json["latitude"]?.toDouble(),
      longitude: json["longitude"]?.toDouble(),
      total_shops: json["total_shops"],
      opening_hours: json["opening_hours"],
      contact_info: json["contact_info"],
      website: json["website"],
      amenities: (json["amenities"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      average_footfall: json["average_footfall"],
    );
  }
}
