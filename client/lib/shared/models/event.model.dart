import 'package:client/shared/models/event-status.enum.dart';
import 'package:client/shared/models/priority.enum.dart';

class Event {
  final int id;
  final String uuid;
  final EventStatus status;
  final String host;
  final String port;
  final PriorityLevel priority;
  final String categoryName;
  final DateTime creationDate;
  final DateTime lastOccurrence;
  final int assetId;

  Event({
    required this.id,
    required this.uuid,
    required this.status,
    required this.host,
    required this.port,
    required this.priority,
    required this.categoryName,
    required this.creationDate,
    required this.lastOccurrence,
    required this.assetId,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      uuid: json['uuid'],
      status: EventStatus.values[json['status']],
      host: json['host'],
      port: json['port'],
      priority: PriorityLevel.values[json['priority']],
      categoryName: json['category_name'],
      creationDate: DateTime.parse(json['creation_date']),
      lastOccurrence: DateTime.parse(json['last_occurrence']),
      assetId: json['asset_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'status': status.index,
      'host': host,
      'port': port,
      'priority': priority.index,
      'category_name': categoryName,
      'creation_date': creationDate.toIso8601String(),
      'last_occurrence': lastOccurrence.toIso8601String(),
      'asset_id': assetId,
    };
  }
}
