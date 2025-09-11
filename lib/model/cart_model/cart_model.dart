class CartModel {
  final String shoeName;
  final String brandName;
  final int shoePrice;
  final String shoeCategory;
  final List<String> imageUrl;
   int quantity;
  final int inStock;
  final String shoeId;
  final List<String> shoeSizes;
  final int discount;
  final String shoeDescription;

  CartModel( 
     {
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
  });
}
