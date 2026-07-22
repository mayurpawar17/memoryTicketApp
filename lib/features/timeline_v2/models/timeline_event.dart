import 'package:flutter/material.dart';

class TimelineEvent {
  final String year;
  final String title;
  final String description;
  final String image;
  final Alignment imageSide;
  final Color decorationColor;
  final String curvedLabel;

  const TimelineEvent({
    required this.year,
    required this.title,
    required this.description,
    required this.image,
    required this.imageSide,
    required this.decorationColor,
    required this.curvedLabel,
  });
}
