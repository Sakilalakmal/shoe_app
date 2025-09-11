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
    required List<String> shoeSizes,
    required int discount,
    required String shoeDescription,
  }) {
    if (state.containsKey(shoeId)) {
      state = {
        ...state,
        shoeId: CartModel(
          shoeName: state[shoeId]!.shoeName,
          shoePrice: state[shoeId]!.shoePrice,
          shoeCategory: state[shoeId]!.shoeCategory,
          imageUrl: state[shoeId]!.imageUrl,
          quantity: state[shoeId]!.quantity + 1,
          shoeId: state[shoeId]!.shoeId,
          shoeSizes: state[shoeId]!.shoeSizes,
          discount: state[shoeId]!.discount,
          shoeDescription: state[shoeId]!.shoeDescription,
          inStock: state[shoeId]!.inStock,
           brandName:state[shoeId]!.brandName,
        ),
      };
    } else {
      state = {
        ...state,
        shoeId: CartModel(
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

  //remove item from carts
  void removeShoesFromCart(String shoeId) {
    state.remove(shoeId);
    
    //notify listener to change state
    state = {...state};
  }

  //function for increment
  void incrementQuantity(String shoeId) {
  if(state.containsKey(shoeId)){
    state[shoeId]!.quantity++;
  } 

  state = {...state};
  }

  //function for decrement
  void decrementQuantity(String shoeId) {
    if(state.containsKey(shoeId) && state[shoeId]!.quantity > 1){
      state[shoeId]!.quantity--;
    } 

    state = {...state};
  }

  double calculateTotalAmount(){
    double totalAmount = 0.0;
    state.forEach((shoeId , cartItem){
      totalAmount += cartItem.quantity * cartItem.shoePrice;
    });

    return totalAmount;
  }

  //getter method for getting shoes data
  Map<String , CartModel> get getCartItem => state;
}
