import 'package:flutter/material.dart';
import 'package:memory_ticket_app/features/onboarding/presentation/pages/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(
          0xFFF7F9FC,
        ), // Premium light background
        primaryColor: const Color(0xFF4E44E7),
        fontFamily: 'sans-serif',
      ),
      home: const MemorySplashPage(),
    );
  }
}
