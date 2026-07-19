import 'package:flutter/material.dart';

class CategoryChips extends StatefulWidget {
  const CategoryChips({super.key});

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  final List<String> _categories = [
    'All',
    'Travel',
    'Food',
    'Friends',
    'Nature',
    'Work',
    'Family',
    'Pets',
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(_categories[index]),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  _selectedIndex = selected ? index : _selectedIndex;
                });
              },
              selectedColor: theme.colorScheme.primary,
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
