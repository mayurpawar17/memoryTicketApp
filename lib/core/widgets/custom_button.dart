import 'package:flutter/material.dart';
import 'package:memory_ticket_app/core/colors/app_colors.dart';

import 'app_spacing.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isOutlined;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: isOutlined ? Colors.transparent : AppColors.primary,
      foregroundColor: isOutlined ? AppColors.primary : AppColors.background,
      side: isOutlined
          ? const BorderSide(color: AppColors.primary, width: 1.5)
          : null,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.lg,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
    );

    if (icon != null) {
      return ElevatedButton.icon(
        style: buttonStyle,
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: Colors.white),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
      );
    }

    return ElevatedButton(
      style: buttonStyle,
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
    );
  }
}
