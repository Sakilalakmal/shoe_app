import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';
import 'package:shoe_app_assigment/model/categoryModel/category_models.dart';

class CategoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<CategoryModels> categories = <CategoryModels>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchCategories();
  }


  //retrieve data from firebase
  void _fetchCategories() {
    _firestore.collection('categories').snapshots().listen((
      QuerySnapshot querySnapshot,
    ) {
      categories.assignAll(
        querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return CategoryModels(
            categoryName: data['categoryName'],
            categoryImage: data['categoryImage'],
          );
        }).toList(),
      );
    });
  }
}
