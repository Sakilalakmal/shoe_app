import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shoe_app_assigment/controllers/connectivity_controller/connectivity_controller.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/About_us_screen_offline.dart';

class AboutUsWrapper extends StatelessWidget {
  final ConnectivityController _connectivityController = ConnectivityController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _connectivityController.checkConnectivity(),  // Check if the device is online
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading spinner while checking connectivity
          return Scaffold(
            appBar: AppBar(title: Text("About Us")),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        bool isOnline = snapshot.data ?? false;  // If online, show the online screen

        if (isOnline) {
          // Return your Firebase-based About Us screen when online (if you have it)
          // return AboutUsScreenOnline(); 
          return AboutUsScreen();  // For now, using the offline version
        } else {
          // If offline, show the About Us screen from JSON or assets
          return AboutUsScreen();  // Using offline version for now
        }
      },
    );
  }
}
