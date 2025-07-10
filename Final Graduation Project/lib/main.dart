import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'splash_screen.dart';

void main() async {
  //await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Initialization
  try {
    await Firebase.initializeApp();
  // ignore: empty_catches
  } catch (e) {
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // هنا بنستدعي الشاشة
    );
  }
}