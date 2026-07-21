import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_ticket_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:memory_ticket_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:memory_ticket_app/features/auth/presentation/pages/login_page.dart';

import 'package:memory_ticket_app/features/auth/presentation/pages/profile_page.dart';

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    String greeting = 'Hello 👋';
                    if (state is Authenticated) {
                      greeting = 'Hi, ${state.user.name.split(' ').first} 👋';
                    }
                    return Text(
                      greeting,
                      style: theme.textTheme.titleLarge?.copyWith(
                        letterSpacing: -0.5,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  "Capture today's memories.",
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: state.user.photoUrl != null
                        ? NetworkImage(state.user.photoUrl!)
                        : const AssetImage('assets/app_icon.png') as ImageProvider,
                  ),
                );
              }
              return OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                icon: const Icon(Icons.sync, size: 18),
                label: const Text('Backup & Sync'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
