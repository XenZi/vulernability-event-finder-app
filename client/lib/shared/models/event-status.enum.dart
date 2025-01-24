import 'package:flutter/material.dart';

enum EventStatus {
  falsePositive,
  removed,
  acknowledged,
  discovered;

  String get label => {
        EventStatus.discovered: 'Discovered',
        EventStatus.acknowledged: 'Acknowledged',
        EventStatus.removed: 'Removed',
        EventStatus.falsePositive: 'False Positive',
      }[this]!;

  Color get color => {
        EventStatus.discovered: Colors.amber,
        EventStatus.acknowledged: Colors.yellow,
        EventStatus.removed: Colors.lime,
        EventStatus.falsePositive: Colors.grey,
      }[this]!;
}
