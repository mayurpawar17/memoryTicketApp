import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_bloc.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_event.dart';
import 'package:memory_ticket_app/features/memory/presentation/pages/home_page.dart';
import 'package:memory_ticket_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:memory_ticket_app/injection_container.dart' as di;
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Keep the splash screen until initialization is complete
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await di.init();
fl
  final prefs = await SharedPreferences.getInstance();
  final bool seenOnboarding = prefs.getBool('seen_onboarding') ?? false;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<MemoryBloc>()..add(LoadMemories())),
      ],
      child: MyApp(
        initialHome: seenOnboarding ? const HomePage() : const OnboardingPage(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Widget initialHome;
  const MyApp({super.key, required this.initialHome});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _removeSplash();
  }

  void _removeSplash() async {
    // Remove splash screen immediately when the app is ready
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Ticket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFF8F9FD),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4D41DF),
          surface: Color(0xFFF8F9FD),
          onSurface: Color(0xFF191C1F),
        ),
        useMaterial3: true,
      ),
      home: widget.initialHome,
    );
  }
}
