import 'package:flutter/material.dart';

class MemoryTicketDetailsScreen extends StatelessWidget {
  final String imageUrl;
  const MemoryTicketDetailsScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // Defines where the ticket cuts out horizontally (69% down the canvas)
    const double splitRatio = 0.69;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Ticket Stub',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            // --- Premium Collectible Ticket Card ---
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.82,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withOpacity(0.1),
                      blurRadius: 40,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipPath(
                  clipper: StampTicketClipper(sidePunchYRatio: splitRatio),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Image Frame
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(imageUrl, fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Text Meta Hierarchy
                        const Text(
                          'Ghibli Park',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 12,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'Nagakute',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Icon(
                              Icons.calendar_today,
                              size: 11,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '2026.05.08',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Dynamic Dotted Line Separator
                        Row(
                          children: List.generate(
                            28,
                            (index) => Expanded(
                              child: Container(
                                color: index % 2 == 0
                                    ? Colors.transparent
                                    : Colors.grey[300],
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Memory Quote Stub Footprint
                        Icon(
                          Icons.format_quote,
                          size: 16,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Text(
                            "Howl's moving castle!",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                    icon: const Icon(
                      Icons.download_rounded,
                      color: Colors.white70,
                      size: 26,
                    ),
                    onPressed: () {},
                  ),

                  // Central Primary Edit Button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 44,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  // Share Button
                  IconButton(
                    icon: const Icon(
                      Icons.reply_rounded,
                      color: Colors.white70,
                      size: 26,
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

/// Custom Clipper matrix logic for the stamp ripple stubs and matching ticket alignment
class StampTicketClipper extends CustomClipper<Path> {
  final double sidePunchYRatio;

  const StampTicketClipper({required this.sidePunchYRatio});

  @override
  Path getClip(Size size) {
    final path = Path();
    const double rippleRadius = 4.0;
    const double sidePunchRadius = 8.0;

    // Top Stamp Cuts
    path.moveTo(0, 0);
    double x = 0;
    while (x < size.width) {
      path.lineTo(x + rippleRadius, 0);
      path.arcToPoint(
        Offset(x + (rippleRadius * 3), 0),
        radius: const Radius.circular(rippleRadius),
        clockwise: false,
      );
      x += rippleRadius * 4;
    }
    path.lineTo(size.width, 0);

    // Right Side Punch Cutout
    final double punchY = size.height * sidePunchYRatio;
    path.lineTo(size.width, punchY - sidePunchRadius);
    path.arcToPoint(
      Offset(size.width, punchY + sidePunchRadius),
      radius: const Radius.circular(sidePunchRadius),
      clockwise: false,
    );
    path.lineTo(size.width, size.height);

    // Bottom Stamp Cuts (Right to Left sweep)
    double bx = size.width;
    while (bx > 0) {
      path.lineTo(bx - rippleRadius, size.height);
      path.arcToPoint(
        Offset(bx - (rippleRadius * 3), size.height),
        radius: const Radius.circular(rippleRadius),
        clockwise: false,
      );
      bx -= rippleRadius * 4;
    }
    path.lineTo(0, size.height);

    // Left Side Punch Cutout
    path.lineTo(0, punchY + sidePunchRadius);
    path.arcToPoint(
      Offset(0, punchY - sidePunchRadius),
      radius: const Radius.circular(sidePunchRadius),
      clockwise: false,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
