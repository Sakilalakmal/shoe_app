import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoe_app_assigment/utils/constants/text_string.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String state;
  late String city;
  late String streetAddress;
  late String locality;
  late String zipCode;
  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Texts.deliveryAddress,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: TSizes.defaultSpace,
          horizontal: TSizes.defaultSpace,
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  textAlign: TextAlign.center,
                  Texts.deliveryAddressSubTitle,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: TSizes.defaultSpace),
                TextFormField(
                  onChanged: (value) {
                    state = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "State is required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: Texts.state),
                ),
                const SizedBox(height: TSizes.defaultSpace),
                TextFormField(
                  onChanged: (value) {
                    zipCode = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Zip Code is required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: Texts.zipCode),
                ),
                const SizedBox(height: TSizes.defaultSpace),
                TextFormField(
                  onChanged: (value) {
                    city = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "City is required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: Texts.city),
                ),
                const SizedBox(height: TSizes.defaultSpace),
                TextFormField(
                  onChanged: (value) {
                    streetAddress = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Street Address is required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: Texts.streetAddress),
                ),
                const SizedBox(height: TSizes.defaultSpace),
                TextFormField(
                  onChanged: (value) {
                    locality = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Locality is required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: Texts.locality),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TSizes.defaultSpace,
          vertical: TSizes.xl,
        ),
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              //update addresses and go back
              await _firestore
                  .collection('buyers')
                  .doc(_auth.currentUser!.uid)
                  .update({
                    'State': state,
                    'zipCode': zipCode,
                    'city': city,
                    'streetAddress': streetAddress,
                    'locality': locality,
                  }).whenComplete((){
                    Navigator.of(context).pop();
                    setState(() {
                      _formKey.currentState!.validate();
                    });
                  });

                  _showDialog(context);
            } else {
              //show toast message
            }
          },
          child: Text(
            Texts.setDeliveryAddress,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: dark ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final dark = HelperFunctions.isDarkMode(context);
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: dark ? Colors.grey[900] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              Container(
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade100,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green.shade700,
                  size: 48,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "Success!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your address has been saved successfully.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: dark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog          
                  },
                  child: Text(
                    "OK",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

}
