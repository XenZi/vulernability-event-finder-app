import 'package:flutter/material.dart';

enum Priority {
  high,
  medium,
  low,
  none;

  String get label => {
        Priority.high: 'High',
        Priority.medium: 'Medium',
        Priority.low: 'Low',
        Priority.none: 'No Priority',
      }[this]!;

  Color get color => {
        Priority.high: Colors.red,
        Priority.medium: Colors.orange,
        Priority.low: Colors.green,
        Priority.none: Colors.grey,
      }[this]!;
}
