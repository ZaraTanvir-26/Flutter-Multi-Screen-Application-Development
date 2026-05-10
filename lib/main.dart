// ============================================================
// main.dart — App entry point
// ============================================================

import 'package:flutter/material.dart';
import 'screens/registration_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student App',
      debugShowCheckedModeBanner: false,   // hides the red "DEBUG" ribbon

      // ── App-wide theme ─────────────────────────────────────
      theme: ThemeData(
        // Primary color used throughout the app
        primarySwatch: Colors.indigo,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,

        // Default AppBar style
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        // Default ElevatedButton style
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
        ),
      ),

      // ── Starting screen ────────────────────────────────────
      // App starts at the Registration screen.
      // After registering, the user is sent to Login.
      home: const RegistrationScreen(),
    );
  }
}
