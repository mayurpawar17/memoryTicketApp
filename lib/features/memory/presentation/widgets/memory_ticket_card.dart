import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/ticket_type.dart';
import 'ticket_style_config.dart';

class MemoryTicketCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String location;
  final String date;
  final String description;
  final bool isFavorite;
  final TicketType ticketType;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onMore;
  final String? heroTag;

  const MemoryTicketCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.location,
    required this.date,
    required this.description,
    required this.isFavorite,
    this.ticketType = TicketType.classicTicket,
    this.onTap,
    this.onFavorite,
    this.onMore,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = TicketStyleConfig.fromType(ticketType);

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
        clipper: StampTicketClipper(sidePunchYRatio: config.sidePunchYRatio),
        child: Material(
          color: config.backgroundColor,
          child: InkWell(
            onTap: onTap,
            splashColor: config.accentColor.withOpacity(0.04),
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
                          Stack(
                            children: [
                              Hero(
                                tag: heroTag ?? 'memory_image_${title}_$date',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: _buildImage(),
                                ),
                              ),
                              if (config.mainIcon != null)
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      config.mainIcon,
                                      color: config.accentColor,
                                      size: 20,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            title,
                            style: TextStyle(
                              color: config.textColor,
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
                                color: config.secondaryTextColor,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                location,
                                style: TextStyle(
                                  color: config.secondaryTextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Icon(
                                Icons.calendar_today,
                                size: 11,
                                color: config.secondaryTextColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                date,
                                style: TextStyle(
                                  color: config.secondaryTextColor,
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
                                  : config.accentColor.withOpacity(0.2),
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
                            color: config.accentColor.withOpacity(0.3),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 6.0,
                              right: 6.0,
                            ),
                            child: Text(
                              description,
                              style: TextStyle(
                                color: config.secondaryTextColor,
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
                                      : config.secondaryTextColor.withOpacity(0.5),
                                ),
                                onPressed: onFavorite,
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: config.secondaryTextColor.withOpacity(0.5),
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

  Widget _buildImage() {
    final bool isNetwork =
        imagePath.startsWith('http') || imagePath.startsWith('https');

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 180,
      ),
      child: isNetwork
          ? CachedNetworkImage(
              imageUrl: imagePath,
              fit: BoxFit.contain,
              width: double.infinity,
              fadeInDuration: const Duration(milliseconds: 500),
              fadeOutDuration: const Duration(milliseconds: 300),
              placeholder: (context, url) => Container(
                color: Colors.grey[100],
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black12,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[100],
                width: double.infinity,
                alignment: Alignment.center,
                child: const Icon(Icons.error_outline,
                    size: 20, color: Colors.black26),
              ),
            )
          : imagePath.isNotEmpty
              ? Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                  width: double.infinity,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) return child;
                    return AnimatedOpacity(
                      opacity: frame == null ? 0 : 1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      child: child,
                    );
                  },
                  errorBuilder: (_, _, _) => Container(
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_outlined,
                        color: Colors.black26),
                  ),
                )
              : Container(
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  child: const Icon(Icons.image, color: Colors.grey),
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
