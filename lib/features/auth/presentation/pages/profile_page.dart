import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_ticket_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:memory_ticket_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:memory_ticket_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_bloc.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_state.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_event.dart';
import '../../domain/entities/user_entity.dart';
import 'package:memory_ticket_app/core/utils/app_dialogs.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/setting_groups_card.dart';
import '../widgets/settings_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showLogoutDialog(BuildContext context) {
    AppDialogs.showConfirmationDialog(
      context: context,
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      onConfirm: () {
        context.read<AuthBloc>().add(LogoutRequested());
      },
    );
  }

  void _showSyncDialog(BuildContext context) {
    AppDialogs.showConfirmationDialog(
      context: context,
      title: 'Backup & Sync',
      content: 'Do you want to sync your memories with the cloud?',
      confirmText: 'Sync Now',
      confirmColor: Theme.of(context).primaryColor,
      onConfirm: () {
        context.read<MemoryBloc>().add(SyncMemoriesEvent());
      },
    );
  }

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
            listener: (context, state) {
              if (state is MemorySyncing) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 16),
                        Text('Syncing memories...'),
                      ],
                    ),
                    duration: Duration(days: 1),
                  ),
                );
              }
            },
          ),
          BlocListener<MemoryBloc, MemoryState>(
            listenWhen: (previous, current) => previous is MemorySyncing,
            listener: (context, state) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
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

            final currentUser = user;
            final photoUrl = currentUser.photoUrl;

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // User Header Card
                          ProfileHeaderCard(
                            user: currentUser,
                          ),
                          const SizedBox(height: 20),

                          SettingsGroupCard(
                            children: [
                              // SettingsTile(
                              //   icon: Icons.notifications_none_outlined,
                              //   title: 'Notification',
                              //   onTap: () {},
                              // ),
                              SettingsTile(
                                icon: Icons.cloud_sync_outlined, // or Icons.backup_outlined
                                title: 'Backup & Sync',
                                subtitle: 'Auto-backup your data to cloud',
                                onTap: () => _showSyncDialog(context),
                              ),

                              SettingsTile(
                                icon: Icons.logout,
                                title: 'Log out',
                                onTap: () => _showLogoutDialog(context),
                                showDivider: false, // Hide last divider in card
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          // Column(
                          //   children: [
                          //     const SizedBox(height: 20),
                          //     CircleAvatar(
                          //       radius: 60,
                          //       backgroundColor: Colors.grey[200],
                          //       backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                          //           ? CachedNetworkImageProvider(photoUrl)
                          //           : null,
                          //       child: (photoUrl == null || photoUrl.isEmpty)
                          //           ? SvgPicture.asset(
                          //               'assets/profileIcon.svg',
                          //               width: 60,
                          //               height: 60,
                          //             )
                          //           : null,
                          //     ),
                          //     const SizedBox(height: 24),
                          //     Text(
                          //       currentUser.name,
                          //       style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          //     ),
                          //     Text(
                          //       currentUser.email,
                          //       style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
