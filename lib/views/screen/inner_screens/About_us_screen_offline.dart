import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shoe_app_assigment/model/json_model/shoe_model.dart';


class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {

  // Load About Us data from JSON
  Future<AboutUs> loadAboutUsData() async {
    final String response = await rootBundle.loadString('assets/data/about_us.json');
    final Map<String, dynamic> data = json.decode(response);
    return AboutUs.fromJson(data);  // Deserialize JSON data into AboutUs object
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About Us")),
      body: FutureBuilder<AboutUs>(
        future: loadAboutUsData(),  // The future that will load data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());  // Show loading while data is loading
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading About Us data"));  // Handle error state
          } else if (snapshot.hasData) {
            final aboutUsContent = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(aboutUsContent.appLogoUrl),  // App logo
                  SizedBox(height: 20),
                  Text(aboutUsContent.appName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(aboutUsContent.aboutUsDescription),
                  SizedBox(height: 20),
                  Text("Mission:", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(aboutUsContent.missionStatement),
                  SizedBox(height: 20),
                  Row(
                    children: aboutUsContent.socialMediaLinks.map((link) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Image.asset(link, width: 30, height: 30),
                      );
                    }).toList(),
                  )
                ],
              ),
            );
          } else {
            return Center(child: Text("No data found"));  // Handle case where data is not found
          }
        },
      ),
    );
  }
}
