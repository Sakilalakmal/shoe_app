import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoe_app_assigment/model/favorite_model/favorite_model.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, Map<String, FavoriteModel>>((ref) {
  return FavoriteNotifier();
});

class FavoriteNotifier extends StateNotifier<Map<String, FavoriteModel>> {
  FavoriteNotifier() : super({}) {
    // ADDED: Load favorites from SharedPreferences when provider is created
    _initializeFavorites();
  }

  // ADDED: SharedPreferences key for storing favorites
  static const String _favoritesKey = 'shoe_favorites';

  // ADDED: Initialize favorites by loading from SharedPreferences
  Future<void> _initializeFavorites() async {
    try {
      await _loadFavoritesFromPrefs();
    } catch (e) {
      print('Error initializing favorites: $e');
      // If loading fails, start with empty state
      state = {};
    }
  }

  // ADDED: Load favorites from SharedPreferences
  Future<void> _loadFavoritesFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString(_favoritesKey);
      
      if (favoritesJson != null && favoritesJson.isNotEmpty) {
        // Decode JSON string to Map
        final Map<String, dynamic> decodedJson = jsonDecode(favoritesJson);
        
        // Convert JSON Map to FavoriteModel Map
        final Map<String, FavoriteModel> loadedFavorites = {};
        
        decodedJson.forEach((key, value) {
          try {
            loadedFavorites[key] = FavoriteModel.fromJson(value);
          } catch (e) {
            print('Error parsing favorite item $key: $e');
            // Skip corrupted items
          }
        });
        
        // Update state with loaded favorites
        state = loadedFavorites;
        print('✅ Loaded ${loadedFavorites.length} favorites from storage');
      } else {
        print('📝 No saved favorites found - starting fresh');
        state = {};
      }
    } catch (e) {
      print('❌ Error loading favorites: $e');
      state = {}; // Fallback to empty state
    }
  }

  // ADDED: Save current favorites to SharedPreferences
  Future<void> _saveFavoritesToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Convert FavoriteModel Map to JSON Map
      final Map<String, dynamic> favoritesJson = {};
      state.forEach((key, favoriteModel) {
        favoritesJson[key] = favoriteModel.toJson();
      });
      
      // Encode JSON Map to String and save
      final String encodedJson = jsonEncode(favoritesJson);
      await prefs.setString(_favoritesKey, encodedJson);
      
      print('💾 Saved ${state.length} favorites to storage');
    } catch (e) {
      print('❌ Error saving favorites: $e');
    }
  }

  // ENHANCED: Add shoe to favorites with persistent storage
  Future<void> addShoesToFavorite({
    required String shoeName,
    required String shoeId,
    required List<String> imageUrl,
    required int shoePrice,
    required List<String> shoeSizes,
    required int discount,
    required String brandName,
  }) async {
    // Create new favorite item
    final favoriteItem = FavoriteModel(
      shoeName: shoeName,
      shoeId: shoeId,
      imageUrl: imageUrl,
      shoePrice: shoePrice,
      shoeSizes: shoeSizes,
      discount: discount,
      brandName: brandName,
    );

    // Add to state
    state = {
      ...state,
      shoeId: favoriteItem,
    };

    // Save to SharedPreferences
    await _saveFavoritesToPrefs();
    
    print('❤️ Added "$shoeName" to favorites');
  }

  // ENHANCED: Remove all favorites with persistent storage
  Future<void> removeAllFavoriteShoes() async {
    // Clear state
    state = {};

    // Clear SharedPreferences
    await _saveFavoritesToPrefs();
    
    print('🗑️ Cleared all favorites');
  }

  // ENHANCED: Remove specific shoe from favorites with persistent storage
  Future<void> removeShoeFromFavorite(String shoeId) async {
    final shoeName = state[shoeId]?.shoeName ?? 'Unknown';
    
    // Remove from state
    final newState = Map<String, FavoriteModel>.from(state);
    newState.remove(shoeId);
    state = newState;

    // Save updated state to SharedPreferences
    await _saveFavoritesToPrefs();
    
    print('💔 Removed "$shoeName" from favorites');
  }

  // ADDED: Check if shoe is in favorites
  bool isFavorite(String shoeId) {
    return state.containsKey(shoeId);
  }

  // ADDED: Get favorite count
  int get favoritesCount => state.length;

  // ADDED: Get all favorite shoe IDs
  List<String> get favoriteShoeIds => state.keys.toList();

  // ADDED: Get all favorite shoes as list
  List<FavoriteModel> get favoriteShoesList => state.values.toList();

  // ADDED: Toggle favorite status
  Future<void> toggleFavorite({
    required String shoeId,
    required String shoeName,
    required List<String> imageUrl,
    required int shoePrice,
    required List<String> shoeSizes,
    required int discount,
    required String brandName,
  }) async {
    if (isFavorite(shoeId)) {
      await removeShoeFromFavorite(shoeId);
    } else {
      await addShoesToFavorite(
        shoeName: shoeName,
        shoeId: shoeId,
        imageUrl: imageUrl,
        shoePrice: shoePrice,
        shoeSizes: shoeSizes,
        discount: discount,
        brandName: brandName,
      );
    }
  }

  // ADDED: Clear all data and reset (for debugging/testing)
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_favoritesKey);
      state = {};
      print('🔄 Reset all favorite data');
    } catch (e) {
      print('❌ Error clearing data: $e');
    }
  }

  // EXISTING: Retrieve data from favorite models (kept for backward compatibility)
  Map<String, FavoriteModel> get favoriteShoeItem => state;
}