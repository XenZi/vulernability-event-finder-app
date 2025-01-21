import 'package:flutter/material.dart';

enum PriorityLevel {
  high,
  medium,
  low,
  none;

  String get label => {
        PriorityLevel.high: 'High',
        PriorityLevel.medium: 'Medium',
        PriorityLevel.low: 'Low',
        PriorityLevel.none: 'No Priority',
      }[this]!;

  Color get color => {
        PriorityLevel.high: Colors.red,
        PriorityLevel.medium: Colors.orange,
        PriorityLevel.low: Colors.green,
        PriorityLevel.none: Colors.grey,
      }[this]!;
}
