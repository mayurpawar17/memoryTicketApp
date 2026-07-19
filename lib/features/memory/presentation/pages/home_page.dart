import 'package:flutter/material.dart';
import 'package:memory_ticket_app/features/memory/presentation/pages/create_memory_ticket_page.dart'
    hide MemoryTicketCard;

import '../../data/model/memory_model.dart';
import '../widgets/category_chips.dart';
import '../widgets/home_header.dart';
import '../widgets/memory_serach_bar.dart';
import '../widgets/memory_ticket_card.dart';
import 'memory_ticket_details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            const SliverToBoxAdapter(child: CategoryChips()),
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
              delegate: SliverChildBuilderDelegate((context, index) {
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
                            MemoryTicketDetailsScreen(imageUrl: item.imageUrl),
                      ),
                    );
                  },
                  onFavorite: () {},
                  onMore: () {},
                );
              }, childCount: dummyMemories.length),
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
            MaterialPageRoute(builder: (_) => NewMemoryPage()),
          );
        },
        elevation: 6,
        // shadowColor: theme.colorScheme.primary.withOpacity(0.4),
        backgroundColor: Colors.transparent,
        label: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
              // Deep Purple Gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
                  fontWeight: FontWeight.bold,
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
