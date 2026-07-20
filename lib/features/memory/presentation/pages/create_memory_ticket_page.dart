import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memory_ticket_app/core/widgets/custom_app_bar.dart';
import 'package:memory_ticket_app/core/widgets/custom_button.dart';
import 'package:memory_ticket_app/core/widgets/custom_category_chips.dart';
import 'package:memory_ticket_app/features/memory/presentation/widgets/memory_ticket_card.dart';

class NewMemoryPage extends StatefulWidget {
  const NewMemoryPage({super.key});

  @override
  State<NewMemoryPage> createState() => _NewMemoryPageState();
}

class _NewMemoryPageState extends State<NewMemoryPage> {
  final List<String> _styles = ['Movie', 'Flight', 'Concert', 'Festival'];
  int _selectedStyleIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "New Memory"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- UPLOAD BOX ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1.5,
                    style: BorderStyle.solid,
                  ), // Uses a standard solid/clean finish frame
                ),
                child: Column(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.camera,
                      color: Colors.grey[400],
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tap to upload a photo',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'PNG, JPG UP TO 10MB',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- FORM FIELDS BLOCK ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormLabel('MEMORY TITLE'),
                    _buildTextField('Summer at the Amalfi Coast'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormLabel('DATE'),
                              _buildTextField(
                                'mm/dd/yyyy',
                                suffixIcon: Icons.calendar_today_outlined,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormLabel('LOCATION'),
                              _buildTextField('Positano, Italy'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildFormLabel('DESCRIPTION'),
                    _buildTextField(
                      'Describe the sights, sounds, and smells...',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormLabel('MOOD'),
                              _buildDropdownField('Serene'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormLabel('CATEGORY'),
                              _buildDropdownField('Travel'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // --- CHOOSE TICKET STYLE HIERARCHY ---
              Text(
                'CHOOSE TICKET STYLE',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),

              CustomCategoryChips(
                categories: _styles,
                selectedIndex: _selectedStyleIndex,
                onSelected: (index) {
                  setState(() => _selectedStyleIndex = index);
                },
              ),
              const SizedBox(height: 12),
              // const SizedBox(height: 32),

              // --- LIVE PREVIEW HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LIVE PREVIEW',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E7FD),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'DRAFT',
                      style: TextStyle(
                        color: Color(0xFF4E44E7),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // --- THE MEMORY TICKET CARD PREVIEW ---
              MemoryTicketCard(
                imageUrl:
                    'https://images.unsplash.com/photo-1475503572774-15a45e5d60b9?w=800',
                title: 'New Memory',
                location: 'Home Sanctuary',
                date: 'Oct 24, 2023',
                description:
                    'A moment captured in time, waiting for its story to be told...',
                isFavorite: false,
                // onTap: () {},
                // onFavorite: () {},
                // onMore: () {},
              ),
              const SizedBox(height: 16),

              // --- STYLING INFO BOX ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.auto_awesome_outlined,
                      color: Color(0xFF4E44E7),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'The "Flight" style adds a boarding pass aesthetic, perfect for long-distance journeys.',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- SAVE BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 54,
                child: CustomButton(
                  label: "Save Memory",
                  icon: Icons.save_outlined,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    IconData? suffixIcon,
    int maxLines = 1,
  }) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        fillColor: const Color(0xFFF4F6FA),
        filled: true,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, size: 18, color: Colors.black)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildDropdownField(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          items: [value]
              .map(
                (String val) => DropdownMenuItem(
                  value: val,
                  child: Text(val, style: const TextStyle(fontSize: 14)),
                ),
              )
              .toList(),
          onChanged: (_) {},
        ),
      ),
    );
  }

}

// --- EXACT SCREEN TICKET COMPONENT ---
class MemoryPreviewTicketCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String date;
  final String description;

  const MemoryPreviewTicketCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.date,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Top Image Half Container
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'MOVIE TICKET',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // White Details Stub Body
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMetaLabel('DATE / TIME'),
                            Text(
                              date,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildMetaLabel('MEMORY NOTE'),
                            Text(
                              '"$description"',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontStyle: FontStyle.italic,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMetaLabel('LOCATION'),
                            Text(
                              location,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Custom Vertical Ticket Perforation Divider Line
                      Container(
                        height: 90,
                        width: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        color: Colors.grey[300],
                      ),

                      // Boarding Pass Column Side-Bar
                      Column(
                        children: [
                          const RotatedBox(
                            quarterTurns: 1,
                            child: Text(
                              'ADMIT ONE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Icon(
                            Icons.qr_code_2,
                            size: 20,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'MT-992',
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Bottom Highlight Border Accent Strip
            Container(height: 6, color: const Color(0xFF4E44E7)),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.grey[400],
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
