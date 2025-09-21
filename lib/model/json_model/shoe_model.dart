class Shoe {
  final String id;
  final String name;
  final String brandName;
  final double price;
  final double discount;
  final String category;
  final int stock;
  final List<String> sizes;  // List of available sizes
  final String description;
  final List<String> images; // List of image URLs

  // Constructor
  Shoe({
    required this.id,
    required this.name,
    required this.brandName,
    required this.price,
    required this.discount,
    required this.category,
    required this.stock,
    required this.sizes,
    required this.description,
    required this.images,
  });

  // From JSON (deserialization)
  factory Shoe.fromJson(Map<String, dynamic> json) {
    return Shoe(
      id: json['id'],
      name: json['name'],
      brandName: json['brandName'],
      price: json['price'],
      discount: json['discount'],
      category: json['category'],
      stock: json['stock'],
      sizes: List<String>.from(json['sizes']),
      description: json['description'],
      images: List<String>.from(json['images']),
    );
  }

  // To JSON (serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brandName': brandName,
      'price': price,
      'discount': discount,
      'category': category,
      'stock': stock,
      'sizes': sizes,
      'description': description,
      'images': images,
    };
  }
}