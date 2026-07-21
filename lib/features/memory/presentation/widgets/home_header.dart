import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Evening 👋',
                style: theme.textTheme.titleLarge?.copyWith(
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Capture today's memories.",
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(
              'assets/goa.jpg',
            ),
          ),
        ],
      ),
    );
  }
}
