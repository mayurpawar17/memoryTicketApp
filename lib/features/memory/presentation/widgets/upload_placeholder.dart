import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UploadPlaceholder extends StatelessWidget {
  /// The main label action text (e.g., "Tap to upload a photo")
  final String title;

  /// The helper hint text at the bottom (e.g., "PNG, JPG UP TO 10MB")
  final String subtitle;

  /// The icon displayed at the top of the placeholder box
  final FaIconData icon;

  /// Callback trigger when the user presses anywhere inside the boundary
  final VoidCallback onTap;

  /// The selected image path (can be local file path or network URL)
  final String? imagePath;

  const UploadPlaceholder({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(12);

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        splashColor: theme.colorScheme.primary.withOpacity(0.05),
        highlightColor: theme.colorScheme.primary.withOpacity(0.02),
        child: Container(
          width: double.infinity,
          padding: imagePath != null
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: borderRadius,
            border: Border.all(
              color: theme.dividerColor.withOpacity(0.15) ?? Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: imagePath != null
                ? Stack(
                    children: [
                      _buildImage(),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          radius: 16,
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    // Prevents blowing up if placed inside lists
                    children: [
                      FaIcon(
                        icon,
                        color:
                            theme.hintColor.withOpacity(0.5) ?? Colors.grey[400],
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ) ??
                            const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: theme.hintColor.withOpacity(0.5) ??
                                  Colors.grey[400],
                            ) ??
                            TextStyle(
                              fontSize: 11,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imagePath == null) return const SizedBox.shrink();

    final bool isNetwork = imagePath!.startsWith('http');

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 200,
      ),
      child: isNetwork
          ? CachedNetworkImage(
              imageUrl: imagePath!,
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
                alignment: Alignment.center,
                child: const Icon(Icons.error_outline, color: Colors.black26),
              ),
            )
          : Image.file(
              File(imagePath!),
              fit: BoxFit.contain,
              width: double.infinity,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) return child;
                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  child: child,
                );
              },
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[100],
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image_outlined,
                    color: Colors.black26),
              ),
            ),
    );
  }
}
