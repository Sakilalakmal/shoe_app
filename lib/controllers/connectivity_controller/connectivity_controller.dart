import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:shoe_app_assigment/model/json_model/shoe_model.dart';

class ConnectivityController {
  // Function to check connectivity status
  Future<bool> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none; // true if online, false if offline
  }

  // Function to load shoe data from the bundled JSON file
  Future<List<Shoe>> loadShoeDataFromJson() async {
    // Load the JSON file from assets
    final String response = await rootBundle.loadString('assets/data/shoes_data.json');
    final List<dynamic> data = json.decode(response);

    // Convert the JSON data into a list of Shoe objects
    return data.map((item) => Shoe.fromJson(item)).toList();
  }
}