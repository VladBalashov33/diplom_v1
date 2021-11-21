class CustomLocation {
  final String shortName;
  final String name;
  final String address;
  final String city;
  final double? lng;
  final double? lat;

  CustomLocation({
    required this.shortName,
    required this.name,
    required this.address,
    required this.city,
    this.lng,
    this.lat,
  });

  factory CustomLocation.fromJson(Map<String, dynamic> json) {
    return CustomLocation(
      shortName: json['short_name'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      lng: json['lng'] ?? json['latitude'],
      lat: json['lat'] ?? json['longitude'],
    );
  }
}
