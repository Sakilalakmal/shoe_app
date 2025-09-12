import 'package:flutter/material.dart';
import 'package:shoe_app_assigment/utils/constants/text_string.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Texts.deliveryAddress,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
