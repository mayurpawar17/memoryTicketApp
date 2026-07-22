import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_ticket_app/core/colors/app_theme.dart';
import 'package:memory_ticket_app/core/widgets/custom_app_bar.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_bloc.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_state.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_event.dart';
import 'package:memory_ticket_app/features/memory/presentation/widgets/memory_ticket_card.dart';
import 'package:memory_ticket_app/features/memory/presentation/pages/memory_ticket_details_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: CustomAppBar(title: "Favorite Memories"),
      body: BlocBuilder<MemoryBloc, MemoryState>(
        builder: (context, state) {
          if (state is MemoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MemoryLoaded) {
            final favorites = state.memories.where((m) => m.isFavorite).toList();

            if (favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 64,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No favorites yet",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Tap the heart on any memory to save it here.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 12, bottom: 100),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                return MemoryTicketCard(
                  imagePath: item.imagePath,
                  title: item.title,
                  location: item.location,
                  date: item.date,
                  description: item.description,
                  isFavorite: item.isFavorite,
                  ticketType: item.ticketType,
                  heroTag: 'fav_memory_image_${item.id}',
                  onFavorite: () {
                    context.read<MemoryBloc>().add(
                          ToggleFavoriteEvent(item.id, !item.isFavorite),
                        );
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MemoryTicketDetailsScreen(memory: item),
                      ),
                    );
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
