class Medicine {
  final String id;
  final String name;
  final String? genericName;
  final String? brandName;
  final String category;
  final String expiryDate;
  final bool availability;
  final double price;
  final int stockQuantity;
  final String description;
  final String manufacturer;
  final bool prescriptionRequired;
  final String? imageUrl;
  final String pharmacistId;

  Medicine({
    required this.id,
    required this.name,
    this.genericName,
    this.brandName,
    this.category = 'General',
    required this.expiryDate,
    required this.availability,
    required this.price,
    this.stockQuantity = 0,
    required this.description,
    required this.manufacturer,
    this.prescriptionRequired = false,
    this.imageUrl,
    required this.pharmacistId,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      genericName: json['genericName'],
      brandName: json['brandName'],
      category: json['category'] ?? 'General',
      expiryDate: json['expiryDate'] ?? '',
      availability: json['availability'] ?? true,
      price: (json['price'] ?? 0.0).toDouble(),
      stockQuantity: json['stockQuantity'] ?? 0,
      description: json['description'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      prescriptionRequired: json['prescriptionRequired'] ?? false,
      imageUrl: json['imageUrl'],
      pharmacistId: json['pharmacistId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'genericName': genericName,
      'brandName': brandName,
      'category': category,
      'expiryDate': expiryDate,
      'availability': availability,
      'price': price,
      'stockQuantity': stockQuantity,
      'description': description,
      'manufacturer': manufacturer,
      'prescriptionRequired': prescriptionRequired,
      'imageUrl': imageUrl,
      'pharmacistId': pharmacistId,
    };
  }
}
