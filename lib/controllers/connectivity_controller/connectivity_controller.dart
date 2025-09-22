import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:shoe_app_assigment/model/json_model/shoe_model.dart';
  // Import the Shoe model

class ConnectivityController {
  // Function to check connectivity status
  Future<bool> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none; // true if online, false if offline
  }

  // Function to load shoe data from Firestore (online mode)
  Stream<QuerySnapshot> getProductsStream() {
    return FirebaseFirestore.instance.collection('shoes').snapshots();
  }

  // Function to load shoe data from the bundled JSON file (offline mode)
  Future<List<Shoe>> loadShoeDataFromJson() async {
    final String response = await rootBundle.loadString('assets/data/shoes_data.json');
    final List<dynamic> data = json.decode(response);
    return data.map((item) => Shoe.fromJson(item)).toList();
  }
}
