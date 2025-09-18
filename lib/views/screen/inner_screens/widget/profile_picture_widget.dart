import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePictureWidget extends StatefulWidget {
  final String userId;
  final Color borderColor;
  final Color backgroundColor;
  final bool showCamera;
  final double radius;

  const ProfilePictureWidget({
    Key? key,
    required this.userId,
    required this.borderColor,
    required this.backgroundColor,
    this.showCamera = true,
    this.radius = 60,
  }) : super(key: key);

  @override
  State<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  Uint8List? _profileImageBytes;
  bool _loading = false;

  final _prefsKey = "profile_pic_cache";

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    // 1. Try local cache first
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? base64Image = prefs.getString(_prefsKey + widget.userId);

    if (base64Image != null) {
      setState(() {
        _profileImageBytes = base64Decode(base64Image);
      });
      return;
    }

    // 2. Fetch Firestore URL and cache if found
    final doc = await FirebaseFirestore.instance
        .collection('buyers')
        .doc(widget.userId)
        .get();

    final url = doc.data()?['profileImage'] as String?;
    if (url != null && url.isNotEmpty) {
      try {
        final networkImage = await NetworkAssetBundle(Uri.parse(url)).load(url);
        final bytes = networkImage.buffer.asUint8List();
        setState(() {
          _profileImageBytes = bytes;
        });
        prefs.setString(_prefsKey + widget.userId, base64Encode(bytes));
      } catch (e) {
        // handle error, maybe show default image
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    if (picked == null) return;

    setState(() => _loading = true);

    try {
      // 1. Upload to Firebase Storage
      final ref = FirebaseStorage.instance
          .ref('profile_pics/${widget.userId}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putData(await picked.readAsBytes());

      final url = await ref.getDownloadURL();

      // 2. Update Firestore
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(widget.userId)
          .update({'profileImage': url});

      // 3. Download image and cache
      final networkImage = await NetworkAssetBundle(Uri.parse(url)).load(url);
      final bytes = networkImage.buffer.asUint8List();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(_prefsKey + widget.userId, base64Encode(bytes));

      setState(() {
        _profileImageBytes = bytes;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      // Optionally show error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: widget.borderColor,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: widget.radius,
            backgroundColor: Colors.transparent,
            child: _profileImageBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.memory(
                      _profileImageBytes!,
                      fit: BoxFit.cover,
                      width: widget.radius * 2,
                      height: widget.radius * 2,
                    ),
                  )
                : Icon(Icons.person, size: widget.radius),
          ),
        ),
        if (widget.showCamera)
          Positioned(
            right: 5,
            bottom: 5,
            child: GestureDetector(
              onTap: _loading ? null : _pickAndUploadImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.backgroundColor,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: _loading
                    ? SizedBox(
                        width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ),
      ],
    );
  }
}
