import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../colors/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.systemOverlayStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
      actions: actions,
      leading: leading ?? _buildDefaultLeading(context),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 1.0, // Clean Material 3 elevation tint on scroll
      systemOverlayStyle: systemOverlayStyle ?? SystemUiOverlayStyle.dark,
      surfaceTintColor: Colors.transparent,
    );
  }

  Widget? _buildDefaultLeading(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;

    // Only show back button if the route can actually pop
    if (!canPop) return null;

    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
      onPressed: () => Navigator.of(context).pop(),
      splashRadius: 24,
    );
  }

  // This is required by PreferredSizeWidget.
  // kToolbarHeight is the standard 56.0dp in Flutter.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}