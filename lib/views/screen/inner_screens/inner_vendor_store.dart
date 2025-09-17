import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/widget/vendorProductCard.dart';

class InnerVendorStore extends StatefulWidget {
  final String vendorId;

  const InnerVendorStore({super.key, required this.vendorId});

  @override
  State<InnerVendorStore> createState() => _InnerVendorStoreState();
}

class _InnerVendorStoreState extends State<InnerVendorStore> {
  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final Stream<QuerySnapshot> _vendorProductStream = FirebaseFirestore
        .instance
        .collection('shoes')
        .where('vendorId', isEqualTo: widget.vendorId)
        .snapshots();
    return vendorProductCard(vendorProductStream: _vendorProductStream, dark: dark);
        }
  }

  class FavoriteIcon extends StatelessWidget {
   FavoriteIcon({super.key, required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: dark
            ? TColors.black.withOpacity(0.9)
            : TColors.white.withOpacity(0.4),
      ),
      child: IconButton(
        onPressed: () {},
        icon: const Icon(Iconsax.heart5, color: Colors.redAccent),
      ),
    );
  }
}
