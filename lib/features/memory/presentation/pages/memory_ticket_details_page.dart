import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memory_ticket_app/core/widgets/custom_app_bar.dart';
import 'package:memory_ticket_app/features/memory/domain/entities/memory.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_bloc.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_event.dart';
import 'package:memory_ticket_app/features/memory/presentation/pages/edit_memory_ticket_page.dart';
import 'package:memory_ticket_app/features/memory/presentation/services/ticket_export_service.dart';
import 'package:memory_ticket_app/core/utils/app_dialogs.dart';
import '../widgets/memory_ticket_card.dart';

class MemoryTicketDetailsScreen extends StatefulWidget {
  final Memory memory;

  const MemoryTicketDetailsScreen({super.key, required this.memory});

  @override
  State<MemoryTicketDetailsScreen> createState() => _MemoryTicketDetailsScreenState();
}

class _MemoryTicketDetailsScreenState extends State<MemoryTicketDetailsScreen> {
  late Memory _memory;
  final GlobalKey _ticketKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _memory = widget.memory;
  }

  void _showDeleteDialog(BuildContext context) {
    AppDialogs.showConfirmationDialog(
      context: context,
      title: "Delete Memory",
      content: "Are you sure you want to delete this memory? This action cannot be undone and will also remove it from cloud storage.",
      confirmText: "Delete",
      confirmColor: Colors.redAccent,
      onConfirm: () {
        HapticFeedback.heavyImpact();
        context.read<MemoryBloc>().add(DeleteMemoryEvent(_memory.id));
        Navigator.pop(context); // Go back to Home
      },
    );
  }

  Future<void> _handleExport(Future<void> Function(GlobalKey, Memory) exportMethod) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Processing ticket..."),
        duration: Duration(seconds: 1),
      ),
    );
    try {
      await exportMethod(_ticketKey, _memory);
    } catch (e) {
      if (mounted) {
        log("memoryTicketDetailsPage : ${e}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Export failed: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Ticket Stub"),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 16),

                    // Wrap the ticket card in RepaintBoundary for rasterization
                    RepaintBoundary(
                      key: _ticketKey,
                      child: MemoryTicketCard(
                        imagePath: _memory.imagePath,
                        title: _memory.title,
                        location: _memory.location,
                        date: _memory.date,
                        description: _memory.description,
                        isFavorite: _memory.isFavorite,
                        ticketType: _memory.ticketType,
                        heroTag: 'memory_image_${_memory.id}',
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
                              ticketType: _memory.ticketType,
                              isFavorite: !_memory.isFavorite,
                            );
                          });
                        },
                      ),
                    ),

                    // --- Action Control Row ---
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0, top: 16.0, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Share Button (Ultra-HD Image)
                          IconButton(
                            tooltip: "Share Ticket Image",
                            icon: const FaIcon(
                              FontAwesomeIcons.shareNodes,
                              size: 26,
                              color: Colors.black26,
                            ),
                            onPressed: () =>
                                _handleExport(TicketExportService.shareAsImage),
                          ),

                          // Edit Button
                          IconButton(
                            tooltip: "Edit Ticket",
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

                          // Delete Button
                          IconButton(
                            tooltip: "Delete Ticket",
                            icon: const Icon(
                              Icons.delete,
                              size: 26,
                              color: Colors.black26,
                            ),
                            onPressed: () => _showDeleteDialog(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
