import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final config = TicketStyleConfig.fromType(ticketType);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        clipper: config.clipper,
        child: Material(
          color: config.backgroundColor,
          child: InkWell(
            onTap: onTap,
            splashColor: config.accentColor.withOpacity(0.04),
            highlightColor: Colors.transparent,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Column(
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
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: config.textColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                  fontFamily: config.fontFamily,
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
                                  Expanded(
                                    child: Text(
                                      location,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: config.secondaryTextColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
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
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Text(
                                  description,
                                  style: TextStyle(
                                    color: config.secondaryTextColor,
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (config.showBarcode) _buildBarcode(config),
                              if (config.showBarcode) const SizedBox(height: 10),
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
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      if (onFavorite != null) onFavorite!();
                                    },
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                  ),
                                  if (config.secondaryIcon != null)
                                    Icon(
                                      config.secondaryIcon,
                                      size: 16,
                                      color: config.accentColor.withOpacity(0.3),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (ticketType == TicketType.flightBoardingPass)
                      Positioned(
                        right: 80,
                        top: 0,
                        bottom: 0,
                        child: CustomPaint(
                          painter: DashedLinePainter(
                            color: config.accentColor.withOpacity(0.2),
                          ),
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

  Widget _buildBarcode(TicketStyleConfig config) {
    return Container(
      height: 40,
      width: double.infinity,
      child: Row(
        children: List.generate(
          40,
          (index) => Expanded(
            flex: (index % 3 == 0) ? 2 : 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              color: index % 2 == 0 ? config.textColor.withOpacity(0.8) : Colors.transparent,
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

class DashedLinePainter extends CustomPainter {
  final Color color;
  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
