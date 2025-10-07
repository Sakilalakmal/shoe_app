import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoe_app_web_admin_panel/view/side_bar_screen/banner_upload_screen.dart';
import 'package:shoe_app_web_admin_panel/view/side_bar_screen/buyers_screen.dart';
import 'package:shoe_app_web_admin_panel/view/side_bar_screen/category_upload_screen.dart';
import 'package:shoe_app_web_admin_panel/view/side_bar_screen/oredrs_screen.dart';
import 'package:shoe_app_web_admin_panel/view/side_bar_screen/products_screen.dart';
import 'package:shoe_app_web_admin_panel/view/side_bar_screen/vendor_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedScreen = VendorScreen();

  screenSelector(item) {
    switch (item.route) {
      case VendorScreen.id:
        setState(() {
          _selectedScreen = VendorScreen();
        });
        break;
      case BuyersScreen.id:
        setState(() {
          _selectedScreen = BuyersScreen();
        });
        break;
      case CategoryUploadScreen.id:
        setState(() {
          _selectedScreen = CategoryUploadScreen();
        });
        break;
      case ProductsScreen.id:
        setState(() {
          _selectedScreen = ProductsScreen();
        });
        break;
      case OredrsScreen.id:
        setState(() {
          _selectedScreen = OredrsScreen();
        });
        break;
      case BannerUploadScreen.id:
        setState(() {
          _selectedScreen = BannerUploadScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: const Color(0xFFF8FAFC), // subtle light background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A), // deep blue
        elevation: 4,
        title: Text(
          "SneakersX Admin Panel",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _selectedScreen,
      ),
      sideBar: SideBar(
        backgroundColor: const Color(0xFF111827), // dark slate
        activeBackgroundColor: const Color(0xFF2563EB), // tech blue
        borderColor: Colors.transparent,
        iconColor: Colors.white70,
        activeIconColor: Colors.white,
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.white,
        ),
        activeTextStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        header: Container(
          height: 70,
          width: double.infinity,
          decoration: const BoxDecoration(
            color:  Color(0xFF2563EB),
          ),
          child: Center(
            child: Text(
              "SneakersX",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF2563EB),
          ),
          child: Center(
            child: Text(
              "© 2025 SneakersX",
              style: GoogleFonts.poppins(
                color: Colors.grey.shade400,
                fontSize: 12,
              ),
            ),
          ),
        ),
        items: [
          AdminMenuItem(
            title: "Vendors",
            route: VendorScreen.id,
            icon: Icons.person_3,
          ),
          AdminMenuItem(
            title: "Buyers",
            route: BuyersScreen.id,
            icon: Icons.person_4_sharp,
          ),
          AdminMenuItem(
            title: "Orders",
            route: OredrsScreen.id,
            icon: Icons.shopping_cart_checkout,
          ),
          AdminMenuItem(
            title: "Categories",
            route: CategoryUploadScreen.id,
            icon: Icons.category,
          ),
          AdminMenuItem(
            title: "Upload Banners",
            route: BannerUploadScreen.id,
            icon: Icons.add_photo_alternate,
          ),
          AdminMenuItem(
            title: "Products",
            route: ProductsScreen.id,
            icon: Icons.shopping_bag_rounded,
          ),
        ],
        selectedRoute: "",
        onSelected: (item) {
          screenSelector(item);
        },
      ),
    );
  }
}
