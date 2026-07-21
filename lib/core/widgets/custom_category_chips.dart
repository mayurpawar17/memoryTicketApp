import 'package:flutter/material.dart';
import 'package:memory_ticket_app/core/colors/app_colors.dart';

class CustomCategoryChips extends StatelessWidget {
  /// The list of strings to display as chips
  final List<String> categories;

  /// Optional list of icons corresponding to each category
  final List<IconData>? icons;

  /// The currently active index matching the parent's state
  final int selectedIndex;

  /// Callback function triggered whenever a new chip is selected
  final ValueChanged<int> onSelected;

  /// Horizontal padding for the start and end of the scrollable list
  final double horizontalPadding;

  const CustomCategoryChips({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
    this.icons,
    this.horizontalPadding = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          final icon = icons != null && icons!.length > index ? icons![index] : null;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              avatar: icon != null
                  ? Icon(
                      icon,
                      size: 16,
                      color: isSelected ? Colors.white : theme.primaryColor,
                    )
                  : null,
              label: Text(categories[index]),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) {
                  onSelected(index);
                }
              },
              selectedColor: AppColors.primary,
              backgroundColor: theme.colorScheme.surface,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : theme.textTheme.bodyLarge?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: isSelected
                      ? Colors.transparent
                      : theme.dividerColor.withOpacity(0.08),
                ),
              ),
              showCheckmark: false,
              elevation: isSelected ? 4 : 0,
              shadowColor: theme.colorScheme.primary.withOpacity(0.3),
            ),
          );
        },
      ),
    );
  }
}