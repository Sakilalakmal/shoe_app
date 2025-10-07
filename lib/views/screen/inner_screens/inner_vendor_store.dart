import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/widget/vendorProductCard.dart';

class InnerVendorStore extends ConsumerStatefulWidget {
  final String vendorId;

  const InnerVendorStore({super.key, required this.vendorId});

  @override
  ConsumerState<InnerVendorStore> createState() => _InnerVendorStoreState();
}

class _InnerVendorStoreState extends ConsumerState<InnerVendorStore> {
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
