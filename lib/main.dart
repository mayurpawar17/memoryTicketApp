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
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFF8F9FD),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4D41DF),
          surface: Color(0xFFF8F9FD),
          onSurface: Color(0xFF191C1F),
        ),
      ),
      home: const MemorySplashPage(),
    );
  }
}
