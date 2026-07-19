# memory_ticket_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


onboarding theme config

```dart
//onboarding theme config
theme: ThemeData(
fontFamily: 'Inter',
scaffoldBackgroundColor: const Color(0xFFF8F9FD),
colorScheme: const ColorScheme.light(
primary: Color(0xFF4D41DF),
surface: Color(0xFFF8F9FD),
onSurface: Color(0xFF191C1F),
),
),
```

```dart
//default theme config
 theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(
          0xFFF7F9FC,
        ), // Premium light background
        primaryColor: const Color(0xFF4E44E7),
        fontFamily: 'sans-serif',
      ),
```
