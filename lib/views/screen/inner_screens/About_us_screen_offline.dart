import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shoe_app_assigment/model/json_model/about_us.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {

  // FIXED: Load from correct JSON file
  Future<AboutUs> loadAboutUsData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/about_us.json'); // FIXED: Correct file name
      final Map<String, dynamic> data = json.decode(response);
      print('Loaded About Us data: $data'); // Debug print
      return AboutUs.fromJson(data);
    } catch (e) {
      print('Error loading About Us data: $e');
      throw Exception('Failed to load About Us data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
        backgroundColor: TColors.primary,
      ),
      body: FutureBuilder<AboutUs>(
        future: loadAboutUsData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: TColors.primary),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text('Loading About Us...'),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            print('About Us error: ${snapshot.error}'); // Debug print
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: TColors.error),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    "Error loading About Us data",
                    style: TextStyle(color: TColors.error, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Text('${snapshot.error}'),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {}); // Retry
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final aboutUsContent = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App logo with error handling
                  Center(
                    child: Image.asset(
                      aboutUsContent.appLogoUrl,
                      height: 120,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          width: 120,
                          color: TColors.lightContainer,
                          child: Icon(Icons.image, size: 48, color: TColors.darkGrey),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  
                  // App name
                  Center(
                    child: Text(
                      aboutUsContent.appName,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  
                  // About description
                  Text(
                    "About Us",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    aboutUsContent.aboutUsDescription,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  
                  // Mission statement
                  Text(
                    "Our Mission",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    aboutUsContent.missionStatement,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  
                  // Social media links
                  Text(
                    "Follow Us",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: aboutUsContent.socialMediaLinks.map((link) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                        child: GestureDetector(
                          onTap: () {
                            // Add social media link functionality here
                            print('Tapped on social media: $link');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(TSizes.sm),
                            decoration: BoxDecoration(
                              color: TColors.lightContainer,
                              borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                            ),
                            child: Image.asset(
                              link,
                              width: 32,
                              height: 32,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.link, size: 32, color: TColors.darkGrey);
                              },
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text("No data found"),
            );
          }
        },
      ),
    );
  }
}