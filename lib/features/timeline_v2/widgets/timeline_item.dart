import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/colors/app_colors.dart';
import '../../memory/domain/entities/memory.dart';
import '../../memory/presentation/pages/memory_ticket_details_page.dart';
import 'timeline_decoration.dart';
import 'curved_label.dart';

class TimelineItem extends StatelessWidget {
  final Memory memory;
  final int index;
  final Animation<double> animation;

  const TimelineItem({
    super.key,
    required this.memory,
    required this.index,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLeft = index % 2 == 0;
    
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(animation),
        child: Container(
          height: 300,
          margin: const EdgeInsets.symmetric(vertical: 60),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                children: [
                  if (isLeft) _buildImageSection(context) else _buildTextSection(context, isLeft),
                  const Spacer(),
                  if (isLeft) _buildTextSection(context, isLeft) else _buildImageSection(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoryTicketDetailsScreen(memory: memory),
      ),
    );
  }

  String _getYear(String date) {
    try {
      final dateTime = DateFormat('MMM dd yyyy').parse(date);
      return dateTime.year.toString();
    } catch (e) {
      return DateTime.now().year.toString();
    }
  }

  Color _getDecorationColor(int index) {
    final colors = [
      const Color(0xFFFF4D4D),
      const Color(0xFF4DDFBD),
      const Color(0xFFFFD93D),
      const Color(0xFF9B59B6),
      const Color(0xFF2ECC71),
      AppColors.primary,
    ];
    return colors[index % colors.length];
  }

  Widget _buildImageSection(BuildContext context) {
    final color = _getDecorationColor(index);
    return Expanded(
      flex: 5,
      child: Center(
        child: GestureDetector(
          onTap: () => _navigateToDetails(context),
          child: Stack(
            alignment: Alignment.center,
            children: [
              TimelineDecoration(
                color: color,
                type: DecorationType.values[index % DecorationType.values.length],
              ),
              CurvedLabel(
                text: memory.category.toUpperCase().padRight(20, ' • '),
                radius: 75,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: color.withOpacity(0.8),
                  letterSpacing: 3,
                ),
              ),
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.matrix([
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0,      0,      0,      1, 0,
                    ]),
                    child: _buildImage(memory.imagePath),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(color: Colors.grey[200]),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else if (imagePath.isNotEmpty) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.image, color: Colors.grey),
        ),
      );
    }
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }

  Widget _buildTextSection(BuildContext context, bool isLeft) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: EdgeInsets.only(
          left: isLeft ? 20 : 40,
          right: isLeft ? 40 : 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(
              _getYear(memory.date),
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                height: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              memory.title.toUpperCase(),
              textAlign: isLeft ? TextAlign.left : TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              memory.description,
              textAlign: isLeft ? TextAlign.left : TextAlign.right,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (memory.location.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
                children: [
                  Icon(Icons.location_on, size: 12, color: AppColors.textSecondary.withOpacity(0.6)),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      memory.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
