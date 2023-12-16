import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lapor_book/firebase_options.dart';
import 'package:lapor_book/pages/SplashPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MaterialApp(
    title: "Aplikasi Lapor Book", 
    initialRoute: '/', 
    routes: {
    '/': (context) => const SplashPage(),
    // '/login': (context) => LoginPage(),
  }));
}
