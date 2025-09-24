class FavoriteModel {
  final String shoeName;
  final String shoeId;
  final List<String> imageUrl;
  final int shoePrice;
  final List<String> shoeSizes;
  final int discount;
  final String brandName;

  FavoriteModel({
    required this.shoeName,
    required this.shoeId,
    required this.imageUrl,
    required this.shoePrice,
    required this.shoeSizes,
    required this.discount,
    required this.brandName,
  });

  // ADDED: Convert FavoriteModel to JSON Map for SharedPreferences storage
  Map<String, dynamic> toJson() {
    return {
      'shoeName': shoeName,
      'shoeId': shoeId,
      'imageUrl': imageUrl,
      'shoePrice': shoePrice,
      'shoeSizes': shoeSizes,
      'discount': discount,
      'brandName': brandName,
    };
  }

  // ADDED: Create FavoriteModel from JSON Map when loading from SharedPreferences
  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      shoeName: json['shoeName'] ?? '',
      shoeId: json['shoeId'] ?? '',
      imageUrl: List<String>.from(json['imageUrl'] ?? []),
      shoePrice: json['shoePrice'] ?? 0,
      shoeSizes: List<String>.from(json['shoeSizes'] ?? []),
      discount: json['discount'] ?? 0,
      brandName: json['brandName'] ?? '',
    );
  }

  // ADDED: Convert FavoriteModel to String representation for debugging
  @override
  String toString() {
    return 'FavoriteModel(shoeName: $shoeName, shoeId: $shoeId, shoePrice: $shoePrice, brandName: $brandName)';
  }

  // ADDED: Compare two FavoriteModel objects for equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteModel &&
        other.shoeId == shoeId &&
        other.shoeName == shoeName &&
        other.shoePrice == shoePrice &&
        other.brandName == brandName;
  }

  // ADDED: Generate hash code for object comparison
  @override
  int get hashCode {
    return shoeId.hashCode ^
        shoeName.hashCode ^
        shoePrice.hashCode ^
        brandName.hashCode;
  }
}