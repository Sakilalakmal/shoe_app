import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shoe_app_web_admin_panel/view/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb || Platform.isAndroid
        ? FirebaseOptions(
            apiKey: "AIzaSyACYDvF__6sIKtv-djYLrfPxCb03_Kcr_o",
            appId: "1:424813417451:web:e51b3c4546e349685c7fae",
            messagingSenderId: "424813417451",
            projectId: "sneakersx-21b40",
            storageBucket: "sneakersx-21b40.firebasestorage.app",
          )
        : null,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MainScreen(),
       builder: EasyLoading.init(),
    );
  }
}
