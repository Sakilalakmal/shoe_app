import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/provider/cart_provider.dart';
import 'package:shoe_app_assigment/utils/constants/text_string.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String _selectedPaymentMethod = 'stripe';

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final cartProviderData = ref.read(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Texts.checkoutScreen,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(cartProviderData.length, (index) {
                final cartItem = cartProviderData.values.toList()[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: dark ? TColors.dark : TColors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          cartItem.imageUrl[0],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItem.shoeName,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              cartItem.shoeCategory,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(color: TColors.darkGrey),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  cartItem.brandName,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Icon(
                                  Iconsax.verify5,
                                  color: TColors.facebookBackgroundColor,
                                  size: TSizes.iconSm,
                                ),
                              ],
                            ),
                            const SizedBox(height: TSizes.defaultSpace / 3),
                            Text(
                              "\$${cartItem.shoePrice}",
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: TSizes.defaultSpace),
              Text(
                Texts.paymentMethod,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              RadioListTile<String>(
                title: Text(
                  Texts.stripe,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                value: 'stripe',
                groupValue: _selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text(
                  Texts.cashOnDevlivery,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                value: 'cashOnDelivery',
                groupValue: _selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: InkWell(
          onTap: () async {
            if (_selectedPaymentMethod == "stripe") {
              //pay with stripe
            } else {
              for (var item
                  in ref.read(cartProvider.notifier).getCartItem.values) {
                DocumentSnapshot userDoc = await _firestore
                    .collection('buyers')
                    .doc(_auth.currentUser!.uid)
                    .get();

              CollectionReference orderRefer = _firestore.collection('shoeOrders');
              final orderId = const Uuid().v4();
              await orderRefer.doc(orderId).set({
                'orderId':orderId,
                'shoeName':item.shoeName,
                'shoeId':item.shoeId,
                'shoeSizes':item.shoeSizes,
                'quantity':item.quantity,
                'shoePrice':item.quantity * item.shoePrice,
                'shoeCategory':item.shoeCategory,
                'shoeImage':item.imageUrl[0],
                'State':(userDoc.data() as Map<String , dynamic>)['State'],
                'email':(userDoc.data() as Map<String , dynamic>)['email'],
                'locality':(userDoc.data() as Map<String , dynamic>)['locality'],
                'fullName':(userDoc.data() as Map<String , dynamic>)['fullName'],
                'buyerId':_auth.currentUser!.uid,
                'delivered':false,
                'processing':true,
              });
              }
            }
          },
          child: Container(
            height: TSizes.appBarHeight,
            width: HelperFunctions.screenWidth(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(TSizes.sm),
              color: dark ? TColors.buttonPrimary : TColors.newBlue,
            ),
          ),
        ),
      ),
    );
  }
}
