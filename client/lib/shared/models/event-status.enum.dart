import 'package:flutter/material.dart';

enum EventStatus {
  discovered,
  acknowledged,
  removed,
  falsePositive; 

  String get label => {
        EventStatus.falsePositive: 'False Positive',
        EventStatus.removed: 'Removed',
        EventStatus.acknowledged: 'Acknowledged',
        EventStatus.discovered: 'Discovered',
      }[this]!;

  Color get color => {
        EventStatus.falsePositive: Colors.grey,
        EventStatus.removed: Colors.lime,
        EventStatus.acknowledged: Colors.yellow,
        EventStatus.discovered: Colors.amber,
      }[this]!;
}
