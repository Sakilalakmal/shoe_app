import 'package:get/get.dart';

class ProductDetailsImageController extends GetxController {
  // RxList to hold image URLs
  RxList<String> images = <String>[].obs;

  // RxString to track selected image
  RxString selectedImage = ''.obs;

  /// Set images and initialize selected image
  void setImages(List<dynamic> newImages) {
    images.value = List<String>.from(newImages);
    if (newImages.isNotEmpty) {
      selectedImage.value = newImages.first;
    }
  }

  /// Update selected image
  void setSelectedImage(String imageUrl) {
    selectedImage.value = imageUrl;
  }
}
