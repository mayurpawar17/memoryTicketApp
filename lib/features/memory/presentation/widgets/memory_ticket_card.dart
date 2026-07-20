import 'package:flutter/material.dart';

class MemoryTicketCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String date;
  final String description;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onMore;

  const MemoryTicketCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.date,
    required this.description,
    required this.isFavorite,
    this.onTap,
    this.onFavorite,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Explicit positioning split matrix matched exactly to the clipper
    const double splitRatio = 0.69;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipPath(
        clipper: const StampTicketClipper(sidePunchYRatio: splitRatio),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: onTap,
            splashColor: theme.primaryColor.withOpacity(0.04),
            highlightColor: Colors.transparent,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- TOP SECTION: Visuals & Meta Typography ---
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    Container(color: Colors.grey[200]),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            title,
                            style: const TextStyle(
                              color: Color(0xFF222222),
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
                                location,
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
                                date,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // --- MITER LAYER: Dotted Axis Separator ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: List.generate(
                          (constraints.maxWidth / 7).floor(),
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
                    ),

                    // --- BOTTOM SECTION: Journal Entry & Controls ---
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.format_quote,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 6.0,
                              right: 6.0,
                            ),
                            child: Text(
                              description,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite
                                      ? Colors.redAccent
                                      : Colors.grey[400],
                                ),
                                onPressed: onFavorite,
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.grey[400],
                                ),
                                onPressed: onMore,
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Precise pathing matrix to construct physical top/bottom perforation cuts
class StampTicketClipper extends CustomClipper<Path> {
  final double sidePunchYRatio;
  const StampTicketClipper({required this.sidePunchYRatio});

  @override
  Path getClip(Size size) {
    final path = Path();
    const double rippleRadius = 4.0;
    const double sidePunchRadius = 8.0;

    // Top Header Edge Stamp Perforations
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

    // Right Side Dynamic Alignment Border Punch
    final double punchY = size.height * sidePunchYRatio;
    path.lineTo(size.width, punchY - sidePunchRadius);
    path.arcToPoint(
      Offset(size.width, punchY + sidePunchRadius),
      radius: const Radius.circular(sidePunchRadius),
      clockwise: false,
    );
    path.lineTo(size.width, size.height);

    // Bottom Base Stamp Perforations (Reverse Sweep Axis)
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

    // Left Side Dynamic Alignment Border Punch
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
