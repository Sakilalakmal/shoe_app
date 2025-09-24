import 'dart:convert';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoe_app_assigment/model/cart_model/cart_model.dart';

final cartProvider = StateNotifierProvider<CartNotifier, Map<String, CartModel>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({}) {
    // ADDED: Load cart from SharedPreferences when provider is created
    _initializeCart();
  }

  // ADDED: SharedPreferences key for storing cart
  static const String _cartKey = 'shoe_cart';

  // ADDED: Initialize cart by loading from SharedPreferences
  Future<void> _initializeCart() async {
    try {
      await _loadCartFromPrefs();
    } catch (e) {
      print('Error initializing cart: $e');
      // If loading fails, start with empty cart
      state = {};
    }
  }

  // ADDED: Load cart from SharedPreferences
  Future<void> _loadCartFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);
      
      if (cartJson != null && cartJson.isNotEmpty) {
        // Decode JSON string to Map
        final Map<String, dynamic> decodedJson = jsonDecode(cartJson);
        
        // Convert JSON Map to CartModel Map
        final Map<String, CartModel> loadedCart = {};
        
        decodedJson.forEach((key, value) {
          try {
            loadedCart[key] = CartModel.fromJson(value);
          } catch (e) {
            print('Error parsing cart item $key: $e');
            // Skip corrupted items
          }
        });
        
        // Update state with loaded cart
        state = loadedCart;
        print('🛒 Loaded ${loadedCart.length} cart items from storage');
      } else {
        print('📝 No saved cart found - starting fresh');
        state = {};
      }
    } catch (e) {
      print('❌ Error loading cart: $e');
      state = {}; // Fallback to empty cart
    }
  }

  // ADDED: Save current cart to SharedPreferences
  Future<void> _saveCartToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Convert CartModel Map to JSON Map
      final Map<String, dynamic> cartJson = {};
      state.forEach((key, cartModel) {
        cartJson[key] = cartModel.toJson();
      });
      
      // Encode JSON Map to String and save
      final String encodedJson = jsonEncode(cartJson);
      await prefs.setString(_cartKey, encodedJson);
      
      print('💾 Saved ${state.length} cart items to storage');
    } catch (e) {
      print('❌ Error saving cart: $e');
    }
  }

  // ENHANCED: Add shoes to cart with persistent storage
  Future<void> addShoesToCart({
    required String shoeName,
    required String brandName,
    required int shoePrice,
    required String shoeCategory,
    required List<String> imageUrl,
    required int quantity,
    required int inStock,
    required String shoeId,
    required String shoeSizes,
    required int discount,
    required String shoeDescription,
    required String vendorId,
  }) async {
    final cartKey = "$shoeId-$shoeSizes";
    
    if (state.containsKey(cartKey)) {
      // Update existing item quantity
      state = {
        ...state,
        cartKey: state[cartKey]!.copyWith(
          quantity: state[cartKey]!.quantity + 1,
        ),
      };
    } else {
      // Add new item to cart
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
          vendorId: vendorId,
        ),
      };
    }

    // Save to SharedPreferences
    await _saveCartToPrefs();
    
    print('🛒 Added "$shoeName" (Size: $shoeSizes) to cart');
  }

  // ENHANCED: Remove shoes from cart with persistent storage
  Future<void> removeShoesFromCart(String shoeId, String shoeSize) async {
    final cartKey = "$shoeId-$shoeSize";
    final shoeName = state[cartKey]?.shoeName ?? 'Unknown';
    
    // Remove from state
    final newState = Map<String, CartModel>.from(state);
    newState.remove(cartKey);
    state = newState;

    // Save updated cart to SharedPreferences
    await _saveCartToPrefs();
    
    print('🗑️ Removed "$shoeName" (Size: $shoeSize) from cart');
  }

  // ENHANCED: Increment quantity with persistent storage
  Future<void> incrementQuantity(String shoeId, String shoeSize) async {
    final cartKey = "$shoeId-$shoeSize";
    
    if (state.containsKey(cartKey)) {
      state = {
        ...state,
        cartKey: state[cartKey]!.copyWith(
          quantity: state[cartKey]!.quantity + 1,
        ),
      };

      // Save to SharedPreferences
      await _saveCartToPrefs();
      
      print('➕ Incremented quantity for ${state[cartKey]!.shoeName} to ${state[cartKey]!.quantity}');
    }
  }

  // ENHANCED: Decrement quantity with persistent storage
  Future<void> decrementQuantity(String shoeId, String shoeSize) async {
    final cartKey = "$shoeId-$shoeSize";
    
    if (state.containsKey(cartKey) && state[cartKey]!.quantity > 1) {
      state = {
        ...state,
        cartKey: state[cartKey]!.copyWith(
          quantity: state[cartKey]!.quantity - 1,
        ),
      };

      // Save to SharedPreferences
      await _saveCartToPrefs();
      
      print('➖ Decremented quantity for ${state[cartKey]!.shoeName} to ${state[cartKey]!.quantity}');
    }
  }

  // ENHANCED: Calculate total amount (unchanged logic, but now persistent)
  double calculateTotalAmount() {
    double totalAmount = 0.0;
    state.forEach((shoeId, cartItem) {
      totalAmount += cartItem.quantity * cartItem.shoePrice;
    });
    return totalAmount;
  }

  // ADDED: Clear entire cart with persistent storage
  Future<void> clearCart() async {
    state = {};
    await _saveCartToPrefs();
    print('🗑️ Cart cleared');
  }

  // ADDED: Get cart item count
  int get cartItemCount {
    int totalItems = 0;
    state.forEach((key, cartItem) {
      totalItems += cartItem.quantity;
    });
    return totalItems;
  }

  // ADDED: Get unique items count (different from total quantity)
  int get uniqueItemsCount => state.length;

  // ADDED: Check if item is in cart
  bool isInCart(String shoeId, String shoeSize) {
    final cartKey = "$shoeId-$shoeSize";
    return state.containsKey(cartKey);
  }

  // ADDED: Get quantity of specific item
  int getItemQuantity(String shoeId, String shoeSize) {
    final cartKey = "$shoeId-$shoeSize";
    return state[cartKey]?.quantity ?? 0;
  }

  // ADDED: Get cart items as list
  List<CartModel> get cartItemsList => state.values.toList();

  // ADDED: Get all cart keys
  List<String> get cartKeys => state.keys.toList();

  // ADDED: Clear all data and reset (for debugging/testing)
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cartKey);
      state = {};
      print('🔄 Reset all cart data');
    } catch (e) {
      print('❌ Error clearing cart data: $e');
    }
  }

  // EXISTING: Getter method for getting cart data (kept for backward compatibility)
  Map<String, CartModel> get getCartItem => state;
}