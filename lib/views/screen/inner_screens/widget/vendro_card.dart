import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class VendorCard extends StatelessWidget {
  final String fullName;
  final String email;
  final String? storeImage;
  final String? city;
  final String? locality;
  final String? streetAddress;
  final String? contact; // ADDED: Phone number
  final double? latitude; // ADDED: Vendor latitude
  final double? longitude; // ADDED: Vendor longitude
  final VoidCallback onTap;
  final bool isVerified;

  const VendorCard({
    super.key,
    required this.fullName,
    required this.email,
    this.storeImage,
    this.city,
    this.locality,
    this.streetAddress,
    this.contact, // ADDED
    this.latitude, // ADDED
    this.longitude, // ADDED
    required this.onTap,
    this.isVerified = false,
  });

  String _buildAddressString() {
    List<String> addressParts = [];
    
    if (city != null && city!.isNotEmpty) {
      addressParts.add(city!);
    }
    if (locality != null && locality!.isNotEmpty) {
      addressParts.add(locality!);
    }
    if (streetAddress != null && streetAddress!.isNotEmpty) {
      addressParts.add(streetAddress!);
    }
    
    return addressParts.join(', ');
  }

  // ADDED: Function to open Google Maps
  // SIMPLE: Basic map opening function
Future<void> _openGoogleMaps(BuildContext context) async {
  if (latitude == null || longitude == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Location not available for this vendor'),
        backgroundColor: TColors.warning,
        behavior: SnackBarBehavior.floating,
      ),
    );
    return;
  }

  try {
    // Use universal Google Maps URL that works on all platforms
    final String url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final Uri uri = Uri.parse(url);
    
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open maps: ${e.toString()}'),
          backgroundColor: TColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

Future<void> _makePhoneCall(BuildContext context) async {
    if (contact == null || contact!.isEmpty) {
      _showErrorSnackBar(context, 'Phone number not available for this vendor');
      return;
    }

    try {
      // Clean the phone number (remove spaces, dashes, brackets, etc.)
      String cleanedNumber = contact!.replaceAll(RegExp(r'[^\d+]'), '');
      
      // Show confirmation dialog
      bool? shouldCall = await _showCallConfirmationDialog(context, contact!);
      if (shouldCall != true) return;

      // Use direct tel: scheme - most reliable
      final String phoneUrl = 'tel:$cleanedNumber';
      final Uri uri = Uri.parse(phoneUrl);
      
      print('Attempting to call: $phoneUrl'); // Debug log
      
      // Use launchUrl with specific mode for phone calls
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      
    } catch (e) {
      print('Phone call error: $e');
      if (context.mounted) {
        _showErrorSnackBar(context, 'Unable to make call. Please check if phone app is available.');
      }
    }
  }

  // ADDED: Helper function for error snackbars
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: TColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
        ),
        margin: const EdgeInsets.all(TSizes.defaultSpace),
        action: SnackBarAction(
          label: 'OK',
          textColor: TColors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // SIMPLIFIED: Call confirmation dialog
  Future<bool?> _showCallConfirmationDialog(BuildContext context, String phoneNumber) {
    final isDark = HelperFunctions.isDarkMode(context);
    
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? TColors.darkContainer : TColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: TColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Iconsax.call,
                  color: TColors.success,
                  size: 20,
                ),
              ),
              const SizedBox(width: TSizes.sm),
              Expanded(
                child: Text(
                  'Call Vendor',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? TColors.white : TColors.black,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Do you want to call this vendor?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? TColors.textDarkSecondary : TColors.textSecondary,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(TSizes.sm),
                decoration: BoxDecoration(
                  color: TColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
                  border: Border.all(
                    color: TColors.success.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.call_calling,
                      color: TColors.success,
                      size: 16,
                    ),
                    const SizedBox(width: TSizes.sm),
                    Expanded(
                      child: Text(
                        phoneNumber,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: isDark ? TColors.darkGrey : TColors.darkGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.sm),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.success,
                      foregroundColor: TColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TSizes.buttonRadius),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.call, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Call Now',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunctions.isDarkMode(context);
    final addressString = _buildAddressString();

    return Container(
      width: TSizes.vendorCardWidth,
      height: TSizes.vendorCardHeight + 40, // INCREASED: Added height for new buttons
      margin: const EdgeInsets.only(right: TSizes.spaceBtwItems),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkContainer : TColors.lightContainer,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: isDark ? TColors.darkGrey.withOpacity(0.1) : TColors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          child: Padding(
            padding: const EdgeInsets.all(TSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Profile Image and Verified Badge
                Row(
                  children: [
                    // Store Image Avatar
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            TColors.newBlue.withOpacity(0.15),
                            TColors.newBlue.withOpacity(0.08),
                          ],
                        ),
                        border: Border.all(
                          color: TColors.newBlue.withOpacity(0.2),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: TColors.newBlue.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 28, // REDUCED: From 32 to accommodate new content
                        backgroundColor: Colors.transparent,
                        backgroundImage: (storeImage != null && storeImage!.isNotEmpty)
                            ? NetworkImage(storeImage!)
                            : null,
                        child: (storeImage == null || storeImage!.isEmpty)
                            ? Text(
                                fullName.isNotEmpty ? fullName[0].toUpperCase() : 'V',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: TColors.newBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20, // REDUCED: From larger size
                                ),
                              )
                            : null,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // ENHANCED: Action buttons row
                    Row(
                      children: [
                        // Location Button - NEW
                        if (latitude != null && longitude != null)
                          Container(
                            decoration: BoxDecoration(
                              color: TColors.newBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: TColors.newBlue.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () => _openGoogleMaps(context),
                              icon: Icon(
                                Iconsax.location,
                                color: TColors.newBlue,
                                size: 18,
                              ),
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              tooltip: 'Open in Maps',
                            ),
                          ),
                        
                        const SizedBox(width: TSizes.xs),
                        
                        // Verified Badge
                        if (isVerified)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.sm,
                              vertical: TSizes.xs,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  TColors.success.withOpacity(0.15),
                                  TColors.success.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
                              border: Border.all(
                                color: TColors.success.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Iconsax.verify5,
                                  color: TColors.success,
                                  size: 12,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'Verified',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: TColors.success,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: TSizes.spaceBtwItems),
                
                // Vendor Name - More prominent
                Text(
                  fullName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? TColors.textDarkPrimary : TColors.textPrimary,
                    height: 1.2,
                    fontSize: 18, // REDUCED: For better fit
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                
                // Email with Icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: TColors.newBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Iconsax.sms,
                        size: 11,
                        color: TColors.newBlue,
                      ),
                    ),
                    const SizedBox(width: TSizes.sm),
                    Expanded(
                      child: Text(
                        email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark ? TColors.textDarkSecondary : TColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12, // REDUCED: For better fit
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                
                // Address (if available) with Icon
                if (addressString.isNotEmpty)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: TColors.newBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Iconsax.map,
                          size: 11,
                          color: TColors.newBlue,
                        ),
                      ),
                      const SizedBox(width: TSizes.sm),
                      Expanded(
                        child: Text(
                          addressString,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark ? TColors.textDarkSecondary : TColors.textSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 12, // REDUCED: For better fit
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                
                const Spacer(),
                
                // ENHANCED: Bottom Action Buttons
                Row(
                  children: [
                    // Call Button - NEW
                    if (contact != null && contact!.isNotEmpty)
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () => _makePhoneCall(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.success,
                            foregroundColor: TColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(TSizes.buttonRadius),
                            ),
                            elevation: 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.call,
                                size: 14,
                                color: TColors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Call',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: TColors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    if (contact != null && contact!.isNotEmpty)
                      const SizedBox(width: TSizes.sm),
                    
                    // Visit Store Button - ENHANCED
                    Expanded(
                      flex: contact != null && contact!.isNotEmpty ? 1 : 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: TSizes.sm,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              TColors.newBlue,
                              TColors.newBlue.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(TSizes.buttonRadius),
                          boxShadow: [
                            BoxShadow(
                              color: TColors.newBlue.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Visit Store',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: TColors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Iconsax.arrow_right_3,
                              color: TColors.white,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}