import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parkware/controllers/user_controller.dart';
import 'package:parkware/firebase_options.dart';
import 'package:parkware/pages/home_page.dart';
import 'package:parkware/pages/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:parkware/config/constants/environment.dart';

Future<void> initializeDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();

  // * Initialize Environment variables
  await dotenv.load(fileName: ".env");

  // * Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // * Initialize Stripe
  Stripe.publishableKey = Environment.stripePublishableKey;
  Stripe.instance.applySettings();
}

Future<void> main() async {
  await initializeDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue,),
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: UserController.user != null ? const HomePage() : const LoginPage(),
    );
  }
}
