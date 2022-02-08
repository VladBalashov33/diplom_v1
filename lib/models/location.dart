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
    double? lat;
    double? lng;
    if (json != {}) {
      if (json['name'] == 'Мегаторг') {
        lat = 56.1490265154;
        lng = 40.386934114;
      }
      if (json['name'] == 'Остановка Верхняя Дуброва') {
        lat = 56.1154230612;
        lng = 40.3432530752;
      }
    }
    return CustomLocation(
      shortName: json['short_name'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      lng: json['lng'] ?? lng ?? json['latitude'],
      lat: json['lat'] ?? lat ?? json['longitude'],
    );
  }
  bool get isAddress => name != '' || address != '' || city != '';
}
