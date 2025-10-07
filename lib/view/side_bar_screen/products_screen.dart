import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class ProductsScreen extends StatefulWidget {
  static const String id = "\productsScreen";
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final TextEditingController _sizeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isEntered = false;

  final List<String> _categoriesList = [];
  final List<String> _sizesList = [];
  final List<Uint8List> _images = [];
  List<String> _imageUrls = [];

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

  Future<void> chooseImage() async {
    final pickedImages = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (pickedImages != null) {
      setState(() {
        for (var file in pickedImages.files) {
          _images.add(file.bytes!);
        }
      });
    }
  }

  Future<void> uploadImageToStorage() async {
    for (var img in _images) {
      final ref = _storage.ref().child('shoesImages').child(Uuid().v4());
      await ref.putData(img);
      final url = await ref.getDownloadURL();
      _imageUrls.add(url);
    }
  }

  Future<void> uploadData() async {
    setState(() => _isLoading = true);
    await uploadImageToStorage();

    if (_imageUrls.isNotEmpty) {
      final shoeId = Uuid().v4();
      await _firestore.collection('shoes').doc().set({
        'shoeId': shoeId,
        'shoeName': shoeName,
        'brandName':brandName,
        'shoePrice': shoePrice,
        'discount': discount,
        'quantity': quantity,
        'shoeDescription': shoeDescription,
        'shoeCategory': selectedCategory,
        'shoeSizes': _sizesList,
        'shoeImages': _imageUrls,
      });
      setState(() {
        _isLoading = false;
        _formKey.currentState!.reset();
        _imageUrls.clear();
        _images.clear();
        _sizesList.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF2D9CDB); // Primary blue

    return Container(
      color: const Color(0xFFF9FAFB),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SneakersX — Add New Product",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E1E2F),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildTextField("Enter Shoe Name", (val) => shoeName = val),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField("Enter Shoe Price",
                            (val) => shoePrice = double.tryParse(val)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDropdownField()),
                    ],
                  ),
                   const SizedBox(height: 20),
                  _buildTextField("Enter Shoe Brand Name",
                      (val) => brandName = (val)),
                  const SizedBox(height: 20),
                  _buildTextField("Enter Shoe Discount Price",
                      (val) => discount = int.tryParse(val)),
                  const SizedBox(height: 20),
                  _buildTextField("Quantity of Shoes",
                      (val) => quantity = int.tryParse(val)),
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
                          onChanged: (val) =>
                              setState(() => _isEntered = true),
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
                                horizontal: 24, vertical: 14),
                            textStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                    ],
                  ),
                  if (_sizesList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Wrap(
                        spacing: 10,
                        children: _sizesList
                            .map((size) => Chip(
                                  label: Text(size,
                                      style: GoogleFonts.poppins(
                                          color: Colors.white)),
                                  backgroundColor: themeColor,
                                  deleteIconColor: Colors.white,
                                  onDeleted: () {
                                    setState(() => _sizesList.remove(size));
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: _images.length + 1,
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
                                colors: [
                                  themeColor,
                                  themeColor.withOpacity(0.8)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Icon(Icons.add_a_photo_rounded,
                                  color: Colors.white),
                            ),
                          ),
                        );
                      } else {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            _images[index - 1],
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          uploadData();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Upload Shoe to SneakersX",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField(
      decoration: _inputDecoration("Select Shoe Category"),
      value: selectedCategory,
      items: _categoriesList
          .map((category) =>
              DropdownMenuItem(value: category, child: Text(category)))
          .toList(),
      onChanged: (value) => setState(() => selectedCategory = value),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged) {
    return TextFormField(
      onChanged: onChanged,
      validator: _validator,
      style: GoogleFonts.poppins(),
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  String? _validator(String? value) {
    return (value == null || value.isEmpty) ? "Required field" : null;
  }
}
