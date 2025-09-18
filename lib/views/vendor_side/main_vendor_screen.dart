import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/views/vendor_side/earning_screen.dart';
import 'package:shoe_app_assigment/views/vendor_side/vendor_edit_screen.dart';
import 'package:shoe_app_assigment/views/vendor_side/vendor_profile_screen.dart';
import 'package:shoe_app_assigment/views/vendor_side/upload_screen.dart';
import 'package:shoe_app_assigment/views/vendor_side/vendor_order_screen.dart';

class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {

  int pageIndex = 0;
 final  List<Widget> _pages = [
    EarningScreen(),
    UploadScreen(),
    VendorOrderScreen(),
    EditVendorProfileScreen(),
    VendorProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    final isDark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        selectedItemColor: isDark ? TColors.primary : TColors.newBlue,
        unselectedItemColor: isDark ? TColors.white : TColors.black,
        onTap: (value){
          setState(() {
            pageIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.dollar_circle4),
            label: "Earnings",
          ),

          BottomNavigationBarItem(
            icon: Icon(Iconsax.document_upload5),
            label: "Uploads",
          ),

           BottomNavigationBarItem(icon: Icon(Iconsax.shopping_cart5), label: "Orders"),

          BottomNavigationBarItem(icon: Icon(Iconsax.edit_25), label: "Edit"),

          BottomNavigationBarItem(
            icon: Icon(Iconsax.profile_2user5),
            label: "Profile",
          ),
        ],
      ),
      body: _pages[pageIndex],
    );
  }
}
