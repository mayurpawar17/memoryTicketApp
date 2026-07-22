import 'package:flutter/material.dart';

class CategoryUtils {
  static final Map<String, IconData> categoryIcons = {
    'All': Icons.grid_view_rounded,
    'Travel': Icons.flight_takeoff_rounded,
    'Food': Icons.restaurant_rounded,
    'Friends': Icons.people_rounded,
    'Nature': Icons.eco_rounded,
    'Work': Icons.work_rounded,
    'Family': Icons.family_restroom_rounded,
    'Pets': Icons.pets_rounded,
    'Personal': Icons.person_rounded,
  };

  static IconData getIcon(String category) {
    return categoryIcons[category] ?? Icons.label_rounded;
  }
}
