import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoe_app_assigment/model/favorite_model/favorite_model.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, Map<String, FavoriteModel>>((ref) {
      return FavoriteNotifier();
    });

class FavoriteNotifier extends StateNotifier<Map<String, FavoriteModel>> {
  FavoriteNotifier() : super({});

  //is to add  products to favorites

  void addShoesToFavorite({
    required String shoeName,
    required String shoeId,
    required List<String> imageUrl,
    required int shoePrice,
    required List<String> shoeSizes,
    required int discount,
    required String brandName,
  }) {
    state[shoeId] = FavoriteModel(
      shoeName: shoeName,
      shoeId: shoeId,
      imageUrl: imageUrl,
      shoePrice: shoePrice,
      shoeSizes: shoeSizes,
      discount: discount,
      brandName: brandName,
    );

    //notify listeners that state has changed
    state = {...state};
  }

  //remove shoes form favorite
  void removeAllFavoriteShoes() {
    state.clear();

    //notify listeners that state has changed
    state = {...state};
  }

  //remove shoe from favorite
  void removeShoeFromFavorite(String shoeId) {
    state.remove(shoeId);

    //notify state that shoe has been removed
    state = {...state};
  }

  //retrieve data from favorite models
  Map<String, FavoriteModel> get favoriteShoeItem => state;
}
