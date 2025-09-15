import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoe_app_assigment/utils/constants/text_string.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/widget/ShoeOrderCardWidget.dart';

class ShowOrdersScreen extends StatefulWidget {
  const ShowOrdersScreen({super.key});

  @override
  State<ShowOrdersScreen> createState() => _ShowOrdersScreenState();
}

class _ShowOrdersScreenState extends State<ShowOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _processingOrdersStream = FirebaseFirestore
        .instance
        .collection('shoeOrders')
        .where('buyerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Texts.myOrders,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _processingOrdersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No orders found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              try {
                final order = snapshot.data!.docs[index];
                final data = order.data() as Map<String, dynamic>;

                return ShoeOrderCard(
                  // Safe way to access the image URL
                  shoeImage:data['shoeImage'] ?? "",
                  shoeName: data['shoeName'] ?? 'Unnamed Product',
                  shoeCategory: data['shoeCategory'] ?? 'Shoes',
                  quantity: data['quantity'] ?? 1,
                  shoeSizes: data['shoeSizes'] ?? 'N/A',
                  shoePrice: (data['shoePrice'] ?? 0).toDouble(),
                  orderId: data['orderId'] ?? '',
                  createdAt: (data['createdAt'] as Timestamp).toDate(),
                  delivered: data['delivered'] ?? false,
                  processing: data['processing'] ?? false,
                  locality: data['locality'] ?? 'N/A',
                  fullName: data['fullName'] ?? 'N/A',
                  State: data['State'] ?? 'N/A',
                  streetAddress: data['streetAddress'] ?? '83/1 main road , flower street',
                  zipCode: data['zipCode'] ?? '1190',
                );
              } catch (e) {
                print("Error rendering order card: $e");
                return SizedBox.shrink(); // Skip rendering this item
              }
            },
          );
        },
      ),
    );
  }
}
