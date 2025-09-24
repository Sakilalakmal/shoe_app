class CartModel {
  final String shoeName;
  final String brandName;
  final int shoePrice;
  final String shoeCategory;
  final List<String> imageUrl;
  int quantity; // Mutable for quantity changes
  final int inStock;
  final String shoeId;
  final String shoeSizes;
  final int discount;
  final String shoeDescription;
  final String vendorId;

  CartModel({
    required this.shoeName,
    required this.shoePrice,
    required this.shoeCategory,
    required this.imageUrl,
    required this.quantity,
    required this.shoeId,
    required this.shoeSizes,
    required this.discount,
    required this.shoeDescription,
    required this.inStock,
    required this.brandName,
    required this.vendorId,
  });

  // ADDED: Convert CartModel to JSON Map for SharedPreferences storage
  Map<String, dynamic> toJson() {
    return {
      'shoeName': shoeName,
      'brandName': brandName,
      'shoePrice': shoePrice,
      'shoeCategory': shoeCategory,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'inStock': inStock,
      'shoeId': shoeId,
      'shoeSizes': shoeSizes,
      'discount': discount,
      'shoeDescription': shoeDescription,
      'vendorId': vendorId,
    };
  }

  // ADDED: Create CartModel from JSON Map when loading from SharedPreferences
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      shoeName: json['shoeName'] ?? '',
      brandName: json['brandName'] ?? '',
      shoePrice: json['shoePrice'] ?? 0,
      shoeCategory: json['shoeCategory'] ?? '',
      imageUrl: List<String>.from(json['imageUrl'] ?? []),
      quantity: json['quantity'] ?? 1,
      inStock: json['inStock'] ?? 0,
      shoeId: json['shoeId'] ?? '',
      shoeSizes: json['shoeSizes'] ?? '',
      discount: json['discount'] ?? 0,
      shoeDescription: json['shoeDescription'] ?? '',
      vendorId: json['vendorId'] ?? '',
    );
  }

  // ADDED: Create a copy with updated quantity (immutable pattern)
  CartModel copyWith({
    String? shoeName,
    String? brandName,
    int? shoePrice,
    String? shoeCategory,
    List<String>? imageUrl,
    int? quantity,
    int? inStock,
    String? shoeId,
    String? shoeSizes,
    int? discount,
    String? shoeDescription,
    String? vendorId,
  }) {
    return CartModel(
      shoeName: shoeName ?? this.shoeName,
      brandName: brandName ?? this.brandName,
      shoePrice: shoePrice ?? this.shoePrice,
      shoeCategory: shoeCategory ?? this.shoeCategory,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      inStock: inStock ?? this.inStock,
      shoeId: shoeId ?? this.shoeId,
      shoeSizes: shoeSizes ?? this.shoeSizes,
      discount: discount ?? this.discount,
      shoeDescription: shoeDescription ?? this.shoeDescription,
      vendorId: vendorId ?? this.vendorId,
    );
  }

  // ADDED: String representation for debugging
  @override
  String toString() {
    return 'CartModel(shoeName: $shoeName, quantity: $quantity, size: $shoeSizes, price: $shoePrice)';
  }

  // ADDED: Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartModel &&
        other.shoeId == shoeId &&
        other.shoeSizes == shoeSizes &&
        other.shoeName == shoeName;
  }

  // ADDED: Hash code for object comparison
  @override
  int get hashCode {
    return shoeId.hashCode ^ shoeSizes.hashCode ^ shoeName.hashCode;
  }
}