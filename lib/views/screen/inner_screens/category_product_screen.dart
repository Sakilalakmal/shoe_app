import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoe_app_assigment/model/categoryModel/category_models.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/components/product_card_widget/product_card_widget.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/product_details_screen.dart';

class CategoryProductScreen extends StatelessWidget {
  final CategoryModels categoryModels;

  const CategoryProductScreen({super.key, required this.categoryModels});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _categoryProductStream = FirebaseFirestore
        .instance
        .collection('shoes')
        .where('shoeCategory', isEqualTo: categoryModels.categoryName)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${categoryModels.categoryName} Shoe Screen",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _categoryProductStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: TSizes.gridViewSpacing,
                crossAxisSpacing: TSizes.gridViewSpacing,
                childAspectRatio: 0.7, // Better ratio for product cards
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final shoeCategoryData = snapshot.data!.docs[index];
                return ProductCardWidget(
                  imageUrl: shoeCategoryData['shoeImages'][0],
                  title: shoeCategoryData['shoeName'],
                  brand: shoeCategoryData['brandName'],
                  price: shoeCategoryData['shoePrice'],
                  discount: shoeCategoryData['discount'],
                  onTap: () {
                    // Navigate to product details
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ProductDetailsScreen(productData: shoeCategoryData);
                    }));
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
