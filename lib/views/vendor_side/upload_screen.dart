import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/components/notify_message/motion_toast.dart';
import 'package:uuid/uuid.dart';

class UploadScreen extends StatefulWidget {
  UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController _sizeController = TextEditingController();
  List<String> _imageUrls = [];

  bool _isLoading = false;
  bool _isEntered = false;

  final List<String> _categoriesList = [];
  final List<String> _sizesList = [];

  String? selectedCategory;
  String? shoeName;
  String? brandName;
  double? shoePrice;
  int? discount;
  int? quantity;
  String? shoeDescription;

  @override
  void initState() {
    super.initState();
    _getCategory();
  }

  Future<void> _getCategory() async {
    final querySnapshot = await _firestore.collection('categories').get();
    for (var doc in querySnapshot.docs) {
      setState(() {
        _categoriesList.add(doc['categoryName']);
      });
    }
  }

  //create an instance of ImagePicker to handle image picker
  final ImagePicker _picker = ImagePicker();

  //initialize an empty list to store the seletced images
  List<File> images = [];

  //define a function to pick images from gallery
  Future<void> chooseImage() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles == null || pickedFiles.isEmpty) {
      print("No images selected");
      return;
    }

    setState(() {
      images.addAll(pickedFiles.map((xfile) => File(xfile.path)));
    });
  }

  //image upload to cloud
  Future<List<String>> uploadImagesToStorage(List<File> images) async {
    List<String> urls = [];
    for (var img in images) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('shoesImages')
          .child(const Uuid().v4());
      await ref.putFile(img);
      final url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  Future<void> uploadData() async {
    setState(() => _isLoading = true);
    _imageUrls = await uploadImagesToStorage(images);

    if (_imageUrls.isNotEmpty) {
      final shoeId = const Uuid().v4();
      await _firestore.collection('shoes').doc(shoeId).set({
        'shoeId': shoeId,
        'shoeName': shoeName,
        'brandName': brandName,
        'shoePrice': shoePrice,
        'discount': discount,
        'quantity': quantity,
        'shoeDescription': shoeDescription,
        'shoeCategory': selectedCategory,
        'shoeSizes': _sizesList,
        'shoeImages': _imageUrls,
        'vendorId': FirebaseAuth.instance.currentUser!.uid,
      });
      setState(() {
        _isLoading = false;
        _formKey.currentState!.reset();
        _imageUrls.clear();
        images.clear();
        _sizesList.clear();
      });
    }

    AppToast.success(context, "Shoe uploaded to SneakersX successfully");
  }

  final themeColor = const Color(0xFF2D9CDB);

  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      child: Form(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upload New Shoes",
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium!.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: TSizes.defaultSpace),
                  const SizedBox(height: 32),
                  _buildTextField(
                    "Enter Shoe Name",
                    (val) => shoeName = val,
                    icon: Iconsax.document5,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          "Enter Shoe Price",
                          (val) => shoePrice = double.tryParse(val),
                          icon: Iconsax.dollar_square5,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDropdownField()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    "Enter Shoe Brand Name",
                    (val) => brandName = (val),
                    icon: Iconsax.category5,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    "Enter Shoe Discount Price",
                    (val) => discount = int.tryParse(val),
                    icon: Iconsax.discount_circle5,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    "Quantity of Shoes",
                    (val) => quantity = int.tryParse(val),
                    icon: Iconsax.shopping_bag5,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    onChanged: (val) => shoeDescription = val,
                    maxLines: 4,
                    maxLength: 800,
                    validator: _validator,
                    style: GoogleFonts.poppins(),
                    decoration: _inputDecoration("Enter Shoe Description"),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _sizeController,
                          onChanged: (val) => setState(() => _isEntered = true),
                          style: GoogleFonts.poppins(),
                          decoration: _inputDecoration("Enter Shoe Size"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (_isEntered)
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _sizesList.add(_sizeController.text.trim());
                              _sizeController.clear();
                              _isEntered = false;
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Add"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            textStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (_sizesList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Wrap(
                        spacing: 10,
                        children: _sizesList
                            .map(
                              (size) => Chip(
                                label: Text(
                                  size,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: themeColor,
                                deleteIconColor: Colors.white,
                                onDeleted: () {
                                  setState(() => _sizesList.remove(size));
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: images.length + 1,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return GestureDetector(
                          onTap: chooseImage,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [TColors.newBlue, TColors.black],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add_a_photo_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            images[index - 1],
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: TSizes.defaultSpace,
                    ),
                    child: SizedBox(
                      width: HelperFunctions.screenWidth(),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            uploadData();
                          }
                        },
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Upload Shoe to SneakersX",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      color: isDark
                                          ? TColors.black
                                          : TColors.white,
                                    ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    Function(String) onChanged, {
    IconData? icon,
  }) {
    return TextFormField(
      onChanged: onChanged,
      validator: _validator,
      style: GoogleFonts.poppins(),
      decoration: _inputDecoration(label, icon: icon),
    );
  }

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      labelStyle: GoogleFonts.poppins(fontSize: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  String? _validator(String? value) {
    return (value == null || value.isEmpty) ? "Required field" : null;
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField(
      decoration: _inputDecoration("Select Shoe Category"),
      value: selectedCategory,
      items: _categoriesList
          .map(
            (category) =>
                DropdownMenuItem(value: category, child: Text(category)),
          )
          .toList(),
      onChanged: (value) => setState(() => selectedCategory = value),
    );
  }
}
