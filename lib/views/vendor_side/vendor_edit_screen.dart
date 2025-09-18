import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class EditVendorProfileScreen extends StatefulWidget {
  const EditVendorProfileScreen({super.key});

  @override
  State<EditVendorProfileScreen> createState() => _EditVendorProfileScreenState();
}

class _EditVendorProfileScreenState extends State<EditVendorProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _localityController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _zipCodeController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isUploadingImage = false;
  String? _currentImageUrl;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadVendorData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _localityController.dispose();
    _streetAddressController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  Future<void> _loadVendorData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('vendors')
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        _fullNameController.text = data['fullName'] ?? '';
        _emailController.text = data['email'] ?? '';
        _contactController.text = data['contact'] ?? '';
        _stateController.text = data['State'] ?? '';
        _cityController.text = data['city'] ?? '';
        _localityController.text = data['locality'] ?? '';
        _streetAddressController.text = data['streetAddress'] ?? '';
        _zipCodeController.text = data['zipCode'] ?? '';
        _currentImageUrl = data['storeImage'];
      }
    } catch (e) {
      _showSnackBar('Error loading profile data', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _isUploadingImage = true;
        });
        await _uploadImageAndUpdateProfile();
      }
    } catch (e) {
      _showSnackBar('Error selecting image', isError: true);
    }
  }

  Future<void> _uploadImageAndUpdateProfile() async {
    if (_selectedImage == null) return;

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      // Generate unique filename
      final fileName = 'vendor_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // Upload to Firebase Storage
      final ref = FirebaseStorage.instance
          .ref()
          .child('vendor_images')
          .child(fileName);
      
      await ref.putFile(_selectedImage!);
      final newImageUrl = await ref.getDownloadURL();

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('vendors')
          .doc(userId)
          .update({'storeImage': newImageUrl});

      if (mounted) {
        setState(() {
          _currentImageUrl = newImageUrl;
          _selectedImage = null;
        });
      }

      _showSnackBar('Profile image updated successfully');
    } catch (e) {
      _showSnackBar('Error uploading image', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isUploadingImage = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      await FirebaseFirestore.instance
          .collection('vendors')
          .doc(userId)
          .update({
        'fullName': _fullNameController.text.trim(),
        'contact': _contactController.text.trim(),
        'State': _stateController.text.trim(),
        'city': _cityController.text.trim(),
        'locality': _localityController.text.trim(),
        'streetAddress': _streetAddressController.text.trim(),
        'zipCode': _zipCodeController.text.trim(),
      });

      _showSnackBar('Profile updated successfully');
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      _showSnackBar('Error updating profile', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? TColors.error : TColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    final cityEmpty = _cityController.text.trim().isEmpty;
    final streetEmpty = value?.trim().isEmpty ?? true;
    
    if (cityEmpty && streetEmpty) {
      return 'Either city or street address is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunctions.isDarkMode(context);

    if (_isLoading) {
      return Scaffold(
        appBar: _buildAppBar(context, isDark),
        body: Center(
          child: CircularProgressIndicator(color: TColors.newBlue),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(context, isDark),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, isDark),
              const SizedBox(height: TSizes.spaceBtwSections),
              _buildProfileImageSection(context, isDark),
              const SizedBox(height: TSizes.spaceBtwSections),
              _buildPersonalInfoSection(context, isDark),
              const SizedBox(height: TSizes.spaceBtwSections),
              _buildAddressSection(context, isDark),
              const SizedBox(height: TSizes.spaceBtwSections),
              _buildActionButtons(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      title: Text(
        'Edit Profile',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Iconsax.arrow_left),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: isDark ? TColors.dark : TColors.white,
      elevation: 0,
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: TColors.darkGrey),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Update Your Profile',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? TColors.white : TColors.black,
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        Text(
          'Keep your information up to date for better customer experience',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isDark ? TColors.darkGrey : TColors.darkGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImageSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkerGrey : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.image, color: TColors.newBlue, size: 20),
              const SizedBox(width: TSizes.sm),
              Text(
                'Profile Image',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? TColors.white : TColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Center(
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: TColors.newBlue.withOpacity(0.3),
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: _selectedImage != null
                        ? Image.file(_selectedImage!, fit: BoxFit.cover)
                        : _currentImageUrl != null && _currentImageUrl!.isNotEmpty
                            ? Image.network(
                                _currentImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: TColors.lightContainer,
                                    child: Icon(
                                      Iconsax.user,
                                      size: 40,
                                      color: TColors.newBlue,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: TColors.lightContainer,
                                child: Icon(
                                  Iconsax.user,
                                  size: 40,
                                  color: TColors.newBlue,
                                ),
                              ),
                  ),
                ),
                if (_isUploadingImage)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: TColors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _isUploadingImage ? null : _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TColors.newBlue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Iconsax.camera,
                        color: TColors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          Center(
            child: Text(
              'Tap camera icon to change',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? TColors.darkGrey : TColors.darkGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkerGrey : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.user, color: TColors.newBlue, size: 20),
              const SizedBox(width: TSizes.sm),
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? TColors.white : TColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          _buildTextField(
            controller: _fullNameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            prefixIcon: Iconsax.user,
            validator: (value) => _validateRequired(value, 'Full Name'),
            isDark: isDark,
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          _buildTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Your email address',
            prefixIcon: Iconsax.sms,
            enabled: false,
            isDark: isDark,
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          _buildTextField(
            controller: _contactController,
            label: 'Contact Number',
            hint: 'Enter your phone number',
            prefixIcon: Iconsax.call,
            keyboardType: TextInputType.phone,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkerGrey : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.location, color: TColors.newBlue, size: 20),
              const SizedBox(width: TSizes.sm),
              Text(
                'Address Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? TColors.white : TColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _stateController,
                  label: 'State',
                  hint: 'Enter state',
                  prefixIcon: Iconsax.map,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwInputFields),
              Expanded(
                child: _buildTextField(
                  controller: _cityController,
                  label: 'City',
                  hint: 'Enter city',
                  prefixIcon: Iconsax.building,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          _buildTextField(
            controller: _localityController,
            label: 'Locality',
            hint: 'Enter locality/area',
            prefixIcon: Iconsax.location_add,
            isDark: isDark,
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          _buildTextField(
            controller: _streetAddressController,
            label: 'Street Address',
            hint: 'Enter street address',
            prefixIcon: Iconsax.home,
            validator: _validateAddress,
            isDark: isDark,
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          _buildTextField(
            controller: _zipCodeController,
            label: 'Zip Code',
            hint: 'Enter zip code',
            prefixIcon: Iconsax.code,
            keyboardType: TextInputType.number,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    required bool isDark,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      enabled: enabled,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
          borderSide: BorderSide(
            color: isDark ? TColors.darkGrey : TColors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
          borderSide: BorderSide(color: TColors.newBlue, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
          borderSide: BorderSide(
            color: isDark ? TColors.darkGrey : TColors.grey,
          ),
        ),
        filled: true,
        fillColor: enabled
            ? (isDark ? TColors.darkerGrey : TColors.white)
            : (isDark ? TColors.dark : TColors.lightContainer),
        contentPadding: const EdgeInsets.all(TSizes.md),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSaving ? null : _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.newBlue,
              foregroundColor: TColors.white,
              padding: const EdgeInsets.symmetric(vertical: TSizes.buttonHeight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TSizes.buttonRadius),
              ),
              elevation: 2,
            ),
            child: _isSaving
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: TColors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      const SizedBox(width: TSizes.sm),
                      Text(
                        'Saving...',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: TColors.white,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Iconsax.tick_circle, size: 20),
                      const SizedBox(width: TSizes.sm),
                      Text(
                        'Save Changes',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: TColors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _isSaving ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? TColors.white : TColors.black,
              side: BorderSide(
                color: isDark ? TColors.darkGrey : TColors.grey,
              ),
              padding: const EdgeInsets.symmetric(vertical: TSizes.buttonHeight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TSizes.buttonRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Iconsax.close_circle, size: 20),
                const SizedBox(width: TSizes.sm),
                Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}