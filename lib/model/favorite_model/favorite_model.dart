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
}
