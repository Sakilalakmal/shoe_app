import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoe_app_web_admin_panel/view/side_bar_screen/widgets/category_list_widget.dart';
import 'package:uuid/uuid.dart';

class CategoryUploadScreen extends StatefulWidget {
  static const String id = "\categoryUploadScreen";
  const CategoryUploadScreen({super.key});

  @override
  State<CategoryUploadScreen> createState() => _CategoryUploadScreenState();
}

class _CategoryUploadScreenState extends State<CategoryUploadScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  dynamic _image;
  String? fileName;
  late String categoryName;

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  }

  _uploadImageToStorage(dynamic image) async {
    Reference ref = _firebaseStorage.ref().child('categories').child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadToFierStore() async {
    if (_formKey.currentState!.validate()) {
      if (_image != null) {
        EasyLoading.show();
        String imageUrl = await _uploadImageToStorage(_image);
        String docId = const Uuid().v4();
        await _firestore.collection('categories').doc(docId).set({
          'categoryName': categoryName,
          'categoryImage': imageUrl,
        }).whenComplete(() {
          EasyLoading.dismiss();
          _image = null;
        });
      } else {
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Form(
          key: _formKey,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 850),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.1),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                )
              ],
              gradient: LinearGradient(
                colors: [Colors.white, Colors.blue.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
                        ),
                      ),
                      child: const Icon(Icons.category, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "Upload New Category",
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Divider(color: Colors.blueGrey.shade100, thickness: 1),
                const SizedBox(height: 24),

                // Main Form Area
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Section
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Container(
                            height: 180,
                            width: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blueAccent.shade100,
                                  Colors.blueAccent.shade200,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent.withOpacity(0.2),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: _image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.memory(
                                        _image,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.image,
                                      size: 70,
                                      color: Colors.white70,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: pickImage,
                            icon: const Icon(Icons.upload_file, color: Colors.blueAccent),
                            label: Text(
                              "Choose Image",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.blueAccent,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.blueAccent, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                    // Form Fields
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          TextFormField(
                            onChanged: (value) => categoryName = value,
                            validator: (value) => value == null || value.isEmpty
                                ? "Please Enter Category Name"
                                : null,
                            style: GoogleFonts.poppins(),
                            decoration: InputDecoration(
                              labelText: "Category Name",
                              labelStyle: GoogleFonts.poppins(
                                color: Colors.blueGrey[700],
                                fontWeight: FontWeight.w600,
                              ),
                              prefixIcon: const Icon(Icons.label, color: Colors.blueAccent),
                              filled: true,
                              fillColor: Colors.blueGrey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: uploadToFierStore,
                              icon: const Icon(Icons.save_alt),
                              label: Text(
                                "Save Category",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Divider(color: Colors.blueGrey.shade100, thickness: 1),
                const SizedBox(height: 20),
                const CategoryListWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
