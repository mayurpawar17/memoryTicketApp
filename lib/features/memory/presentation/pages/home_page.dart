import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_bloc.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_event.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_state.dart';
import 'package:memory_ticket_app/features/memory/presentation/pages/new_memory_ticket_page.dart';
import 'package:memory_ticket_app/features/memory/presentation/pages/memory_ticket_details_page.dart';

import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/widgets/custom_category_chips.dart';
import '../widgets/home_header.dart';
import '../widgets/memory_search_bar.dart';
import '../widgets/memory_ticket_card.dart';

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
      body: SafeArea(
        child: BlocBuilder<MemoryBloc, MemoryState>(
          builder: (context, state) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: HomeHeader()),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                const SliverToBoxAdapter(child: MemorySearchBar()),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: CustomCategoryChips(
                    categories: _categories,
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
                  state.memories.isEmpty
                      ? const SliverToBoxAdapter(
                          child: Center(child: Text('No memories yet.')),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = state.memories[index];
                              return MemoryTicketCard(
                                imagePath: item.imagePath,
                                title: item.title,
                                location: item.location,
                                date: item.date,
                                description: item.description,
                                isFavorite: item.isFavorite,
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
                                      builder: (_) =>
                                          MemoryTicketDetailsScreen(
                                              memory: item),
                                    ),
                                  );
                                },
                              );
                            },
                            childCount: state.memories.length,
                          ),
                        )
                else
                  const SliverToBoxAdapter(child: SizedBox.shrink()),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewMemoryTicketPage()),
          );
        },
        elevation: 6,
        backgroundColor: Colors.transparent,
        label: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
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
        icon: const SizedBox.shrink(),
        extendedPadding: EdgeInsets.zero,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
