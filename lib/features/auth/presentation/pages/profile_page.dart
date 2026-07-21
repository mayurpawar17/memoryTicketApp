import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_ticket_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:memory_ticket_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:memory_ticket_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:memory_ticket_app/features/auth/presentation/widgets/auth_button.dart';

import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_bloc.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_event.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_state.dart';
import '../../domain/entities/user_entity.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is GuestMode || state is Unauthenticated) {
                Navigator.pop(context);
              }
            },
          ),
          BlocListener<MemoryBloc, MemoryState>(
            listenWhen: (previous, current) => previous is MemorySyncing,
            listener: (context, state) {
              if (state is MemoryError && state.message.contains('Sync failed')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                );
              } else if (state is MemoryLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Memories synced successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            UserEntity? user;
            bool isLoggingOut = false;

            if (state is Authenticated) {
              user = state.user;
            } else if (state is AuthLoading && state.loadingType == AuthLoadingType.logout) {
              isLoggingOut = true;
            }

            if (user == null && !isLoggingOut) {
              return const Center(child: Text('Please login to view profile'));
            }

            if (user == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: user.photoUrl != null
                        ? NetworkImage(user.photoUrl!)
                        : const AssetImage('assets/app_icon.png') as ImageProvider,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    user.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  BlocBuilder<MemoryBloc, MemoryState>(
                    builder: (context, memoryState) {
                      return AuthButton(
                        text: 'Backup & Sync',
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        textColor: Theme.of(context).primaryColor,
                        isLoading: memoryState is MemorySyncing,
                        onPressed: () {
                          context.read<MemoryBloc>().add(SyncMemoriesEvent());
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  AuthButton(
                    text: 'Logout',
                    color: Colors.red[50],
                    textColor: Colors.red,
                    isLoading: isLoggingOut,
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutRequested());
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
