import 'package:riverpod/riverpod.dart';
import 'package:shoe_app_assigment/model/cart_model/cart_model.dart';

final cartProvider = StateNotifierProvider<CartNotifier , Map<String , CartModel>>((ref){
  return CartNotifier();
});
class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({});

void addShoesToCart({
    required String shoeName,
    required String brandName,
    required int shoePrice,
    required String shoeCategory,
    required List<String> imageUrl,
    required int quantity,
    required int inStock,
    required String shoeId,
    required String shoeSizes, // still string for one-at-a-time
    required int discount,
    required String shoeDescription,
  }) {
    final cartKey = "$shoeId-$shoeSizes";
    if (state.containsKey(cartKey)) {
      state = {
        ...state,
        cartKey: CartModel(
          shoeName: state[cartKey]!.shoeName,
          shoePrice: state[cartKey]!.shoePrice,
          shoeCategory: state[cartKey]!.shoeCategory,
          imageUrl: state[cartKey]!.imageUrl,
          quantity: state[cartKey]!.quantity + 1,
          shoeId: state[cartKey]!.shoeId,
          shoeSizes: state[cartKey]!.shoeSizes,
          discount: state[cartKey]!.discount,
          shoeDescription: state[cartKey]!.shoeDescription,
          inStock: state[cartKey]!.inStock,
          brandName:state[cartKey]!.brandName,
        ),
      };
    } else {
      state = {
        ...state,
        cartKey: CartModel(
          shoeName: shoeName,
          shoePrice: shoePrice,
          shoeCategory: shoeCategory,
          imageUrl: imageUrl,
          quantity: quantity,
          shoeId: shoeId,
          shoeSizes: shoeSizes,
          discount: discount,
          shoeDescription: shoeDescription,
          inStock: inStock,
          brandName: brandName,
        ),
      };
    }
  }

void removeShoesFromCart(String shoeId, String shoeSize) {
  final cartKey = "$shoeId-$shoeSize";
  state.remove(cartKey);
  state = {...state};
}

void incrementQuantity(String shoeId, String shoeSize) {
  final cartKey = "$shoeId-$shoeSize";
  if(state.containsKey(cartKey)){
    state[cartKey]!.quantity++;
  }
  state = {...state};
}

void decrementQuantity(String shoeId, String shoeSize) {
  final cartKey = "$shoeId-$shoeSize";
  if(state.containsKey(cartKey) && state[cartKey]!.quantity > 1){
    state[cartKey]!.quantity--;
  }
  state = {...state};
}

double calculateTotalAmount() {
  double totalAmount = 0.0;
  state.forEach((shoeId, cartItem) {
    totalAmount += cartItem.quantity * cartItem.shoePrice;
  });
  return totalAmount;
}


  //getter method for getting shoes data
  Map<String , CartModel> get getCartItem => state;
}
