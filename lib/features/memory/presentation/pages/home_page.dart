import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_ticket_app/features/memory/domain/entities/memory.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_bloc.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_event.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_state.dart';
import 'package:memory_ticket_app/features/memory/presentation/pages/new_memory_ticket_page.dart';
import 'package:memory_ticket_app/features/memory/presentation/pages/memory_ticket_details_page.dart';

import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/widgets/custom_category_chips.dart';
import '../../../../core/utils/category_utils.dart';
import '../../../timeline_v2/screens/timeline_page.dart';
import '../widgets/home_header.dart';
import '../widgets/memory_ticket_card.dart';

import 'package:memory_ticket_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:memory_ticket_app/features/auth/presentation/bloc/auth_state.dart';

import 'package:memory_ticket_app/features/memory/presentation/pages/favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _categories = [
    'All',
    'Travel',
    'Food',
    'Friends',
    'Nature',
    'Work',
    'Family',
    'Pets',
    'Personal',
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MemoryBloc, MemoryState>(
      builder: (context, state) {
        final List<Memory> currentMemories = state is MemoryLoaded
            ? state.memories
            : (state is MemorySyncing ? state.memories : []);
        final bool hasMemories = currentMemories.isNotEmpty;
        final bool showFab = hasMemories;

        return Scaffold(
          floatingActionButton: showFab
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Timeline Button
                      _buildCircularButton(
                        context,
                        icon: Icons.timeline_rounded,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const TimelinePage2()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Favorites Button
                      _buildCircularButton(
                        context,
                        icon: Icons.favorite_rounded,
                        iconColor: Colors.redAccent,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const FavoritesPage()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // New Memory Button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const NewMemoryTicketPage()),
                          );
                        },
                        child: Container(
                          height: 54,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'New Memory',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: MultiBlocListener(
            listeners: [
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is Authenticated) {
                    context.read<MemoryBloc>().add(SyncMemoriesEvent());
                  } else if (state is GuestMode || state is Unauthenticated) {
                    context.read<MemoryBloc>().add(LoadMemories());
                  }
                },
              ),
              BlocListener<MemoryBloc, MemoryState>(
                listener: (context, state) {
                  if (state is MemoryError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
              ),
            ],
            child: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(child: HomeHeader()),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  if (hasMemories)
                    SliverToBoxAdapter(
                      child: CustomCategoryChips(
                        categories: _categories,
                        icons: _categories
                            .map((c) => CategoryUtils.getIcon(c))
                            .toList(),
                        selectedIndex: _selectedIndex,
                        onSelected: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Recent Section Header Row
                  if (hasMemories)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Recent Memories',
                                style: theme.textTheme.titleLarge),
                          ],
                        ),
                      ),
                    ),

                  if (state is MemoryLoading)
                    const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state is MemoryError)
                    SliverToBoxAdapter(
                      child: Center(child: Text(state.message)),
                    )
                  else if (hasMemories)
                    () {
                      final selectedCategory = _categories[_selectedIndex];
                      final filteredMemories = selectedCategory == 'All'
                          ? currentMemories
                          : currentMemories
                              .where((m) => m.category == selectedCategory)
                              .toList();

                      if (filteredMemories.isEmpty) {
                        return _buildEmptyState(
                          context,
                          isFilter: currentMemories.isNotEmpty,
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = filteredMemories[index];
                            return MemoryTicketCard(
                              imagePath: item.imagePath,
                              title: item.title,
                              location: item.location,
                              date: item.date,
                              description: item.description,
                              isFavorite: item.isFavorite,
                              ticketType: item.ticketType,
                              heroTag: 'memory_image_${item.id}',
                              onFavorite: () {
                                context.read<MemoryBloc>().add(
                                      ToggleFavoriteEvent(
                                          item.id, !item.isFavorite),
                                    );
                              },
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MemoryTicketDetailsScreen(
                                        memory: item),
                                  ),
                                );
                              },
                            );
                          },
                          childCount: filteredMemories.length,
                        ),
                      );
                    }()
                  else
                    _buildEmptyState(context, isFilter: false),

                  if (!hasMemories || state is! MemoryLoading)
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, {required bool isFilter}) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFilter
                      ? Icons.search_off_rounded
                      : Icons.auto_awesome_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isFilter ? 'No memories found' : 'Start Your Journey',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isFilter
                    ? 'We couldn\'t find any memories in this category.'
                    : 'Capture and cherish your special moments. Create your first memory ticket now!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              if (!isFilter) ...[
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const NewMemoryTicketPage()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create New Memory'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton(BuildContext context,
      {required IconData icon, Color? iconColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        width: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Icon(icon, color: iconColor ?? Colors.black87),
      ),
    );
  }
}
