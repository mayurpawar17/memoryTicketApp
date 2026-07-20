import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memory_ticket_app/core/widgets/custom_app_bar.dart';
import 'package:memory_ticket_app/core/widgets/custom_button.dart';
import 'package:memory_ticket_app/features/memory/data/model/memory_model.dart';
import '../widgets/memory_ticket_card.dart';

class MemoryTicketDetailsScreen extends StatelessWidget {
  final MemoryModel memoryModel;

  const MemoryTicketDetailsScreen({super.key, required this.memoryModel});

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
              imageUrl: memoryModel.imageUrl,
              title: memoryModel.title,
              location: memoryModel.location,
              date: memoryModel.date,
              description: memoryModel.description,
              isFavorite: memoryModel.isFavorite,
              // onTap: () {},
              // onFavorite: () {},
              // onMore: () {},
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
                    icon: FaIcon(
                      FontAwesomeIcons.download,
                      size: 26,
                      color: Colors.black26,
                    ),
                    onPressed: () {},
                  ),

                  // Central Primary Edit Button
                  CustomButton(label: "Edit", onPressed: () {}),

                  // Share Button
                  IconButton(
                    icon: FaIcon(
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
