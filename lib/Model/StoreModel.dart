class Store {
  String id;
  String name;
  String location;
  String photo;
  String phone; // Phone number for contact
  double latitude; // Geolocation latitude
  double longitude; // Geolocation longitude
  bool isSelected; // Selection property

  Store({
    required this.id,
    required this.name,
    required this.location,
    required this.photo,
    required this.phone, // Required phone parameter
    required this.latitude, // Geolocation latitude
    required this.longitude, // Geolocation longitude
    this.isSelected = false,
  });

  factory Store.fromMap(String id, Map<dynamic, dynamic> map) {
    return Store(
      id: id,
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      photo: map['photo'] ?? '',
      phone: map['phone'] ?? '', // Map the phone property
      latitude: (map['latitude'] is int ? map['latitude'].toDouble() : map['latitude']) ?? 0.0,
      longitude: (map['longitude'] is int ? map['longitude'].toDouble() : map['longitude']) ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'photo': photo,
      'phone': phone, // Include phone in the map
      'latitude': latitude, // Include latitude in the map
      'longitude': longitude, // Include longitude in the map
    };
  }
}
