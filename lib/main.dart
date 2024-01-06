import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lapor_book/firebase_options.dart';
import 'package:lapor_book/pages/AddFormPage.dart';
import 'package:lapor_book/pages/dashboard/DashboardPage.dart';
import 'package:lapor_book/pages/DetailPage.dart';
import 'package:lapor_book/pages/LoginPage.dart';
import 'package:lapor_book/pages/RegisterPage.dart';
import 'package:lapor_book/pages/SplashPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lapor Book',
    initialRoute: '/',
    routes: {
      '/': (context) => const SplashPage(),
      '/login': (context) => const LoginPage(),
      '/register': (context) => const RegisterPage(),
      '/dashboard': (context) => const DashboardPage(),
      '/add': (context) => AddFormPage(),
      '/detail': (context) => const DetailPage(),
    },
    );
  }
}