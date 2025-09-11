import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BannerController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<String>> getBannerUrls() {
    return _firestore.collection('banners').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc['image'] as String).toList();
    });
  }
}
