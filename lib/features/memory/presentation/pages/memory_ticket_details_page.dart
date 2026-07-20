import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memory_ticket_app/core/widgets/custom_app_bar.dart';
import 'package:memory_ticket_app/features/memory/domain/entities/memory.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_bloc.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_event.dart';
import 'package:memory_ticket_app/features/memory/presentation/pages/edit_memory_ticket_page.dart';
import '../widgets/memory_ticket_card.dart';

class MemoryTicketDetailsScreen extends StatefulWidget {
  final Memory memory;

  const MemoryTicketDetailsScreen({super.key, required this.memory});

  @override
  State<MemoryTicketDetailsScreen> createState() => _MemoryTicketDetailsScreenState();
}

class _MemoryTicketDetailsScreenState extends State<MemoryTicketDetailsScreen> {
  late Memory _memory;

  @override
  void initState() {
    super.initState();
    _memory = widget.memory;
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Delete Memory"),
          content: const Text("Are you sure you want to delete this memory?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                context.read<MemoryBloc>().add(DeleteMemoryEvent(_memory.id));
                Navigator.pop(dialogContext); // Close dialog
                Navigator.pop(context); // Go back to Home
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Defines where the ticket cuts out horizontally (69% down the canvas)
    return Scaffold(
      appBar: CustomAppBar(title: "Ticket Stub"),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            MemoryTicketCard(
              imagePath: _memory.imagePath,
              title: _memory.title,
              location: _memory.location,
              date: _memory.date,
              description: _memory.description,
              isFavorite: _memory.isFavorite,
              onFavorite: () {
                context.read<MemoryBloc>().add(
                      ToggleFavoriteEvent(_memory.id, !_memory.isFavorite),
                    );
                setState(() {
                  _memory = Memory(
                    id: _memory.id,
                    title: _memory.title,
                    description: _memory.description,
                    location: _memory.location,
                    date: _memory.date,
                    imagePath: _memory.imagePath,
                    category: _memory.category,
                    isFavorite: !_memory.isFavorite,
                  );
                });
              },
            ),
            const Spacer(),

            // --- Premium Action Control Row ---
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0, left: 40, right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Download Button
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.download,
                      size: 26,
                      color: Colors.black26,
                    ),
                    onPressed: () {},
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      size: 26,
                      color: Colors.black26,
                    ),
                    onPressed: () async {
                      final updatedMemory = await Navigator.push<Memory>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditMemoryTicketPage(memory: _memory),
                        ),
                      );
                      if (updatedMemory != null) {
                        setState(() {
                          _memory = updatedMemory;
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      size: 26,
                      color: Colors.black26,
                    ),
                    onPressed: () => _showDeleteDialog(context),
                  ),

                  // Share Button
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.share,
                      size: 26,
                      color: Colors.black26,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
