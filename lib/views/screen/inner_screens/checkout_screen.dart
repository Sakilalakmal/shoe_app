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
import 'package:shoe_app_assigment/views/components/notify_message/motion_toast.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/shipping_address_screen.dart';
import 'package:shoe_app_assigment/views/screen/nav_screens/account_screen.dart';
import 'package:shoe_app_assigment/views/screen/nav_screens/cart_screen.dart';
import 'package:shoe_app_assigment/views/screen/nav_screens/favorite_screen.dart';
import 'package:shoe_app_assigment/views/screen/nav_screens/home_screen.dart';
import 'package:shoe_app_assigment/views/screen/nav_screens/store_screen.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _selectedPaymentMethod = 'stripe';
  
  // Bottom navigation variables
  int _pageIndex = 3; // Start at cart index
  final List<Widget> _pages = [
    HomeScreen(),
    FavoriteScreen(),
    StoreScreen(),
    CartScreen(),
    AccountScreen(),
  ];

  //get current user informarion
  String State = '';
  String city = '';
  String streetAddress = '';
  String locality = '';
  String zipCode = '';

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  void getUserData() async {
    Stream<DocumentSnapshot> userDataStream = _firestore
        .collection('buyers')
        .doc(_auth.currentUser!.uid)
        .snapshots();

    //list to stream and update the data

    userDataStream.listen((DocumentSnapshot userData) {
      if (userData.exists) {
        setState(() {
          State = userData.get('State');
          city = userData.get("city");
          streetAddress = userData.get('streetAddress');
          locality = userData.get('locality');
          zipCode = userData.get('zipCode');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final cartProviderData = ref.read(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Texts.checkoutScreen,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: TColors.dashboardAppbarBackground,
        unselectedItemColor: Colors.grey,
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
          // Navigate to selected page
          if (value != 3) { // If not cart, navigate to that page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => _pages[value]),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(icon: Icon(Iconsax.shop), label: 'Stores'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_checkout),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
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

              // ...existing code...
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: dark ? TColors.dark : TColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: TColors.borderLight),
                ),
                child: Row(
                  children: [
                    // Location icon
                    Container(
                      decoration: BoxDecoration(
                        color: TColors.newBlue.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Icons.location_on,
                        color: TColors.newBlue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Address info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Texts.addAddress,
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            Texts.enterCity,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    // Edit icon
                    InkWell(
                      onTap: () {
                        // Handle edit action
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ShippingAddressScreen();
                            },
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: TColors.newBlue.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.edit,
                          color: TColors.newBlue,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ...existing code...
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
      bottomSheet: Material(
        elevation: 0,
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        child: State == ""
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultSpace,
                  vertical: TSizes.xl,
                ),
                child: InkWell(
                  onTap: () async {},
                  child: Container(
                    height: TSizes.appBarHeight,
                    width: HelperFunctions.screenWidth(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(TSizes.sm),
                      color: dark ? TColors.buttonPrimary : TColors.newBlue,
                    ),
                    child: Center(
                      child: Text(
                        Texts.addDeliveryAddressToContinue,
                        style: Theme.of(context).textTheme.headlineMedium!
                            .copyWith(
                              color: dark ? TColors.dark : TColors.white,
                              fontSize: 20,
                            ),
                      ),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.all(TSizes.defaultSpace),
                child: InkWell(
                  onTap: () async {
                    if (_selectedPaymentMethod == "stripe") {
                      //pay with stripe
                    } else {
                      final cartEntries = ref.read(cartProvider).entries;
                      for (var entry in cartEntries) {
                        final item = entry.value;
                        DocumentSnapshot userDoc = await _firestore
                            .collection('buyers')
                            .doc(_auth.currentUser!.uid)
                            .get();

                        CollectionReference orderRefer = _firestore.collection(
                          'shoeOrders',
                        );
                        final orderId = const Uuid().v4();
                        await orderRefer.doc(orderId).set({
                          'orderId': orderId,
                          'shoeName': item.shoeName,
                          'shoeId': item.shoeId,
                          'shoeSizes': item.shoeSizes,
                          'quantity': item.quantity,
                          'shoePrice': item.quantity * item.shoePrice,
                          'shoeCategory': item.shoeCategory,
                          'shoeImage': item.imageUrl[0],
                          'State':
                              (userDoc.data() as Map<String, dynamic>)['State'],
                          'email':
                              (userDoc.data() as Map<String, dynamic>)['email'],
                          'locality':
                              (userDoc.data()
                                  as Map<String, dynamic>)['locality'],
                          'fullName':
                              (userDoc.data()
                                  as Map<String, dynamic>)['fullName'],
                          'buyerId': _auth.currentUser!.uid,
                          'delivered': false,
                          'processing': true,
                          'vendorId': item.vendorId,
                          'createdAt': FieldValue.serverTimestamp(),
                        });
                      }
                      
                      // Clear cart and show success message
                      ref.read(cartProvider.notifier).clearCart();
                      AppToast.success(context, 'Your order placed successfully');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: TSizes.xl),
                    child: Container(
                      height: TSizes.appBarHeight,
                      width: HelperFunctions.screenWidth(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(TSizes.sm),
                        color: dark ? TColors.buttonPrimary : TColors.newBlue,
                      ),
                      child: Center(
                        child: Text(
                          Texts.placeOrder,
                          style: Theme.of(context).textTheme.headlineMedium!
                              .copyWith(
                                color: dark ? TColors.dark : TColors.white,
                                fontSize: 20,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
