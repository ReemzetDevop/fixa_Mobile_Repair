class CartItem {
  final String serviceId;
  final String serviceName;
  final double serviceCharge;
  final String brand;
  final String model;
  final String image;

  CartItem({
    required this.serviceId,
    required this.serviceName,
    required this.serviceCharge,
    required this.brand,
    required this.model,
    required this.image,
  });

  // Convert CartItem to a Map
  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'serviceName': serviceName,
      'serviceCharge': serviceCharge,
      'brand': brand,
      'model': model,
      'image': image,
    };
  }

  // Convert Map to CartItem
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      serviceId: map['serviceId'] as String,
      serviceName: map['serviceName'] as String,
      serviceCharge: map['serviceCharge'] as double,
      brand: map['brand'] as String,
      model: map['model'] as String,
      image: map['image'] as String,
    );
  }
}
