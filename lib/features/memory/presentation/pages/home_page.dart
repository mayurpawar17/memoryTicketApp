import 'package:flutter/material.dart';
import 'package:memory_ticket_app/core/colors/app_colors.dart';
import 'package:memory_ticket_app/core/widgets/custom_category_chips.dart';
import 'package:memory_ticket_app/features/memory/presentation/pages/create_memory_ticket_page.dart';

import '../../data/model/memory_model.dart';
import '../widgets/home_header.dart';
import '../widgets/memory_serach_bar.dart';
import '../widgets/memory_ticket_card.dart';
import 'memory_ticket_details_page.dart';

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
        child: CustomScrollView(
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
                    Text('Recent Memories', style: theme.textTheme.titleLarge),
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

            // Dynamic Ticket ListView
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = dummyMemories[index];
                  return MemoryTicketCard(
                    imageUrl: item.imageUrl,
                    title: item.title,
                    location: item.location,
                    date: item.date,
                    description: item.description,
                    isFavorite: item.isFavorite,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MemoryTicketDetailsScreen(memoryModel: item),
                        ),
                      );
                    },
                  );
                },
                childCount: dummyMemories.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
            // Space adjustment for FAB overlay
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewMemoryPage()),
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
