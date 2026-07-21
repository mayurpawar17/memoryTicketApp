import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_bloc.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_event.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_state.dart';
import 'package:memory_ticket_app/features/memory/presentation/pages/new_memory_ticket_page.dart';
import 'package:memory_ticket_app/features/memory/presentation/pages/memory_ticket_details_page.dart';

import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/widgets/custom_category_chips.dart';
import '../../../../core/utils/category_utils.dart';
import '../widgets/home_header.dart';
import '../widgets/memory_ticket_card.dart';

import 'package:memory_ticket_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:memory_ticket_app/features/auth/presentation/bloc/auth_state.dart';

import 'package:memory_ticket_app/features/memory/presentation/pages/timeline_page.dart';
import 'package:memory_ticket_app/features/memory/presentation/pages/map_page.dart';

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
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Timeline Button
            _buildCircularButton(
              context,
              icon: Icons.timeline_rounded,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimelinePage()),
              ),
            ),
            const SizedBox(width: 12),
            // Map Button
            _buildCircularButton(
              context,
              icon: Icons.map_rounded,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MapPage()),
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Authenticated) {
                // Trigger sync when user logs in or app starts authenticated
                context.read<MemoryBloc>().add(SyncMemoriesEvent());
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
          child: BlocBuilder<MemoryBloc, MemoryState>(
            builder: (context, state) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(child: HomeHeader()),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recent Memories',
                              style: theme.textTheme.titleLarge),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'See All',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
                  else if (state is MemoryLoaded)
                    () {
                      final selectedCategory = _categories[_selectedIndex];
                      final filteredMemories = selectedCategory == 'All'
                          ? state.memories
                          : state.memories
                              .where((m) => m.category == selectedCategory)
                              .toList();

                      if (filteredMemories.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 40.0),
                              child: Text('No memories in this category.'),
                            ),
                          ),
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
                    const SliverToBoxAdapter(child: SizedBox.shrink()),

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton(BuildContext context,
      {required IconData icon, required VoidCallback onTap}) {
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
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }
}
