import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shoe_app_assigment/utils/constants/text_string.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/widget/ShoeOrderCardWidget.dart';

class OrderDetailsScreen extends StatefulWidget {
  final dynamic orderData;

  const OrderDetailsScreen({super.key, required this.orderData});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final TextEditingController _reviewController = TextEditingController();
  double rating = 0;

  //is current log in user give a riview or not
  Future<bool> hasUserReviewdProduct(String shoeId) async {
    final user = FirebaseAuth.instance;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('productReviews')
        .where('shoeId', isEqualTo: shoeId)
        .where('buyerId', isEqualTo: user.currentUser!.uid)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  //update review and rating within the product collection (SAFE)
  Future<void> updateProductRating(String shoeId) async {
    final QuerySnapshot = await FirebaseFirestore.instance
        .collection('productReviews')
        .where('shoeId', isEqualTo: shoeId)
        .get();

    double totalRating = 0;
    int totalReviews = QuerySnapshot.docs.length;
    for (final doc in QuerySnapshot.docs) {
      totalRating += doc['rating'];
    }

    final double averageRating = totalReviews > 0
        ? totalRating / totalReviews
        : 0;

    // ==== SAFELY check for document existence before update ====
    final shoeDocRef = FirebaseFirestore.instance.collection('shoes').doc(shoeId);
    final shoeDocSnap = await shoeDocRef.get();

    if (shoeDocSnap.exists) {
      await shoeDocRef.update({
        'rating': averageRating,
        'totalReview': totalReviews,
      });
    } else {
      print('No shoe document found for shoeId: $shoeId');
      // Optional: Show a snackbar or error to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'MMM d, yyyy',
    ).format(widget.orderData['createdAt']);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Texts.orderDetails,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Column(
        children: [
          ShoeOrderCard(
            locality: widget.orderData['locality'],
            fullName: widget.orderData['fullName'],
            State: widget.orderData['State'],
            streetAddress: widget.orderData['streetAddress'],
            zipCode: widget.orderData['zipCode'],
            shoeImage: widget.orderData['shoeImage'],
            shoeName: widget.orderData['shoeName'],
            shoeCategory: widget.orderData['shoeCategory'],
            quantity: widget.orderData['quantity'],
            shoeSizes: widget.orderData['shoeSizes'],
            shoePrice: widget.orderData['shoePrice'],
            orderId: widget.orderData['orderId'],
            createdAt: widget.orderData['createdAt'],
            delivered: widget.orderData['delivered'],
            processing: widget.orderData['processing'],
            email: widget.orderData['email'],
            shoeId: widget.orderData['shoeId'],
          ),

          const SizedBox(height: TSizes.defaultSpace),

          // Modern Order Summary and Delivery Address sections
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TSizes.defaultSpace,
              vertical: TSizes.sm,
            ),
            child: Column(
              children: [
                // Order Summary Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? TColors.darkContainer
                        : TColors.white,
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: TColors.newBlue.withOpacity(0.06),
                        blurRadius: 16,
                        spreadRadius: 1,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title with Icon
                      Row(
                        children: [
                          Icon(
                            Icons.receipt_long_rounded,
                            color: TColors.newBlue,
                            size: 22,
                          ),
                          const SizedBox(width: TSizes.sm),
                          Text(
                            'Order Summary',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: TColors.newBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.md),

                      // Order Details
                      _buildDetailRow(
                        context,
                        'Order ID',
                        '#${widget.orderData['orderId'].toString().substring(0, 6)}',
                        Icons.tag,
                      ),
                      const SizedBox(height: TSizes.sm),
                      _buildDetailRow(
                        context,
                        'Order Date',
                        formattedDate,
                        Icons.calendar_today_rounded,
                      ),
                      const SizedBox(height: TSizes.sm),

                      // Total Amount with emphasis
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money_rounded,
                            size: 18,
                            color: TColors.newBlue,
                          ),
                          const SizedBox(width: TSizes.sm),
                          Text(
                            'Total Amount:',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.md,
                              vertical: TSizes.xs,
                            ),
                            decoration: BoxDecoration(
                              color: TColors.newBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                TSizes.borderRadiusSm,
                              ),
                            ),
                            child: Text(
                              '\$${(widget.orderData['shoePrice'] * widget.orderData['quantity']).toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: TColors.newBlue,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: TSizes.spaceBtwItems),

                // Delivery Address Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? TColors.darkContainer
                        : TColors.white,
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: TColors.newBlue.withOpacity(0.06),
                        blurRadius: 16,
                        spreadRadius: 1,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title with Icon
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: TColors.newBlue,
                            size: 22,
                          ),
                          const SizedBox(width: TSizes.sm),
                          Text(
                            'Delivery Address',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: TColors.newBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.md),

                      // Full Name
                      _buildDetailRow(
                        context,
                        'Full Name',
                        widget.orderData['fullName'] ?? 'Not provided',
                        Icons.person_rounded,
                      ),
                      const SizedBox(height: TSizes.sm),

                      // Address with multi-line layout
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.home_rounded,
                            size: 18,
                            color: TColors.newBlue,
                          ),
                          const SizedBox(width: TSizes.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Address',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${widget.orderData['streetAddress'] ?? ''}, ${widget.orderData['locality'] ?? ''}, ${widget.orderData['State'] ?? ''}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.sm),

                      // Zip Code
                      _buildDetailRow(
                        context,
                        'Zip Code',
                        widget.orderData['zipCode'] ?? 'Not provided',
                        Icons.markunread_mailbox_rounded,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Add this after the Delivery Address Card in your Padding widget
          const SizedBox(height: TSizes.spaceBtwItems),

          // Review Button - only visible when delivered is true
          if (widget.orderData['delivered'] == true)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.defaultSpace,
              ),
              child: ElevatedButton.icon(
                onPressed: () async {
                  final parentContext = context;
                  final shoeId = widget.orderData['shoeId'];
                  final hasReviewed = await hasUserReviewdProduct(shoeId);

                  if (hasReviewed) {
                    // First, get the existing review data
                    final existingReview = await FirebaseFirestore.instance
                        .collection('productReviews')
                        .where('shoeId', isEqualTo: shoeId)
                        .where(
                          'buyerId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                        )
                        .get();

                    final reviewData = existingReview.docs.first.data();

                    return showDialog(
                      context: parentContext,
                      builder: (context) {
                        double currentRating =
                            reviewData['rating']?.toDouble() ?? 0.0;
                        TextEditingController updateController =
                            TextEditingController(
                              text: reviewData['review'] ?? '',
                            );
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              TSizes.cardRadiusLg,
                            ),
                          ),
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(TSizes.defaultSpace),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? TColors.darkContainer
                                      : TColors.white,
                              borderRadius: BorderRadius.circular(
                                TSizes.cardRadiusLg,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: TColors.newBlue.withOpacity(0.1),
                                  blurRadius: 16,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Header with different icon and styling
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: TColors.newBlue.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.edit_note_rounded,
                                        color: TColors.newBlue,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: TSizes.md),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Update Your Review',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: TColors.newBlue,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Edit your thoughts about this product',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? TColors
                                                          .textDarkSecondary
                                                      : TColors.textSecondary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: TSizes.spaceBtwItems),

                                // Product name with different styling
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(TSizes.sm),
                                  decoration: BoxDecoration(
                                    color: TColors.newBlue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                      TSizes.cardRadiusSm,
                                    ),
                                  ),
                                  child: Text(
                                    widget.orderData['shoeName'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: TColors.newBlue,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                const SizedBox(height: TSizes.spaceBtwItems),

                                // Current rating display
                                Column(
                                  children: [
                                    Text(
                                      'Your Current Rating',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    const SizedBox(height: TSizes.sm),
                                    StatefulBuilder(
                                      builder: (context, setDialogState) {
                                        return Column(
                                          children: [
                                            RatingBar.builder(
                                              initialRating: currentRating,
                                              itemCount: 5,
                                              itemPadding: EdgeInsets.symmetric(
                                                horizontal: 6,
                                              ),
                                              minRating: 1,
                                              maxRating: 5,
                                              allowHalfRating: true,
                                              itemSize: 32,
                                              unratedColor: TColors.grey
                                                  .withOpacity(0.3),
                                              glow: false,
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star_rounded,
                                                color: TColors.primary,
                                              ),
                                              onRatingUpdate: (value) {
                                                setDialogState(() {
                                                  currentRating = value;
                                                });
                                              },
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              _getRatingText(currentRating),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: TColors.primary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                const SizedBox(height: TSizes.spaceBtwItems),

                                // Review text input with proper colors
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      TSizes.cardRadiusMd,
                                    ),
                                    border: Border.all(
                                      color: TColors.borderLight,
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: updateController,
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      hintText: 'Update your review...',
                                      hintStyle: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? TColors.textDarkSecondary
                                            : TColors.textSecondary,
                                        fontSize: 14,
                                      ),
                                      filled: true,
                                      fillColor: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? TColors.darkContainer
                                          : TColors.lightContainer,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          TSizes.cardRadiusMd,
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.all(
                                        TSizes.md,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: TSizes.spaceBtwItems),

                                // Action buttons with proper colors
                                Row(
                                  children: [
                                    // Keep Original button
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? TColors.borderDark
                                                : TColors.borderLight,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: TSizes.md,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              TSizes.buttonRadius,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Keep Original',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: TSizes.md),

                                    // Update button
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          // Update review logic
                                          final updatedReview = updateController
                                              .text
                                              .trim();

                                          if (updatedReview.isNotEmpty &&
                                              currentRating > 0) {
                                            await FirebaseFirestore.instance
                                                .collection('productReviews')
                                                .doc(
                                                  existingReview.docs.first.id,
                                                )
                                                .update({
                                                  'rating': currentRating,
                                                  'review': updatedReview,
                                                  'updatedAt': DateTime.now()
                                                }).whenComplete(
                                                  () async {
                                                    await updateProductRating(
                                                        shoeId);
                                                  });

                                            Navigator.pop(context);

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Review updated successfully!',
                                                ),
                                                backgroundColor:
                                                    TColors.success,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: TColors.newBlue,
                                          foregroundColor: TColors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: TSizes.md,
                                          ),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              TSizes.buttonRadius,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Update Review',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                color: TColors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              TSizes.cardRadiusLg,
                            ),
                          ),
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(TSizes.defaultSpace),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? TColors.darkContainer
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(
                                TSizes.cardRadiusLg,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Header with product image
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        TSizes.cardRadiusMd,
                                      ),
                                      child: Image.network(
                                        widget.orderData['shoeImage'],
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  width: 60,
                                                  height: 60,
                                                  color: Colors.grey[200],
                                                  child: Icon(
                                                    Icons.image,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                      ),
                                    ),
                                    const SizedBox(width: TSizes.md),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Rate this product',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            widget.orderData['shoeName'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color: TColors.newBlue,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: TSizes.spaceBtwItems),

                                // Rating Stars
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'How would you rate this shoe?',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: TSizes.md),
                                    RatingBar.builder(
                                      initialRating: rating,
                                      itemCount: 5,
                                      itemPadding: EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      minRating: 1,
                                      maxRating: 5,
                                      allowHalfRating: true,
                                      itemSize: 36,
                                      unratedColor: Colors.grey.withOpacity(
                                        0.3,
                                      ),
                                      glow: false,
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star_rounded,
                                        color: TColors.primary,
                                      ),
                                      onRatingUpdate: (value) {
                                        setState(() {
                                          rating = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    // Show rating text based on rating value
                                    Text(
                                      _getRatingText(rating),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: TColors.newBlue,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: TSizes.spaceBtwItems),

                                // Review text input
                                TextFormField(
                                  controller: _reviewController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Share your experience with this product...',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                    filled: true,
                                    fillColor:
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? TColors.dark.withOpacity(0.3)
                                            : Colors.grey.withOpacity(0.1),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        TSizes.cardRadiusMd,
                                      ),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.all(
                                      TSizes.md,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: TSizes.spaceBtwItems),

                                // Action Buttons
                                Row(
                                  children: [
                                    // Cancel button
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : Colors.grey.shade300,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: TSizes.md,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              TSizes.buttonRadius,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Cancel',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: TSizes.md),

                                    // Submit button
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          // Submit review logic here

                                          final review = _reviewController.text;

                                          await FirebaseFirestore.instance
                                              .collection('productReviews')
                                              .doc(widget.orderData['orderId'])
                                              .set({
                                                'reviewId':
                                                    widget.orderData['orderId'],
                                                'shoeId':
                                                    widget.orderData['shoeId'],
                                                'fullName': widget
                                                    .orderData['fullName'],
                                                'email':
                                                    widget.orderData['email'],
                                                'buyerId': FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid,
                                                'rating': rating,
                                                'review': review,
                                                'createdAt': DateTime.now(),
                                              })
                                              .whenComplete(() async {
                                                updateProductRating(shoeId);
                                                Navigator.pop(context);
                                                _reviewController.clear();
                                                setState(() {
                                                  rating = 0;
                                                });
                                              });

                                          // Show confirmation toast or message
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Thank you for your review!',
                                              ),
                                              backgroundColor: TColors.newBlue,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: TColors.newBlue,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: TSizes.md,
                                          ),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              TSizes.buttonRadius,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Submit',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.newBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: TSizes.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TSizes.buttonRadius),
                  ),
                  minimumSize: const Size(double.infinity, 0), // full width
                ),
                icon: const Icon(Icons.star_rounded, color: TColors.white),
                label: Text(
                  'Review Now',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: TColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),

          // Helper method for detail rows
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 18, color: TColors.newBlue),
        const SizedBox(width: TSizes.sm),
        Text(
          '$label:',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  String _getRatingText(double rating) {
    if (rating >= 4.5) return 'Excellent!';
    if (rating >= 3.5) return 'Very Good';
    if (rating >= 2.5) return 'Good';
    if (rating >= 1.5) return 'Fair';
    if (rating >= 1) return 'Poor';
    return 'Rate this product';
  }
}
